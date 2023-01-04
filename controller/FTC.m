classdef FTC < CONTROLLER_CLASS
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    VfFT
    gain1
    gain2
    fzFT
    fzapr
    n
end

methods

    function obj = FTC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
        obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル
        %             obj.VfFT = param.VfFT;% 階層１の入力を生成する関数ハンドルFT用
        obj.gain1 = param.gain1; %tanh1
        obj.gain2 = param.gain2; %tanh2
        obj.fzapr = param.fzapr;

        if param.fxyapr == 1
            obj.n = 4;
        else
            obj.n = 1;
        end

    end

    function result = do(obj, param, ~)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        x = [model.state.getq('compact'); model.state.p; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd = ref.state.get();

%         Param = obj.param;
        P = obj.param.P;
        F1 = obj.param.F1;
        F2 = obj.param.F2;
        F3 = obj.param.F3;
        F4 = obj.param.F4;
        %             F2=[3.16,6.79,40.54,12.27];%ゲイン
%         F2 = F2;
        %             F3=[3.16,6.79,40.54,12.27];%後でparamに格納
%         F3 = F3;
        %             kz=[2.23,2.28];
        %kz=F1;
        %             kpsi=[1.41,1.35];
%         kpsi = F4;
        %             ax=[0.692,0.75,0.818,0.9];%alpha
        %             ay=[0.692,0.75,0.818,0.9];
        %             az=[0.692,0.75];
        %             apsi=[0.692,0.75];
        ax = obj.param.ax;
        ay = obj.param.ay;
        az = obj.param.az;
        apsi = obj.param.apsi;

        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);

        %% calc Z
        z1 = Z1(x, xd', P);

        if obj.fzapr ~= 1
            %z方向:FB
            vf = obj.Vf(z1, F1); % % % % % % % % % % % % % % % % % % %xy
        else
            %z方向:FT
            vf = obj.Vf(z1); % % % % % % % % % % % % % % % % % %xyz
        end
        %x,y,psiの状態変数の値
        z2 = Z2(x, xd', vf, P); %x方向
        z3 = Z3(x, xd', vf, P); %y方向
        z4 = Z4(x, xd', vf, P); %yaw
        %vs = obj.Vs(z2,z3,z4,F2,F3,F4);
%         z2(3) = z2(3)-1*randn(1);
%         z2(4) = z2(4)-1*randn(1);
        %% x,y,psiの入力
        % 1:有限整定 4:tanh1 5:tanh2 （2,3は使わない）
        % gain_xy=2;%1m/s^2なら2くらいがいい
        switch obj.n
            case 1
                %有限整定
%                         ux = - F2(1) * sign(z2(1)) * abs(z2(1))^ax(1) -F2(2) * sign(z2(2)) * abs(z2(2))^ax(2) -F2(3) * sign(z2(3)) * abs(z2(3))^ax(3) -F2(4) * sign(z2(4)) * abs(z2(4))^ax(4); %（17）式
%                         uy = -  F3(1) * sign(z3(1)) * abs(z3(1))^ay(1) -F3(2) * sign(z3(2)) * abs(z3(2))^ay(2) -F3(3) * sign(z3(3)) * abs(z3(3))^ay(3) -F3(4) * sign(z3(4)) * abs(z3(4))^ay(4); %(19)式
                        ux=-F2*(sign(z2).*abs(z2).^ax(1:4));
                        uy=-F3*(sign(z3).*abs(z3).^ay(1:4));
%仮想入力に外乱を入れる
%                         ux = ux +1*randn(1);
                %併用
%                         ux= -F2(1)*sign(z2(1))*abs(z2(1))^ax(1) -F2(2)*sign(z2(2))*abs(z2(2))^ax(2) -F2(3)*sign(z2(3))*abs(z2(3))^ax(3) -F2(4)*sign(z2(4))*abs(z2(4))^ax(4) -F2*z2;%（17）式
%                         uy= -F3(1)*sign(z3(1))*abs(z3(1))^ay(1) -F3(2)*sign(z3(2))*abs(z3(2))^ay(2) -F3(3)*sign(z3(3))*abs(z3(3))^ay(3) -F3(4)*sign(z3(4))*abs(z3(4))^ay(4) -F3*z3;%(19)式
%                             ux=-F2*z2;%+1*randn(1);
%                             uy=-F3*z3;
%             case 2
                %近似1(sgnを近似)
                %           a=6;%a>2,alpha=0.9,a=6の時いい感じになる.６月の報告会
                %             ux=-F2(1)*tanh(a*z2(1))*abs(z2(1))^ax(1)-(F2(2)*tanh(a*z2(2))*abs(z2(2))^ax(2))-(F2(3)*tanh(a*z2(3))*abs(z2(3))^ax(3))-(F2(4)*tanh(a*z2(4))*abs(z2(4))^ax(4))-F2(1)*z2(1);%-F2*z2;%（17）式
                %             uy=-F3(1)*tanh(a*z3(1))*abs(z3(1))^ay(1)-(F3(2)*tanh(a*z3(2))*abs(z3(2))^ay(2))-(F3(3)*tanh(a*z3(3))*abs(z3(3))^ay(3))-(F3(4)*tanh(a*z3(4))*abs(z3(4))^ay(4))-F3(1)*z3(1);%-F3*z3;%(19)式
%             case 3
                %近似2(|x|^alphaを近似＋併用)
                %           a=1.2;%a>1(1だと0の近くでfbと同じになる)
                %             ux=-F2(1)*tanh(a*z2(1))-F2(2)*tanh(a*z2(2))-F2(3)*tanh(a*z2(3))-F2(4)*tanh(a*z2(4))-F2*z2;%F2(1)*z2(1);%（17）式
                %             uy=-F3(1)*tanh(a*z3(1))-F3(2)*tanh(a*z3(2))-F3(3)*tanh(a*z3(3))-F3(4)*tanh(a*z3(4))-F3*z3;%F3(1)*z3(1);%(19)式
                %             ux=-F2(1)*tanh(a*z2(1))-F2(2)*tanh(a*z2(2))-F2(3)*tanh(a*z2(3))-F2(4)*tanh(a*z2(4))-F2(1)*z2(1);%（17）式
                %             uy=-F3(1)*tanh(a*z3(1))-F3(2)*tanh(a*z3(2))-F3(3)*tanh(a*z3(3))-F3(4)*tanh(a*z3(4))-F3(1)*z3(1);%(19)式
            case 4
                %近似3 tanh1
                %近似普通誤差0.1x
                %             g = [0.105, 0.08, 0.055, 0.028];
                %             a = [20, 18, 16, 15];
                %             f= F2.*g;%F3.*gも同じ値
                %近似Fbとの入力誤差が一番大きくなるところ[0.3, 0.3160, 0.3320, 0.3490]での近似x
                %         g = [0.135, 0.105, 0.075, 0.035];
                %         a = [9.5, 9, 9.5, 9.5];
                %最小化で求める
                f = obj.gain1(:, 1);
                a = obj.gain1(:, 2);
                kapr = obj.gain1(:, 3)';
                gain_xy = 1;
%                             ux=-f(1)*tanh(a(1)*z2(1))-f(2)*tanh(a(2)*z2(2))-f(3)*tanh(a(3)*z2(3))-f(4)*tanh(a(4)*z2(4))-F2*z2;%-F2*z2;%（17）式
%                             uy=-f(1)*tanh(a(1)*z3(1))-f(2)*tanh(a(2)*z3(2))-f(3)*tanh(a(3)*z3(3))-f(4)*tanh(a(4)*z3(4))-F3*z3;%-F2*z2;%（17）式
                ux = -gain_xy * f(1) * tanh(a(1) * z2(1)) - f(2) * tanh(a(2) * z2(2)) - f(3) * tanh(a(3) * z2(3)) - f(4) * tanh(a(4) * z2(4)) - kapr * z2; %-F2*z2; %（17）式
                uy = -gain_xy * f(1) * tanh(a(1) * z3(1)) - f(2) * tanh(a(2) * z3(2)) - f(3) * tanh(a(3) * z3(3)) - f(4) * tanh(a(4) * z3(4)) - kapr * z3; %-F2*z2; %（17）式
                %              ux=-f(1)*tanh(a(1)*z2(1))-f(2)*tanh(a(2)*z2(2))-F2*z2;%-F2*z2;%（17）式
                %             uy=-f(1)*tanh(a(1)*z3(1))-f(2)*tanh(a(2)*z3(2))-F3*z3;%-F2*z2;%（17）式

                %-F3*z3;%(19)式
            case 5
                % 近似4tanh2
                f1 = obj.gain2(:, 1);
                a1 = obj.gain2(:, 2);
                f2 = obj.gain2(:, 3);
                a2 = obj.gain2(:, 4);
                ux = -f1(1) * tanh(a1(1) * z2(1)) - f2(1) * tanh(a2(1) * z2(1)) -f1(2) * tanh(a1(2) * z2(2)) - f2(2) * tanh(a2(2) * z2(2)) -f1(3) * tanh(a1(3) * z2(3)) - f2(3) * tanh(a2(3) * z2(3)) -f1(4) * tanh(a1(4) * z2(4)) - f2(4) * tanh(a2(4) * z2(4)) - F2 * z2; %-F2*z2; %（17）式
                uy = -f1(1) * tanh(a1(1) * z3(1)) - f2(1) * tanh(a2(1) * z3(1)) -f1(2) * tanh(a1(2) * z3(2)) - f2(2) * tanh(a2(2) * z3(2)) -f1(3) * tanh(a1(3) * z3(3)) - f2(3) * tanh(a2(3) * z3(3)) -f1(4) * tanh(a1(4) * z3(4)) - f2(4) * tanh(a2(4) * z3(4)) - F3 * z3; %-F3*z3; %（17）式
        end

        %upsi:HL or FT
        upsi = -F4 * z4; %HL
        %             upsi=-kpsi(1)*sign(z4(1))*abs(z4(1))^apsi(1)-kpsi(2)*sign(z4(1))*abs(z4(1))^apsi(2);%F4*Z4;%今回はこれで()%FT
        %
        %% 外乱(加速度で与える)
        %=======================================
        %定常外乱：並進方向は0.2m/s^2くらい，回転方向は3rad/s^2(180deg/s^2)
        %=======================================
                    dst = 1;
                    %確率の外乱
%                     rng("shuffle");
                    a = 1;%外乱の大きさの上限
                    dst = 2*a*rand-a;
        %             if t>=1
        %                 dst=0;
        %             end
        %             dst_y = 0;
        %             dst_z=0;
%                 t = param{1};
%                     dst=-1*sin(2*pi*t/1);%
        %             dst=dst+10*cos(2*pi*t/1);
        %一時的な外乱
%         t = param{1};
%         dst = 0;
%                     if t>=10 && t<=10.5
%                             dst=-3;
%                     end
        %特定の位置で外乱を与える
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
%                     end
        %%
        vs = [ux, uy, upsi];
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs', P);
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4); dst];
        obj.self.input = obj.result.input;
        %サブシステムの入力
        obj.result.uHL = [vf(1); ux; uy; upsi];
        %サブシステムの状態
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        obj.result.vf = vf;
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
