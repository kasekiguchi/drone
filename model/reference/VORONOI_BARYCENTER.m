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
      if isfield(sensor, 'neighbor')
        neighbor = sensor.neighbor; % neighbor's global position within the communication range
      elseif isfield(sensor, 'rigid')
        neighbor = [sensor.rigid(1:size(sensor.rigid, 2) ~= obj.self.id).p];
      end
      % from here local coordinate
      if ~isempty(neighbor)                                                                                         % 通信範囲にエージェントが存在するかの判別
        neighbor_rpos = neighbor - state.p;                                                                       % 通信領域内のエージェントの相対位置
        %        if size(neighbor_rpos,2)>=1 % 隣接エージェントの位置点重み更新
        % 以下は計算負荷を下げられるが重み付きvoronoiをやるとセル形状が崩れる
        %     tri=delaunay([0,neighbor_rpos(1,:)],[0,neighbor_rpos(2,:)]); % 自機体(0,0)を加えたドロネー三角形分割
        %     tmpid=tri(logical(sum(tri==1,2)),:); % 1 つまり自機体を含む三角形だけを取り出す．
        %     tmpid=unique(tmpid(tmpid~=1))-1; % tmpid = 隣接エージェントのインデックス （neighbor_rpos内のインデックス番号）
        %     neighbor_rpos=neighbor_rpos(:,tmpid); % 隣接エージェントの相対位置
        %     neighbor.pos=neighbor.pos(:,tmpid); % 隣接エージェントの位置
        %     neighbor.weight=sensor_obj.output.neighbor.weight(tmpid); % neighbor weight
        %     neighbor.mass=sensor_obj.output.neighbor.mass(tmpid); % neighbor mass
        Vn = voronoi_region([[0; 0; 0], (neighbor_rpos)], [R, R; -R, R; -R, -R; R, -R], 1:size(neighbor, 2) + 1); % neighborsとのみボロノイ分割（相対座標）
      else                                                                                                          % 通信範囲にエージェントがいない場合
        Vn = voronoi_region([0; 0; 0], [R, R; -R, R; -R, -R; R, -R], 1);
      end
      V = intersect(sensor.region, Vn{1}); % range_regionセンサの結果との共通部分（相対座標）
      region = polybuffer(V, -void);       % 自領域のVOIDマージンを取ったpolyshape
      %%

      result = [0; 0; 0];                  % 相対位置
      obj.param.region = region;
      region_phi = [];
      yq = [];
      xq = [];
      if area(region) <= 0
        %% 領域の面積０
        % ここにくる多くの場合はbugか？（voidを取るとありえる）なら動かない（ref = state）
        warning("ACSL : The voronoi region is empty.")
      elseif ~inpolygon(0, 0, region.Vertices(:, 1), region.Vertices(:, 2))
        % 領域が自機体を含まない（voidを取るとありえる）なら動かない（ref = state）
        % ここにくる多くの場合がbugか？
        warning("ACSL : The agent is out of the voronoi region.")
      else
        %% 共通設定２：単純ボロノイセルの重み確定
        xq = sensor.xq;
        yq = sensor.yq;
        region_phi = sensor.grid_density;
        in = inpolygon(xq, yq, region.Vertices(:, 1), region.Vertices(:, 2)); % （相対座標）測距領域判別
        region_phi = region_phi .* in;                                        % region_phi(i,j) : grid (i,j) の位置での重要度：測距領域外は０
        mass = sum(region_phi, 'all');                                        % 領域の質量
        cogx = sum(region_phi .* xq, 'all') / mass;                           % 一次モーメント/質量
        cogy = sum(region_phi .* yq, 'all') / mass;                           % 一次モーメント/質量
        result = [cogx; cogy; 0];                                             % 相対位置
      end
      % 描画用変数
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
