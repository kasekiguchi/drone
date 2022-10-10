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
<<<<<<< HEAD:ws_development/ws_controller/PtoP_contoller.m
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
=======
            obj.param.k_1 = 1;
            obj.param.k_2 = 1;
        end
        
        function result = do(obj,param)
            ref = obj.self.reference.result.state;
            obj.param.Xr = [obj.self.estimator.result.state.get(),ref.xd];
%             state = ;
            result = obj.result;

>>>>>>> affd95934c1ee18910e1d53c3ee09bd36a55d644:controller/@TRACKING_MPC/PtoP_contoller.m
        end

        function show(obj)

        end
        
    end
end

