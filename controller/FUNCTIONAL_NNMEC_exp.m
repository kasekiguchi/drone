classdef FUNCTIONAL_NNMEC_exp < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    NNMEC
    x_pre
    input_pre
    origin_input
    c
end

methods

    function obj = FUNCTIONAL_NNMEC_exp(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
        obj.result.origin_input = zeros(4,1);
        obj.result.delta_u = zeros(4,1);
        cast(predict(obj.param.NNMEC, zeros(16,1)), "double")';
        obj.c = [0;0;0;5;5;5;0;0;0;5;5;5];%入力データのスケーリングのための定数
    end

    function result = do(obj,varargin)
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;
        P = obj.param.P;
        F1 = obj.param.F1;
        F2 = obj.param.F2;
        F3 = obj.param.F3;
        F4 = obj.param.F4;
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
        z1 = Z1(x, xd', P);%z
        vf = obj.Vf(z1, F1);
        z2 = Z2(x, xd', vf, P);%x
        z3 = Z3(x, xd', vf, P);%y
        z4 = Z4(x, xd', vf, P);%yaw
        vs = obj.Vs(z2, z3, z4, F2, F3, F4);

        %% calc actual input
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs, P);
        obj.result.origin_input = tmp;
        %%input of subsystems
        obj.result.uHL = [vf(1); vs];
        %differential virtual input first layer
        obj.result.vf = vf;
        %state of subsystems
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;

        time = varargin{1}.t
        
        obj.result.xa = [Rb0' * model.state.p; Quat2Eul(R2q(Rb0' * model.state.getq("rotmat"))); Rb0' * model.state.v; model.state.w]; % [p, q, v, w]に並べ替え
        
        % obj.result.delta_u = tmp(1)*sin(2*pi*time/5);
        % total_thrust = tmp(1) + delta_u;
        % 
        tic
        xn = obj.self.estimator.x_pre + 0.025*roll_pitch_yaw_thrust_torque_physical_parameter_model(obj.self.estimator.x_pre, tmp, obj.param.P);
        toc
        tic
        % obj.result.delta_u = cast(predict(obj.param.NNMEC, obj.c.*(obj.result.xa - xn)), "double")';
        obj.result.delta_u = cast(predict(obj.param.NNMEC, [(obj.result.xa - xn); tmp]), "double")';
        toc
        % obj.result.delta_u = 0.0*cast(predict(obj.param.NNMEC, obj.result.xa - xn), "double")';
        
        obj.result.input = [max(0,min(10,tmp(1)+obj.result.delta_u(1)));max(-1,min(1,tmp(2)+obj.result.delta_u(2)));max(-1,min(1,tmp(3)+obj.result.delta_u(3)));max(-1,min(1,tmp(4)+obj.result.delta_u(4)))];
        % obj.result.input = [max(0,min(11,tmp(1)+obj.result.delta_u(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];

        

        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
