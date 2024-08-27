classdef FTC < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vs % 階層２の入力を生成する関数ハンドル
    approx_z %zサブシステムのゲイン，近似パラメータ，alpha
end

methods

    function obj = FTC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
        obj.approx_z = obj.param.approx_z; %zサブシステムのゲイン，近似パラメータ，alpha
    end

    function result = do(obj,varargin)
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;

        P = obj.param.P;

        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);
        
        %z方向:FT
        z1 = Z1(x, xd', P);%z
        if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
            dt = varargin{1}.dt;
        else
            dt = obj.param.dt;
        end
        % vf = Vfd(dt,x,xd',P,obj.param.F1);%線形入力
        vf = Vzft(obj.approx_z,z1);%近似FTC
        %x,y,psiの状態変数の値
        z2 = Z2(x, xd', vf, P); %x方向
        z3 = Z3(x, xd', vf, P); %y方向
        z4 = Z4(x, xd', vf, P); %yaw
        vs = obj.Vs(z2,z3,z4);%FTC or approx.FTC
        %検証用
%      vf(1)=-F1*(sign(z1).*abs(z1).^az(1:2));%z近似なし
        % vs(3) = -F4 * z4; %yaw:LS
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs, P);
        %input of subsystems
        obj.result.uHL = [vf(1); vs];
        %differential virtual input first layer
        obj.result.vf = vf;
        %state of subsystems
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
      % max,min are applied for the safty
        obj.result.input =[max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%外乱用
        result = obj.result;
    end

    function show(obj)
        obj.result
    end
end

methods(Static)
    %近似パラメータのload，作成，描画を行うmethod
     function p = paramSetting(txt,r, a, b, k, alp,x0, fNewParam, fConfirmFig)
        filename="appox_FTC_param_"+txt+".mat";%loadするファイル名
        val = "params_"+txt;%loadまたはsaveする配列
        fExist=exist(filename,'file');%近似のパラメータが保存されているのか
        if fExist
            valuesb= load(filename,val).(val);
            p = valuesb.p; %近似のパラメータを代入
        end
        if ~fExist || fNewParam %保存されていないまたは新しく更新する場合
            new = FTC.approx_FTC_param(txt, r, a, b, k, alp, x0);%新しいパラメータを計算
            p=new.p;%近似のパラメータを代入
            eval([char(val) '= new;']);%保存する名前を付ける
            savePath = fullfile(pwd,"controller/FTC",filename);%保存するパスを設定
            save(savePath,val);%パラメータを保存 : [パラメータ，FTCとの誤差，近似する区間，制約の大きさ，緩和区間，ゲイン，yyyyyalpha]
            % whos("-file",filename);
        elseif fConfirmFig ==1
            FTC.confirmParam(txt, valuesb.k, valuesb.p, valuesb.alp);%近似した入力を確認, パラメータが新しく作成される場合は実行されない
        end
     end
    %近似パラメータを求めるmethod
    function [ps, p]=approx_FTC_param(txt, r, a, b, k, alp, x0)
        % 有限整定の近似微分　一層   
            if length(k)==2
                j=2;%z,yaw方向サブシステムの緩和
                name =[txt,"d"+txt];
                row=1;
            else
                j=4;%x,y方向サブシステムの緩和
                name = [txt,"d"+txt,"dd"+txt,"ddd"+txt];
                row=2;
            end
            for i = 1:j
                 %tanh absolute
                 %1.近似範囲を決める2.a,bで調整(bの大きさを大きくするとFTからはがれにくくなる．aも同様だがFT,LSの近似範囲を見て調整)
                fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alp(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), r ,r+a(i)) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0, r));
                c =@(x)0;
                ceq = @(x) 1 - x(1).*x(2).^(alp(i)./2)+b(i);
                nonlinfcn = @(x)deal(c(x),ceq(x));
                options = optimoptions("fmincon",...
                    "Algorithm","interior-point",...
                    "EnableFeasibilityMode",true,...
                    "SubproblemAlgorithm","cg");
                
                [p(i,:),fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
                fval2(i) = 2 * fval%誤差の大きさの確認,最適化は正方向のみで行うため2倍している
    
                %figureで緩和区間を確認
                    e = -0.1 : 0.001 : 0.1;
                    usgnabs = -k(i).*tanh(p(i,1).*e).*sqrt(e.^2 + p(i,2)).^alp(i);
                    u = -k(i).*sign(e).*abs(e).^alp(i);
                    uk= -k(i).*e;
                    
                    subplot(row,2,i);%1枚ずつ表示する場合はfigure(i)に変更する
                    plot(e,usgnabs, 'LineWidth', 2.5);
                    hold on
                    grid on
                    plot(e,u, 'LineWidth', 2.5);
                    plot(e,uk, 'LineWidth', 2.5);
                    legend("Approximation","Finite time settling","Linear state FB");
                    fosi=15;%defolt 9
                    set(gca,'FontSize',fosi)
                    xlabel(name(i),'FontSize',fosi);
                    ylabel('input','FontSize',fosi);
                    hold off
            end
            ps = struct("p",p,"fval2",fval2,"r",r,"a",a,"b",b,"k",k,"alp",alp,"x0",x0);%構造体に格納:[パラメータ，ゲイン，FTCとの誤差，近似する区間，制約の大きさ，緩和区間，alpha]
            p = ps.p;
            fprintf("Is this paramaters of "+txt+" OK ? \nIf It's OK, push the Enter key. \nIf It's NO, push ""ctrl + C \"".");
            input("");
            close all
    end
    %描画するmethod
    function confirmParam(txt, k,p,alp)
        % 有限整定の近似微分　一層   
            if length(k)==2
                j=2;%z,yaw方向サブシステムの緩和
                name =[txt,"d"+txt];
                row=1;
            else
                j=4;%x,y方向サブシステムの緩和
                name = [txt,"d"+txt,"dd"+txt,"ddd"+txt];
                row=2;
            end
            for i = 1:j
                %figureで緩和区間を確認
                    e = -0.1 : 0.001 : 0.1;
                    usgnabs = -k(i).*tanh(p(i,1).*e).*sqrt(e.^2 + p(i,2)).^alp(i);
                    u = -k(i).*sign(e).*abs(e).^alp(i);
                    uk= -k(i).*e;
                    
                    subplot(row,2,i);%1枚ずつ表示する場合はfigure(i)に変更する
                    plot(e,usgnabs, 'LineWidth', 2.5);
                    hold on
                    grid on
                    plot(e,u, 'LineWidth', 2.5);
                    plot(e,uk, 'LineWidth', 2.5);
                    legend("Approximation","Finite time settling","Linear state FB");
                    fosi=15;%defolt 9
                    set(gca,'FontSize',fosi)
                    xlabel(name(i),'FontSize',fosi);
                    ylabel('input','FontSize',fosi);
                    hold off
            end
            fprintf("If you confirmed paramaters of "+txt+", push the Enter key.");
            input("");
            close all
    end

end
end