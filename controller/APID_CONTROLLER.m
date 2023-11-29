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
            [e,~]=obj.gen_error(obj.self.estimator.model.state,obj.self.reference.result.state);
            obj.ei = zeros(size(e,1),1);
        end

        function u = do(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            [e,ed] = obj.gen_error(model.state,ref.state);
            obj.e = e;
            obj.ed = ed;
           
            [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,model,ref);
            if isempty(obj.ed)
              obj.ed = 0;
            end
            obj.result.input = -Kp*obj.e - Ki*obj.ei - Kd*obj.ed;
            u = obj.result;
            obj.ei = obj.ei + obj.e*obj.dt;
        end
        function show(obj)
            obj.result;
        end
    end
end

