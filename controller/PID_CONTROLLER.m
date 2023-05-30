classdef PID_CONTROLLER <CONTROLLER_CLASS    
    properties
           self
           result
           e
           ed
           ei = 0;
          Kp
          Ki
          Kd
          dt
          strans
          rtrans
          ptarget
          vtarget
    end
    
    methods
        function obj = PID_CONTROLLER(self,param)
            obj.self = self;
            obj.Kp=param.Kp;
            obj.Ki=param.Ki;
            obj.Kd=param.Kd;
            obj.dt = param.dt;
            obj.strans = param.strans;
            obj.rtrans = param.rtrans;
            obj.ptarget = param.ptarget;
            obj.vtarget = param.vtarget;
            %var=obj.strans(obj.self.model.state.get(obj.ptarget)); 
            %obj.ei = zeros(size(var,1),1);
        end
        
        function u = do(obj,param,~)
            % u = do(obj,param,~)
            % param (optional) : 
            %[p,q,v,w]=obj.strans(obj.self.estimator.result.state.get(obj.target));       % （グローバル座標）推定状態 (state object)
            %[rp,rq,rv,rw]=obj.rtrans(obj.self.reference.result.state.get(obj.target));   % （ボディ座標）目標状態 (state object) 
            %var=obj.strans(obj.self.estimator.result.state.get(obj.target));       % （グローバル座標）推定状態 (state object)
            %rvar=obj.rtrans(obj.self.reference.result.state.get(obj.target));   % （ボディ座標）目標状態 (state object) 
            if ~isempty(param)
                if isfield(param,'Kp'); obj.Kp=param.Kp; end
                if isfield(param,'Ki'); obj.Ki=param.Ki; end
                if isfield(param,'Kd'); obj.Kd=param.Kd; end
                if isfield(param,'dt'); obj.dt=param.dt; end
            end
            p = obj.self.estimator.result.state.get(obj.ptarget);
            pr = obj.self.reference.result.state.get(obj.ptarget);
            v = obj.self.estimator.result.state.get(obj.vtarget);
            vr = obj.self.reference.result.state.get(obj.vtarget);
            obj.e = p - pr;
            obj.ed = v - vr;
            
            obj.result.input = -obj.Kp*obj.e - obj.Kd*obj.ed; % - obj.Ki*obj.ei 
            obj.self.input = obj.result.input;
            u = obj.result;
            %obj.ei = obj.ei + obj.e*obj.dt;
        end 
        function show(obj)
            obj.result;
        end
    end
end

