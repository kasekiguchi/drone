classdef WHILL < handle
% Drone class
properties %(Access = private)
    %id = 0;
    fig
    plant
    parameter
    sensor
    estimator
    reference
    controller
    input_transform
    % id = 1
    id
    node
end

methods

    function obj = WHILL(args)

        arguments
          args = struct("type","sim");  
        end
        obj.input_transform.do = @(varargin) [];
        if contains(args.type, "EXP")
          obj.plant = WHILL_EXP_MODEL(args);
        end
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
        vehicle = DRAW_WHILL(data.p);
        vehicle.animation(data)
    end
    function ax=show(obj,str,varargin)
      % str : list of target class
      %  example ["sensor","lidar";"estimator","ekf"]
      tmp = obj;
      for j = 1:size(str,1)
        for i = str(j,:)
          tmp = tmp.(i);
        end
        ax = tmp.show(varargin{:});
      end
    end

end

end
