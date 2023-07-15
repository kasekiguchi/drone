classdef RANGE_DENSITY_FRONT < handle
    % RangeDensityのsimulation用クラス：登録されたエージェントのうち半径内のエージェントの位置を返す
    %   rdensity = RANGE_DENSITY_SIM(Env)
    %   (optional) Env.r : 半径
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサーを積んでいる機体のhandle object

        ray_direction % LiDAR点群の照射方向 
        sensor_poly
    end
    properties (SetAccess = private) % construct したら変えない値．
        r = 10;
        d = 0.01;
    end

    methods
        function obj = RANGE_DENSITY_FRONT(self,Env)
            obj.self=self;
            if isfield(Env,'r'); obj.r = Env.r; end
            if isfield(Env,'d'); obj.d = Env.d; end
            if isfield(Env,'direction_range') 
                obj.ray_direction = Env.direction_range(0):obj.d:Env.direction_range(1);
                obj.sensor_poly = polyshape([0 obj.r*sin(obj.ray_direction)], [0 obj.r*cos(obj.ray_direction)]);
            else
                obj.ray_direction = -pi:obj.d:pi; 
                obj.sensor_poly = polyshape(obj.r*sin(obj.ray_direction), obj.r*cos(obj.ray_direction));
            end
        end

        function result = do(obj,varargin)
            % result=rdensity.do(varargin) : obj.r 内のdensity mapを返す．
            %   result.state : State_obj,  p : position
            % 【入力】varargin = {{Env}}      agent : センサーを積んでいる機体obj,    Env：観測対象のEnv_obj
            Env=varargin{1}{4};
            pos=obj.self.plant.state.p; % Agentの現在位置
            env = Env.poly;

            %% センシング領域を定義
            if size(obj.self.reference.result.state.p) == [3 1]
                e2r_vector = obj.self.reference.result.state.p - pos;
            else
                e2r_vector = [1;0;0];
            end

            e2r_ang = atan2(e2r_vector(2),e2r_vector(1));
            sensor_range = rotate(obj.sensor_poly,e2r_ang) ;
            sensor_range = translate(sensor_range , pos(1:2)'); % エージェントの位置を中心とした円

            %% 領域と環境のintersectionが測距領域
            region=intersect(sensor_range, env); % LiDARのサークルとENVを比較し切り出す
            circ = sensor_range.Vertices; % sensor_rangeの頂点

            sensor_points = circ; % 配列の初期化
            for i = 1:length(circ)
                [in,~] = intersect(region, [pos(1:2)';circ(i, :) ]);
                if isempty(in)
                    % LiDARで測れる距離にいない
                    sensor_points(i,:) = pos(1:2)';% 測距距離が0とみなしAgent座標をLiDAR点群とする．
                else
                    [~,ii]= mink(vecnorm(in-pos(1:2)',2,2),2);
                    sensor_points(i,:) = in(ii(2),:);
                end
            end
            
            region = polyshape( sensor_points(:,1),sensor_points(:,2));

            %% 重み分布
            pmap_min = min(sensor_points,[],1);
            pmap_max = max(sensor_points,[],1);
            
            map_x_index = find(all([pmap_min(1) <= Env.xp ; Env.xp <= pmap_max(1) ],1)) ;
            map_y_index = find(all([pmap_min(2) <= Env.yp ; Env.yp <= pmap_max(2) ],1)) ;
            xp = Env.xp(map_x_index); yp = Env.yp(map_y_index);
            [xq,yq]= meshgrid(xp,yp);
            xq=xq'; yq=yq'; % cell indexは左上からだが，座標系は左下が基準なので座標系に合わせるように転置する．

            region_phi = Env.grid_density(map_x_index,map_y_index);
            in = reshape(isinterior(region,xq(:),yq(:)),size(xq));
            
            %% RESULTの処理
            result.density_front.sensor_points = sensor_points;
            result.density_front.angle         = obj.ray_direction;
            result.density_front.grid_density  = region_phi.*in;
            result.density_front.xq            = xq-pos(1);
            result.density_front.yq            = yq-pos(2);
            result.density_front.map_min       = pmap_min-pos(1:2)';
            result.density_front.map_max       = pmap_max-pos(1:2)';
            result.density_front.region        = translate(region,-pos(1:2)');
            obj.result = result;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                contourf(obj.result.xq,obj.result.yq,obj.result.grid_density);
                %            surf(obj.result.xq,obj.result.yq,obj.result.grid_density);
                obj.draw_setting();
            else
                disp("do measure first.");
            end
        end
        function [] = draw_setting(obj)
            daspect([1 1 1])
            xlabel('x [m]');
            ylabel('y [m]');
            xlim([obj.result.map_min(1) obj.result.map_max(1)]);
            ylim([obj.result.map_min(2) obj.result.map_max(2)]);
            view(0, 90);
            cmap=[[1 1 1];parula];
            colormap(cmap)
            colorbar
            grid on;
        end

    end
end
