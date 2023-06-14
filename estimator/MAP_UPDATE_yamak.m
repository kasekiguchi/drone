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
        state = obj.self.estimator.est.result.state; % require the state estimated by another estimator
        Env=varargin{1}{4};
        env = polyshape(Env.Vertices);

        %% for CAMERA
        rpmap_min = sensor.map_min;
        rpmap_max = sensor.map_max;
        
        pxy=state.p(1:2)'-Env.map_min;
        pmap_min = rpmap_min + pxy; % 相対座標
        pmap_max = rpmap_max + pxy; %  相対座標
        % [xq,yq]=meshgrid(rpmap_min(1):Env.d:rpmap_max(1),rpmap_min(2):Env.d:rpmap_max(2));% 相対座標
        % xq=xq';      yq=yq'; % cell indexは左上からだが，座標系は左下が基準なので座標系に合わせるように転置する．
        xq = sensor.xq;
        yq = sensor.yq;

        % 対象領域の重要度マップを取り出す
        min_grid_cell=floor(pmap_min/Env.d);
        min_grid_cell(min_grid_cell==0)=1; % これが無いと0からになってしまう
        max_grid_cell=min_grid_cell+size(xq)-[1 1]; % region_phi と inのサイズを合わせるため

        region_phi=Env.grid_density(min_grid_cell(1):max_grid_cell(1),min_grid_cell(2):max_grid_cell(2));% 相対的な重要度行列
        in = inpolygon(xq,yq,sensor.region.Vertices(:,1),sensor.region.Vertices(:,2)); % （相対座標）測距領域判別

        Env.grid_density(min_grid_cell(1):max_grid_cell(1),min_grid_cell(2):max_grid_cell(2))= region_phi - 20*(in); %減少
        % Env.grid_density = Env.grid_density + 0.01; %回復
        Env.grid_density = max(Env.grid_density,1);
        Env.grid_density = min(Env.grid_density,100);

        obj.result = obj.env;
        result = obj.result;
    end

    function show(obj)
        obj.env.show()
    end

end

end
