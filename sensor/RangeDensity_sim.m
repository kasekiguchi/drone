classdef RangeDensity_sim < SENSOR_CLASS
    % RangeDensityのsimulation用クラス：登録されたエージェントのうち半径内のエージェントの位置を返す
    %   rdensity = RangeDensity_sim(param)
    %   (optional) param.r : 半径
    %   param.id : このセンサーを積んでいる機体のidと一致させる．
    properties
        name = "";
        result
        interface = @(x) x;
        target % 観測対象の環境
        self % センサーを積んでいる機体のhandle object
    end
    properties (SetAccess = private) % construct したら変えない値．
        r = 10;
        id
    end
    
    methods
        function obj = RangeDensity_sim(self,param)
            obj.self=self;
            %  このクラスのインスタンスを作成
            if isfield(param,'r'); obj.r= param.r;end
            %            if isfield(param,'target'); obj.target= param.target;end
            obj.id= self.id;
%             else
%                 disp('"id" field is required.');
%             end
        end
        
        function result = do(obj,varargin)
            % result=rdensity.do(varargin) : obj.r 内のdensity mapを返す．
            %   result.state : State_obj,  p : position
            % 【入力】varargin = {{Env}}      agent : センサーを積んでいる機体obj,    Env：観測対象のEnv_obj
                param=varargin{1}{1}.param;
%                obj.self=varargin{1}{1};
            state=obj.self.state; % 真値
            env = polyshape(param.Vertices);
            
            %% センシング領域を定義
            tmp = 0:0.1:2*pi;
            sensor_range=polyshape(state.p(1)+obj.r*sin(tmp),state.p(2)+obj.r*cos(tmp)); % エージェントの位置を中心とした円
            
            %% 領域と環境のintersectionが測距領域
            region=intersect(sensor_range, env); % 測距領域
            region.Vertices=region.Vertices-state.p(1:2)'; % 相対的な測距領域
            
            %% 重み分布
            pxy=state.p(1:2)'-param.map_min; % 領域左下から見たエージェント座標
            pmap_min=max(pxy+[-obj.r,-obj.r],[0,0]); % エージェントを中心としたセンサーレンジの直方包左下座標
            pmap_max=min(pxy+[obj.r,obj.r],param.map_max-param.map_min); % 右上座標
            rpmap_min=pmap_min-pxy; % 相対座標 ：grid化するために内側になるようceilしておく
            rpmap_max=pmap_max-pxy; %  相対座標 ：grid化するために内側になるようfloorしておく．
%             rpmap_min=ceil((pmap_min-pxy)/param.d); % 相対座標 ：grid化するために内側になるようceilしておく
%             rpmap_max=floor((pmap_max-pxy)/param.d); %  相対座標 ：grid化するために内側になるようfloorしておく．
            [xq,yq]=meshgrid(rpmap_min(1):param.d:rpmap_max(1),rpmap_min(2):param.d:rpmap_max(2));% 相対座標
            xq=xq';      yq=yq'; % cell indexは左上からだが，座標系は左下が基準なので座標系に合わせるように転置する．
%    [xq,yq]=meshgrid(rpmap_min(1):param.d:rpmap_max(1),rpmap_max(2):-param.d:rpmap_min(2));% 相対座標
    
            % 対象領域の重要度マップを取り出す
            min_grid_cell=floor(pmap_min/param.d);
            min_grid_cell(min_grid_cell==0)=1; % これが無いと0からになってしまう
            max_grid_cell=min_grid_cell+size(xq)-[1 1]; % region_phi と inのサイズを合わせるため
            region_phi=param.grid_density(min_grid_cell(1):max_grid_cell(1),min_grid_cell(2):max_grid_cell(2));% 相対的な重要度行列
            in = inpolygon(xq,yq,region.Vertices(:,1),region.Vertices(:,2)); % （相対座標）測距領域判別
            

            result.grid_density = region_phi.*in-0*(~in);  % region_phi(i,j) : grid (i,j) の位置での重要度：測距領域外は0
            %result.grid_pos=-rpmap_min; % region_phi が定義されているgrid 座標上でのエージェントの位置セル
            result.xq=xq;
            result.yq=yq;
            result.map_max=rpmap_max;
            result.map_min=rpmap_min;
            %% 出力として整形
            result.region=region;
            
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
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('x [m]');
            ylabel('y [m]');
            xlim([obj.result.map_min(1) obj.result.map_max(1)]);
            ylim([obj.result.map_min(2) obj.result.map_max(2)]);
            view(0, 90);
            cmap=[[1 1 1];parula];
            colormap(cmap)
            colorbar
            %caxis([-50 255])
            grid on;
        end

    end
end
