classdef APID_CONTROLLER <CONTROLLER_CLASS
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
        K
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
            obj.K =param.K;
            obj.dt = param.dt;
            obj.strans = param.strans;
            obj.rtrans = param.rtrans;
            [p,q,~,~]=obj.strans(obj.self.model.state);
            obj.ei = zeros(size(p,1)+size(q,1),1);
            obj.adaptive = param.adaptive;
        end

        function u = do(obj,param,~)
            % u = do(obj,param,~)
            % param (optional) :
            [p,q,v,w]=obj.strans(obj.self.estimator.result.state);       % （グローバル座標）推定状態 (state object)
            [rp,rq,rv,rw]=obj.rtrans(obj.self.reference.result.state);   % （ボディ座標）目標状態 (state object)
            if ~isempty(param)
                if isfield(param,'Kp'); obj.Kp=param.Kp; end
                if isfield(param,'Ki'); obj.Ki=param.Ki; end
                if isfield(param,'Kd'); obj.Kd=param.Kd; end
                if isfield(param,'dt'); obj.dt=param.dt; end
            end
            
%             if isempty(obj.result)
%                 v = 0;
%             else
%                 v = obj.result.input(1);
%                 obj.ed = [v-rv;w-rw];
%             end
            obj.e = [p-rp;q-rq];
            obj.ed = [obj.K*(p-rp)-rv];
            
           
            [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,[p;q;v;w],[rp;rq;rv;rw]);
            
            obj.result.input = -Kp*obj.e - Ki*obj.ei - Kd*obj.ed;
%             obj.result.input = [0.1;0];

            obj.self.input = obj.result.input;
            
%             obj.self.input = [1.0;0];
            u = obj.result;
%             u.input = [0;u.input(2)];
           
            obj.ei = obj.ei + obj.e*obj.dt;
        end
        function show(obj)
            obj.result;
        end
    end
end

