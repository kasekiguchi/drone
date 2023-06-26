classdef RANGE_DENSITY_FRONT < handle
    % RangeDensityのsimulation用クラス：登録されたエージェントのうち半径内のエージェントの位置を返す
    %   rdensity = RANGE_DENSITY_SIM(Env)
    %   (optional) Env.r : 半径
    properties
        name = "";
        result
        target % 観測対象の環境
        self % センサーを積んでいる機体のhandle object
    end
    properties (SetAccess = private) % construct したら変えない値．
        r = 10;
        
    end

    methods
        function obj = RANGE_DENSITY_FRONT(self,Env)
            obj.self=self;
            if isfield(Env,'r'); obj.r= Env.r;end
            % Env.env.grid_density= ones(size(Env.env.grid_density))*100;
            
        end

        function result = do(obj,varargin)
            % result=rdensity.do(varargin) : obj.r 内のdensity mapを返す．
            %   result.state : State_obj,  p : position
            % 【入力】varargin = {{Env}}      agent : センサーを積んでいる機体obj,    Env：観測対象のEnv_obj
            Env=varargin{1}{4};
            state=obj.self.plant.state; % 真値
            env = polyshape(Env.Vertices);
            %%  カメラ観測領域における重みグリッドの取得
            if size(obj.self.reference.result.state.p) == [3 1]
                e2r_vector = obj.self.reference.result.state.p-state.p;
            else
                e2r_vector = [1;0;0];
            end
            field_of_view =pi*0.75; % 画角
            radius_of_view = obj.r ;

            e2r_ang = atan2(e2r_vector(2),e2r_vector(1));
            tmp = e2r_ang-field_of_view:0.1:e2r_ang+field_of_view; % カメラ画角 

            camera_range = polyshape([state.p(1) state.p(1)+radius_of_view*cos(tmp)],[state.p(2) state.p(2)+radius_of_view*sin(tmp)]); % カメラ検出距離
            camera_region=intersect(camera_range, env);
            camera_region.Vertices=camera_region.Vertices-state.p(1:2)';

            pxy=state.p(1:2)'-Env.map_min; % 領域左下から見たエージェント座標
            pmap_min = max(min(pxy+camera_region.Vertices,[],1),[0,0]); % エージェントを中心としたセンサーレンジの直方包左下座標
            pmap_max = min(max(pxy+camera_region.Vertices,[],1),Env.map_max-Env.map_min); % 右上座標
            rpmap_min = pmap_min-pxy; % 相対座標
            rpmap_max = pmap_max-pxy; %  相対座標f
            [xq,yq]=meshgrid(rpmap_min(1):Env.d:rpmap_max(1),rpmap_min(2):Env.d:rpmap_max(2));% 相対座標
            xq=xq';      yq=yq'; % cell indexは左上からだが，座標系は左下が基準なので座標系に合わせるように転置する．

            % 対象領域の重要度マップを取り出す
            min_grid_cell=floor(pmap_min/Env.d);
            min_grid_cell(min_grid_cell==0)=1; % これが無いと0からになってしまう
            max_grid_cell=min_grid_cell+size(xq)-[1 1]; % region_phi と inのサイズを合わせるため

            region_phi=Env.grid_density(min_grid_cell(1):max_grid_cell(1),min_grid_cell(2):max_grid_cell(2));% 相対的な重要度行列
            in = inpolygon(xq,yq,camera_region.Vertices(:,1),camera_region.Vertices(:,2)); % （相対座標）測距領域判別
            

           
            %% 領域と環境のintersectionが測距領域
            region=intersect(camera_range, env); % 測距領域
            region.Vertices=region.Vertices-state.p(1:2)'; % 相対的な測距領域

           
            %% 結果の格納
            result.density_front.grid_density = region_phi.*in-0*(~in);  % region_phi(i,j) : grid (i,j) の位置での重要度：測距領域外は0
            result.density_front.xq=xq;
            result.density_front.yq=yq;
            result.density_front.map_max=rpmap_max;
            result.density_front.map_min=rpmap_min;
            result.density_front.region=region;

            obj.result = result;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                contour(obj.result.xq,obj.result.yq,obj.result.grid_density);
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
