classdef PID_BASED_CONTROLLER <CONTROLLER_CLASS    
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
          etrans
          utrans
    end
    
    methods
        function obj = PID_BASED_CONTROLLER(self,param)
            obj.self = self;
            obj.Kp=param.Kp;
            obj.Ki=param.Ki;
            obj.Kd=param.Kd;
            obj.dt = param.dt;
            obj.etrans = param.etrans;
            obj.utrans = param.utrans;
            [ep,~]=obj.etrans(obj.self.model.state,obj.self.model.state); 
            obj.ei = zeros(size(ep,1),1);
        end
        
        function u = do(obj,param,~)
            % u = do(obj,param,~)
            % param (optional) : 
            [obj.e,obj.ed]=obj.etrans(obj.self.estimator.result.state,obj.self.reference.result.state);
            if ~isempty(param)
                if isfield(param,'Kp'); obj.Kp=param.Kp; end
                if isfield(param,'Ki'); obj.Ki=param.Ki; end
                if isfield(param,'Kd'); obj.Kd=param.Kd; end
                if isfield(param,'dt'); obj.dt=param.dt; end
            end
            
            obj.result.input = obj.utrans(-obj.Kp*obj.e - obj.Ki*obj.ei - obj.Kd*obj.ed);
            obj.self.input = obj.result.input;
            u = obj.result;
            obj.ei = obj.ei + obj.e*obj.dt;
        end 
        function show(obj)
            obj.result;
        end
    end
end

