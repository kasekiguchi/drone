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
        strans
        rtrans
        adaptive
    end

    methods
        function obj = APID_CONTROLLER(self,param)
            obj.self = self;
            obj.Kp=param.Kp;
            obj.Ki=param.Ki;
            obj.Kd=param.Kd;
            obj.dt = param.dt;
            obj.strans = param.strans;
            obj.rtrans = param.rtrans;
            [p,q,~,~]=obj.strans(obj.self.estimator.model.state);
            obj.ei = zeros(size(p,1)+size(q,1),1);
            obj.adaptive = param.adaptive;
        end

        function u = do(obj,varargin)
            % u = do(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            [p,q,v,w]=obj.strans(model.state);       % （グローバル座標）推定状態 (state object)
            [rp,rq,rv,rw]=obj.rtrans(ref.state);   % （ボディ座標）目標状態 (state object)
            obj.e = [p-rp;q-rq];
            obj.ed = [v-rv;w-rw];
           
            [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,[p;q;v;w],[rp;rq;rv;rw]);
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

