classdef AutoPlotPowerPoint<handle
    %This class is plot program for powerpoint.
    %   
    
    properties
        logger
        
    end
    
    methods
        function obj = AutoPlotPowerPoint(logger)
            %PLOT_PP このクラスのインスタンスを作成
            %   
            obj.logger = logger;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            outputArg = obj.Property1 + inputArg;
        end
    end
end

