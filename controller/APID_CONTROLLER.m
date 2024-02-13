classdef APID_CONTROLLER < handle
    % Adaptive PID controller
    properties
        self
        result
        e
        ed
        ei
        Kp
        Ki
        Kd
        dt
        adaptive
        gen_error
        trans
    end

    methods
        function obj = APID_CONTROLLER(self,param)
            obj.self = self;
            obj.Kp=param.Kp;
            obj.Ki=param.Ki;
            obj.Kd=param.Kd;
            obj.dt = param.dt;
            obj.adaptive = param.adaptive;
            obj.gen_error = param.gen_error;
            obj.trans = param.trans;
            [e,~]=obj.gen_error(obj.self.estimator.model.state,obj.self.reference.result.state);
            obj.ei = zeros(size(e,1),1);
        end

        function u = do(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            [e,ed] = obj.gen_error(model.state,ref.state);
            %%%%%%%%%%%%%%%%%%%%%%
            [p,q,v,w]=obj.trans(obj.self.estimator.result.state);       % （グローバル座標）推定状態 (state object)
            % [rp,rq,rv,rw]=obj.trans(obj.self.reference.result.state);   % （ボディ座標）目標状態 (state object)
            %%%%%%%%%%%%%%%%%%%%%%
            obj.e = e;
            obj.ed = ed;
           
            % [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,model.state,ref.state);
            [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,[p;q]);%;v;w],[rp;rq;rv;rw]);
            if isempty(obj.ed)
              obj.ed = 0;
            end
            obj.result.input = -Kp*obj.e - Ki*obj.ei - Kd*obj.ed;
            obj.self.input_transform.result = obj.result.input;
            u = obj.result;
            obj.ei = obj.ei + obj.e*obj.dt;


            % Kp
            % e
        end
        function show(obj)
            obj.result;
        end
    end
end

