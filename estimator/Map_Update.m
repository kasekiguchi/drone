classdef MAP_UPDATE < ESTIMATOR_CLASS
    properties
        result
        env
        self
    end

    methods
        function obj = MAP_UPDATE(self, param)
            obj.self = self;
            obj.env = param;
            obj.env.grid_density(:, :) = 0;
        end

        function [result] = do(obj, ~, varargin)
            % param
            % varargin : 他の推定器で推定した状態
            sensor = obj.self.sensor.result;
            if ~isempty(varargin)
                state = varargin{1}.state;
            else
                state = sensor.state;
            end
            pos = [find((obj.env.xq(:, 1) > (state.p(1) - obj.env.d / 2)), 1), find((obj.env.yq(1, :) > (state.p(2) - obj.env.d / 2)), 1)]; % globalのgrid 上のエージェントの位置
            [~, rmin_pos(1)] = min(abs(sensor.xq(:, 1)));
            [~, rmin_pos(2)] = min(abs(sensor.yq(1, :)));                                                                   % local grid 上のエージェントの位置
            min_pos = pos - rmin_pos + [1 1];                                                                               % センサー計測値のglobal grid上の開始位置
            map_size = size(sensor.xq) - [1 1];                                                                             % 計測したmapのgridサイズ
            obj.env.grid_density(min_pos(1):min_pos(1) + map_size(1), min_pos(2):min_pos(2) + map_size(2)) = obj.env.grid_density(min_pos(1):min_pos(1) + map_size(1), min_pos(2):min_pos(2) + map_size(2)) .* (sensor.grid_density == 0) + sensor.grid_density;
            obj.result = obj.env;
            result = obj.result;
        end
        function show(obj)
            obj.env.show()
        end
    end
end
