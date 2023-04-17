classdef TURTLEBOT < ABSTRACT_SYSTEM
% TurtleBot class
properties %(Access = private)
    %id = 0;
    fig
end

methods

    function obj = TURTLEBOT(args, param)

        arguments
            args
            param
        end

        obj = obj@ABSTRACT_SYSTEM(args, param);
        
        obj.parameter = param;
    end

end

methods

    function animation(obj, logger, param)
        % obj.animation(logger,param)
        % logger : LOGGER class instance
        % param.realtime (optional) : t-or-f : logger.data('t')を使うか
        % param.target = 1:4 描画するドローンのインデックス
        arguments
            obj
            logger
            param.target = 1;
        end

        data.t = logger.data("t");
        data.p = logger.data(param.target, "p", "e");
        data.p(3, :) = 2;
        data.q = logger.data(param.target, "q", "e");
        vehicle = DRAW_TURTLEBOT(data.p);
        vehicle.animation(data)
    end

end

end
