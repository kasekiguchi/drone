classdef AutoPlotPowerPoint<handle
    %This class is plot program for powerpoint.
    %   
    
    properties
        logger
        
    end
    
    methods
        function obj = AutoPlotPowerPoint(logger)
            %PLOT_PP ���̃N���X�̃C���X�^���X���쐬
            %   
            obj.logger = logger;
            import mlreportgen.ppt.*
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 ���̃��\�b�h�̊T�v�������ɋL�q
            %   �ڍא����������ɋL�q
            outputArg = obj.Property1 + inputArg;
        end
    end
end

