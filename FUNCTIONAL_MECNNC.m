classdef FUNCTIONAL_MECNNC < handle
% クアッドコプター用階層型線形化を使った入力算出
% シミュレーションに使ったMECプログラム
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    agent
    motive
    MECNN
    Pn_p_pre
    Pa_p_pre
    Pn_p_cur
    Pa_p_cur
    Pn_u
    data_gen_mode
end

methods

    function obj = FUNCTIONAL_MECNNC(self, param)

        % obj.data_gen_mode = true;
        obj.data_gen_mode = false;

        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);


        initial_state.p = self.plant.state.p;
        initial_state.q = self.plant.state.q;
        initial_state.v = self.plant.state.v;
        initial_state.w = self.plant.state.w;

        % obj.motive = Connector_Natnet_sim(1, self.plant.dt, 0); % imitation of Motive camera (motion capture system)
        % obj.agent = DRONE;
        % obj.agent.plant = MODEL_CLASS(obj.agent,Model_Quat13(self.plant.dt, initial_state, 1));
        % obj.agent.estimator = EKF(obj.agent, Estimator_EKF(obj.agent,self.plant.dt,MODEL_CLASS(obj.agent,Model_EulerAngle(self.plant.dt, initial_state, 1)),["p", "q"]));
        % % obj.agent.parameter = DRONE_PARAM("DIATONE","mass",3.0);
        % obj.agent.parameter = DRONE_PARAM("DIATONE");
        % 
        % obj.agent.sensor = MOTIVE(obj.agent, Sensor_Motive(1,0, obj.motive));
        % obj.agent.controller.result.input = obj.result.input;

        obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル

        
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
        %%input of subsystems
        obj.result.uHL = [vf(1); vs];
        %differential virtual input first layer
        obj.result.vf = vf;
        %state of subsystems
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        % obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        result = obj.result;


        % obj.agent.plant.do(varargin{:});
        % obj.motive.getData(obj.agent);
        % obj.agent.sensor.do(varargin{:});
        % obj.agent.estimator.do(varargin{:});%EKF
        % obj.agent.controller.result.input = obj.result.input;
        % plant_state = obj.agent.plant.state; %plant`

        x = [Rb0' * model.state.p; Quat2Eul(R2q(Rb0' * model.state.getq("rotmat"))); Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        
        
    
        if obj.data_gen_mode
            obj.result.delta_u = 0.001*sin(2*pi*rand(1))*obj.Pn_u + [9.81*(0.4-0.6)+rand(1);0.0;0.0;0.0];
            % obj.result.input = obj.result.gened_u;
        else
            obj.Pn_p_cur(1:3) = obj.Pn_p_cur(1:3) - obj.Pa_p_pre(1:3);
            obj.Pa_p_cur(1:3) = obj.Pa_p_cur(1:3) - obj.Pa_p_pre(1:3);
            obj.Pn_p_cur(4:end) = 1000*obj.Pn_p_cur(4:end);
            obj.Pa_p_cur(4:end) = 1000*obj.Pa_p_cur(4:end);
            % obj.result.delta_u = cast(predict(obj.param.MECNN, [obj.Pa_p_cur; obj.Pn_p_cur]), "double")';
            obj.result.delta_u = cast(predict(obj.param.MECNN, obj.Pa_p_cur-obj.Pn_p_cur), "double")';
        end
            obj.result.input = obj.Pn_u + obj.result.delta_u;
            % obj.result.input = obj.Pn_u;
            % obj.result.delta_u
            
        % delta_u
        % obj.result.plant_.p = obj.agent.plant.state.p;
        % obj.result.plant_.q = obj.agent.plant.state.q;
        % obj.result.plant_.v = obj.agent.plant.state.v;
        % obj.result.plant_.w = obj.agent.plant.state.w;
        % obj.result.plant_.delta_u = delta_u;
        %
        %hosyo
        %
        
        % delta_u

    end

    function show(obj)
        obj.result
    end

end

end
