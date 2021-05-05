classdef WheelChair_FF <CONTROLLER_CLASS    
%     FF control for WheelChair
    properties
        self
        param
        result
    end
    methods
        function obj = WheelChair_FF(self,~)
            obj.self= self;
            obj.param.t = 0;
        end
        
        function result = do(obj,param,~)
          % param = {state, xd}
%             state=obj.self.model.state;
%             xd=obj.self.reference.result.state;
%             xd = xd.p;
%             obj.result.input = obj.param.K * (xd - state.p);
%             u=obj.result;
            state=obj.self.model.state;
            if isfield(obj.self.model.param,'t')
                t = obj.self.model.param.t;
            else
                t = 0;
            end
            v = 1;
            w = 0;
            obj.result.input = [v,w];
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

