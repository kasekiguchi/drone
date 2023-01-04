classdef APPRO_C < CONTROLLER_CLASS
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    Uthrust
end

methods
%
    function obj = APPRO_C(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
%         obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
%         obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル
        obj.Uthrust = param.Uthrust; % 階層２の入力を生成する関数ハンドル
    end

    function result = do(obj, param, ~)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        x = [model.state.getq('compact'); model.state.p; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd = ref.state.get();
        %状態を取得
            p = model.state.p  ;
            v = model.state.v  ;
            q = model.state.q  ;
            w = model.state.w  ;
        %refernceを取得
            refp = ref.state.p  ;
            refv = ref.state.v  ;
        % サブシステムの状態            
            Xs = [p(1) - refp(1); v(1) - refv(1);q(2);w(2)];
            Ys = [p(2) - refp(2); v(2) - refv(2);q(1);w(1)];
            Zs = [p(3) - refp(3); v(3) - refv(3)];
            Psis = [q(3);w(3)];

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

        % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
        % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);

        %% calc Z
%         z1 = Z1(x, xd', P);%z
%         vf = obj.Vf(z1, F1);
%         z2 = Z2(x, xd', vf, P);%x
%         z3 = Z3(x, xd', vf, P);%y
%         z4 = Z4(x, xd', vf, P);%yaw
%         vs = obj.Vs(z2, z3, z4, F2, F3, F4);

                    % Finite time settling controller
            ux = -F2*(sign(Xs).*abs(Xs).^ax); %tau_theta roll
            uy = -F3*(sign(Ys).*abs(Ys).^ay); %tau_phi pitch
            uz = -F1*(sign(Zs).*abs(Zs).^az); % f throtl
            upsi = -F4*(sign(Psis).*abs(Psis).^apsi);%tau_psi yaw

        % Linear state feedback controller
%             ux = -F2*Xs; %tau_theta roll
%             uy = -F3*Ys; %tau_phi pitch
%             uz = -F1*Zs; % f throtl
%             upsi = -F4*Psis;%tau_psi yaw
        %%
        dst=0;
%         t = param{1};
%         dst = 1;
        %確率的な外乱
%         rng("shuffle");
%                     dst = 1*randn(1);
%                     if t>=10 && t<=10.5
%                             dst=-3;
%                     end
        
% dst=-1*sin(2*pi*t/1);
 %特定の位置で外乱を与える
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
%                     end
        %% calc actual input
        
        tmp = obj.Uthrust(uz, ux, uy, upsi);
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4);dst];
        obj.self.input = obj.result.input;
        
%          %サブシステムの入力
%         obj.result.uHL = [vf(1);vs];
%         %サブシステムの状態
%         obj.result.z1 = z1;
%         obj.result.z2 = z2;
%         obj.result.z3 = z3;
%         obj.result.z4 = z4;
%         obj.result.vf = vf;
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
