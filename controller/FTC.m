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
    pdst 
    fRandn =0;%確率seedを指定．同じ確率の値でできる
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
            obj.n = 2;
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
            %z方向:LS
            vf = obj.Vf(z1, F1); 
        else
            %z方向:FT
            vf = obj.Vf(z1); 
        end
        %x,y,psiの状態変数の値
        z2 = Z2(x, xd', vf, P); %x方向
        z3 = Z3(x, xd', vf, P); %y方向
        z4 = Z4(x, xd', vf, P); %yaw
        
        %% x,y,psiの入力
        % 1:有限整定 4:tanh1 5:tanh2 （2,3は使わない）
        % gain_xy=2;%1m/s^2なら2くらいがいい
        switch obj.n
            case 1
                %有限整定
%                         vf(1)=-F1*(sign(z1).*abs(z1).^az(1:2));%zの近似なし
                        ux=-F2*(sign(z2).*abs(z2).^ax(1:4));
                        uy=-F3*(sign(z3).*abs(z3).^ay(1:4));

%                         uxl=-F2*z2;
%                         uyl=-F3*z3;
%                         %LS,FTで大きい方を入力とする
%                         ux = max(ux,uxl);
%                         uy = max(uy,uyl);
            case 2
                %近似
                f = obj.gain1(:, 1);%tanhのゲイン
                a = obj.gain1(:, 2);%tanhの変化
                kapr = obj.gain1(:, 3)';%比例項のゲイン
                ux = - f(1) * tanh(a(1) * z2(1)) - f(2) * tanh(a(2) * z2(2)) - f(3) * tanh(a(3) * z2(3)) - f(4) * tanh(a(4) * z2(4)) - kapr * z2; %-F2*z2; %（17）式
                uy = - f(1) * tanh(a(1) * z3(1)) - f(2) * tanh(a(2) * z3(2)) - f(3) * tanh(a(3) * z3(3)) - f(4) * tanh(a(4) * z3(4)) - kapr * z3; %-F2*z2; %（17）式
             %この近似方法でもよさそう
%                 ux=-F2*tanh(a.*z2).*sqrt(z2.^2 + b).^ax(1:4);
%                 uy=-F3*tanh(a.*z3).*sqrt(z3.^2 + b).^ay(1:4);
        end

        %upsi:HL or FT
        upsi = -F4 * z4; %HL
%         upsi=-F4*(sign(z4).*abs(z4).^apsi(1:2));
        %% 外乱(加速度で与える)
                    dst = 1;
        %-----------------------------------------------------------------
                    %確率の外乱
%                     rng("shuffle");
%                     a = 1;%外乱の大きさの上限
%                     dst = 2*a*rand-a;
%
                    %平均b、標準偏差aのガウスノイズ
%                     if ~obj.fRandn%最初のループでシミュレーションで使う分の乱数を作成
%                           rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
%                           a = 1;%標準偏差
%                           b = 0;%平均
%                           c = param{2}/obj.self.plant.dt +1 ;%ループ数を計算param{2}はシミュレーション時間
%                           obj.pdst = a.*randn(c,1) + b;%ループ数分の値の乱数を作成
%                           obj.fRandn = 1;
%                     end
%                     dst = obj.pdst(obj.fRandn);
%                     obj.fRandn = obj.fRandn+1;%乱数の値を更新
        %-----------------------------------------------------------------
                    %一時的な外乱
%         t = param{1};
%         dst = 0;
%                     if t>=2 && t<=5.33
%                             dst= 0.6;
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
