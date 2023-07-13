classdef DRONE < ABSTRACT_SYSTEM
    % Drone class
    properties %(Access = private)
        %id = 0;
        fig
    end
    methods
        function obj = DRONE(args,param)
            arguments
                args
                param
            end
            obj=obj@ABSTRACT_SYSTEM(args,param);
            if contains(args.type,"EXP")
                obj.plant = DRONE_EXP_MODEL(args);
            end
            obj.parameter = param;
        end
    end
    methods
        function animation(obj,logger,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            arguments
                obj
                logger
                param.target = 1;
            end
            p = obj.parameter;
            DRAW_DRONE_MOTION(logger,"frame_size",[p.Lx,p.Ly],"rotor_r",p.rotor_r,"animation",true,"target",param.target);
        end
    end
end
