classdef PID_CONTROLLER <CONTROLLER_CLASS    
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
            [p,q,~,~]=obj.strans(obj.self.model.state); 
            obj.ei = zeros(size(p,1)+size(q,1),1);
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
            obj.e = [p-rp;q-rq];
            obj.ed = [v-rv;w-rw];
            
            obj.result.input = -obj.Kp*obj.e - obj.Ki*obj.ei - obj.Kd*obj.ed;
            obj.self.input = obj.result.input;
            u = obj.result;
            obj.ei = obj.ei + obj.e*obj.dt;
        end 
        function show(obj)
            obj.result;
        end
    end
end

