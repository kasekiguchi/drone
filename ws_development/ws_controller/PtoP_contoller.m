classdef PtoP_contoller <CONTROLLER_CLASS
    %P to P contoller is for confirmation experiment
    %   Detailed explanation goes here
    
    properties
        options
        param
        result
        self
    end
    
    methods
        function obj = PtoP_contoller(self,param)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.self = self;
            obj.param.H = param.H;
            obj.param.dt = param.dt;
            obj.param.k = 0.2;
        end
        
        function obj = do(obj,param)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            ref = obj.self.reference.result.state;
            obj.param.Xr = [obj.self.estimator.result.state.get(),ref.xd];
            a = obj.param.Xr(1,4) - obj.param.Xr(1,1);
            b = obj.param.Xr(2,4) - obj.param.Xr(2,1);
            shita = atan(a/b);
            l = b / sin(shita);
            v = obj.param.k * l;
            w = obj.param.k * shita;
            obj.result.input = [v;w];
        end

        function show(obj)

        end
        
    end
end

