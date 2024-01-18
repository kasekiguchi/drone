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
        K
        dt
        strans
        rtrans
        adaptive
    end

    methods
        function obj = APID_CONTROLLER(self,param)
            obj.self = self;
            param = param.param;
            obj.Kp=param.Kp;
            obj.Ki=param.Ki;
            obj.Kd=param.Kd;
            obj.K =param.K;
            obj.dt = param.dt;
            obj.strans = param.strans;
            obj.rtrans = param.rtrans;
            [p,q,~,~]=obj.strans(obj.self.estimator.model.state);
            obj.ei = zeros(size(p,1)+size(q,1),1);
            obj.adaptive = param.adaptive;
        end

        function u = do(obj,varargin)
            param = [];
            % u = do(obj,param,~)
            % param (optional) :
%             plant.state.p = [obj.self.sensor.result.motive.position.z;obj.self.sensor.result.motive.position.x];
%             plant.state.q = obj.self.sensor.result.motive.euler(1,2);
%             [p,q,v,w]=obj.strans(obj.self.plant.result.state);
            [p,q,v,w]=obj.strans(obj.self.estimator.result.state);       % （グローバル座標）推定状態 (state object)
            [rp,rq,rv,rw]=obj.rtrans(obj.self.reference.result.state);   % （ボディ座標）目標状態 (state object)
            if ~isempty(param)
                if isfield(param,'Kp'); obj.Kp=param.Kp; end
                if isfield(param,'Ki'); obj.Ki=param.Ki; end
                if isfield(param,'Kd'); obj.Kd=param.Kd; end
                if isfield(param,'dt'); obj.dt=param.dt; end

                rp = cast(subs(rp,"t",param.t),"double");
                rq = cast(subs(rq,"t",param.t),"double");
            end
            
%             if isempty(obj.result)
%                 v = 0;
%             else
%                 v = obj.result.input(1);
%                 obj.ed = [v-rv;w-rw];
%             end
            obj.e = [p-rp;q-rq];
            obj.ed = [obj.K*(p-rp)-rv;w-rw];

            q = 0;
            rq = 0;
            if isempty(v); v = 0; end
            if isempty(w); w = 0; end
            if isempty(rv); rv = 0; end
            if isempty(rw); rw = 0; end
            
            [Kp,Ki,Kd] = obj.adaptive(obj.Kp,obj.Ki,obj.Kd,[p;q;v;w],[rp;rq;rv;rw]);
            
            obj.result.input = -Kp*obj.e - Ki*obj.ei - Kd*obj.ed;
            % disp(obj.result.input)
            % if length(obj.result.input ) > 1
            %     for j = 1:length(obj.result.input)
            %         obj.result.input(j) = subs(obj.result.input(j),"t",param.t);
            %     end
            %     obj.result.input = cast(obj.result.input,"double");
            % end

%             obj.result.input = [0.1;0];


            obj.self.input_transform.result = obj.result.input;

            % [theta,rho] = cart2pol(x,y)
            % [rho,theta] =cart2pol(obj.result.input(1,1),obj.result.input(2,1));

            % obj.result.input = [rho,theta];


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

