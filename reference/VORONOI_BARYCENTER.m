classdef VORONOI_BARYCENTER < handle
  % reference class for voronoi-based coverage control
  properties
    param
    self
    fShow
    result
  end

  methods
    function obj = VORONOI_BARYCENTER(self, param)
      % agent.reference = VORONOI_BARYCENTER(agent,param);
      % agent : autonomous agent which has properties of sensor, reference,
      % estimator, controller, so on.
      % This class requires 
      arguments
        self
        param
      end
      obj.self = self;
      obj.param = param;
      obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3,3]));
      obj.fShow = param.fShow;
    end
    function result = do(obj, varargin)
      % [Input] varargin = {time, cha, logger, env, agents, index}
      % time : TIME class instance
      % cha : keyboard input character
      % logger : LOGGER class instance
      % env : environment
      % agents : array of agents
      % index : self = agents(index)
      % [Output] result = reference position w.r.t. global coordinate.
      %% Common setting 1 : Simple Voronoi cell
      sensor = obj.self.sensor.result;
      state = obj.self.estimator.result.state;
      R = obj.param.R;       % communication range
      void = obj.param.void; % VOID width
      
      %% LiDAR 部分のボロノイ領域算出
      LiDAR_V = poly_volonoi(state,sensor.neighbor,sensor.region,void,R);
      [LiDAR_cent, LiDAR_mass] = map_centre_of_gravity(sensor.xq , sensor.yq , sensor.grid_density,LiDAR_V);
      LiDAR_mass = 0;
      %% camera 部分のボロノイ領域算出
      dens_c = sensor.density_camera;
      camera_V = poly_volonoi(state, sensor.neighbor, dens_c.region,void,R);
      [camera_cent, camera_mass] = map_centre_of_gravity(dens_c.xq, dens_c.yq , dens_c.grid_density, camera_V);
      if sum(isnan(camera_cent))>0
        camera_cent = state.p;
      end
      camera_mass = 1;
      %% front 部分のボロノイ領域算出
      dens_f = sensor.density_front;
      front_V = poly_volonoi(state, sensor.neighbor, dens_f.region,void,R);
      [front_cent, front_mass] = map_centre_of_gravity(dens_f.xq, dens_f.yq , dens_f.grid_density, front_V);
      front_mass = 0;

      result = (LiDAR_cent*LiDAR_mass + camera_cent*camera_mass + front_cent*front_mass)/(LiDAR_mass + camera_mass + front_mass);
      %%  描画用変数
      region_phi = [];
      yq = [];
      xq = [];
      region = LiDAR_V;

      obj.result.region_phi = region_phi;
      obj.result.xq = xq;
      obj.result.yq = yq;
      % ここまで相対座標
      obj.result.region = region.Vertices + state.p(1:2)';
      obj.result.state.p = (result + state.p); % .*[1;1;0]; % 重心位置（絶対座標）
      obj.result.state.p(3) = 1;               % リファレンス高さは１ｍ
      obj.result.state.v = [0;0;0];               % リファレンス速度は０
      result = obj.result;
      if obj.fShow
        obj.show();
      end
    end
    function show(obj,opt)
      arguments
        obj
        opt.logger = [];
        opt.FH = 1;
        opt.t = 0;
        opt.param = polyshape(obj.result.region);
      end
      clf(figure(opt.FH));
      set( gca, 'FontSize', 26); % 文字の大きさ設定
      draw_voronoi({polyshape(obj.result.region)},[obj.result.state.p';obj.self.estimator.result.state.p'],opt.param.Vertices);
    end
  end
  methods (Static)
    function show_k(logger, Env, opt)
      arguments
        logger
        Env
        opt.span = 1;
        opt.k = logger.k;
        opt.ax = [];
        opt.clear = false;
      end
      if isempty(opt.ax)
        figure();
        ax = gca;
      else
        ax = opt.ax;
      end

      rpdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "r"), opt.span, 'UniformOutput', false));
      epdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "e"), opt.span, 'UniformOutput', false));
      spdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "s"), opt.span, 'UniformOutput', false));
      if opt.clear cla(ax);end
      draw_voronoi( ...
        arrayfun(@(i) logger.Data.agent(i).reference.result{opt.k}.region, opt.span, 'UniformOutput', false) ...
        , [spdata(opt.k, :); rpdata(opt.k, :); epdata(opt.k, :)] ...
        , Env.Vertices,[],ax);
    end

        

    function draw_movie(logger, Env, span,ax,filename)
      arguments
        logger
        Env
        span
        ax
        filename= [];
      end
      if isempty(filename)
        output = 0;
      else
        output = 1;
      end
      % Voronoi 被覆の様子
      make_animation(1:10:logger.k - 1,@(k) VORONOI_BARYCENTER.show_k(logger, Env, "span",span,"k",k,"ax",ax), @(ax) Env.show(ax),output,filename,ax);

      % エージェントが保存している環境地図
      %make_animation(1:10:logger.k-1,@(k) arrayfun(@(i) contourf(Env.xq,Env.yq,logger.Data.agent(i).estimator.result{k}.grid_density),span,'UniformOutput',false), @() Env.show_setting());
    end
  end
end

%% Add Yamak 
function V = poly_volonoi(state,neighbor,region,void,R)
    %   ボロノイ領域を算出する関数
    % state 現在座標
    % neighbor 隣接Agent座標
    % region 観測領域polyshape
    % void 領域
    % R 観測半径
    neighbor_rpos = neighbor - state.p;   % 通信領域内のエージェントの相対位置
    Vn = voronoi_region([[0; 0; 0], (neighbor_rpos)],...
        [R, R; -R, R; -R, -R; R, -R],...
        1:size(neighbor, 2) + 1); % neighborsとのみボロノイ分割（相対座標）
    V = intersect(region, Vn{1});
    V = polybuffer(V, -void);
    if area(V) <= 0
        % 領域の面積０だった場合の例外処理
        % ここにくる多くの場合はbugか？（voidを取るとありえる）なら動かない（ref = state）
        warning("ACSL : The voronoi region is empty.")
    elseif ~inpolygon(0, 0, V.Vertices(:, 1), V.Vertices(:, 2))
        % 領域が自機体を含まない（voidを取るとありえる）なら動かない（ref = state）
        % ここにくる多くの場合がbugか？
        % 凸領域でなければあり得る？
        warning("ACSL : The agent is out of the voronoi region.")
    end
end
function [centroid , mass] = map_centre_of_gravity(xq , yq , grid_density, region)
    % ボロノイ重心を求めるプログラム
    in = inpolygon(xq, yq, region.Vertices(:, 1), region.Vertices(:, 2)); % 重みグリッドがポリゴンに含まれているかを判別
    region_phi = grid_density .* in;                                        % region_phi(i,j) : grid (i,j) の位置での重要度：測距領域外は０
    mass = sum(region_phi, 'all');                                        % 領域の質量
    cogx = sum(region_phi .* xq, 'all') / mass;                           % 一次モーメント/質量
    cogy = sum(region_phi .* yq, 'all') / mass;                           % 一次モーメント/質量
    centroid = [cogx; cogy; 0];     
end
