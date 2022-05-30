classdef DRONE < ABSTRACT_SYSTEM
    % Drone class
    properties %(Access = private)
        %id = 0;
        fig
    end
    methods
        function obj = DRONE(args)
            arguments
                args
            end
                obj=obj@ABSTRACT_SYSTEM(args);
            if contains(args.type,"EXP")
                obj.plant = DRONE_EXP_MODEL(args);
            end
            % ドローン用のクラス
            % フレームとしての機能はABSTRACT_SYSTEMに記載
            % ドローン独自の部分はmodel,controllerクラスなどを参照
            %% 描画用ドローンの図
            obj.fig = load('plot/frame/drone_frame_01_05.mat').fig;
        end
    end
    methods (Static)
        function animation(logger,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            arguments
                logger
                param.target = 1;
            end
            [~,p,~]=getParameter();
            DRAW_DRONE_MOTION(logger,"frame_size",[p.Lx,p.Ly],"rotor_r",p.rotor_r,"animation",true,"target",param.target);
        end
    end
end
