classdef MAP_UPDATE_yamak < handle
properties
    result
    env
    self
end

methods

    function obj = MAP_UPDATE_yamak(self, param)
        obj.self = self;
        obj.env = param;
        % obj.env.grid_density(:, :) = 0;
    end

    function [result] = do(obj,varargin)
        %% 他のクラスからresultの取得
        sensor = obj.self.sensor.result.density_camera;
        Env=varargin{1}{4};
        
        if ~isempty(sensor.in);Env.grid_density(sensor.map_xi,sensor.map_yi) = Env.grid_density(sensor.map_xi,sensor.map_yi) - (0.2) * sensor.in;end
        Env.grid_density = max(Env.grid_density,0.01);
        Env.grid_density = min(Env.grid_density,1);
        result.env.grid_density = Env.grid_density;
        result.env.xq = Env.xq;
        result.env.yq = Env.yq;
        result.env.map_min = Env.map_min;
        result.env.map_max = Env.map_max;
        obj.result = result;
    end

    function show(obj)
        obj.env.show()
    end

end

end
