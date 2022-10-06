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
            obj.param.k_1 = 1;
            obj.param.k_2 = 1;
        end
        
        function result = do(obj,param)
            ref = obj.self.reference.result.state;
            obj.param.Xr = [obj.self.estimator.result.state.get(),ref.xd];
%             state = ;
            result = obj.result;

        end

        function show(obj)

        end
        
    end
end

