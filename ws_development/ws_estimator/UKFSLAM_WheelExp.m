classdef UKFSLAM_WheelExp < ESTIMATOR_CLASS
    %UKFSLAM_WHEELEXP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        result
        dt
        dim
        k
        self
        map_param
        NLP
    end
    
    methods
        function obj = UKFSLAM_WheelExp(self,param)
            %UKFSLAM_WHEELEXP Construct an instance of this class
            %   Detailed explanation goes here
            obj.self = self;
            model = self.model;
            obj.ros = ROS2_CONNECTOR(param);
            

        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

