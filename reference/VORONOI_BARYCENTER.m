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
      env = varargin{4};
      %% LiDAR 部分のボロノイ領域算出
      LiDAR_V = poly_volonoi(state,sensor.neighbor,sensor.region,void,R);
      [LiDAR_cent, LiDAR_mass] = map_centre_of_gravity(sensor.xq , sensor.yq , sensor.grid_density,LiDAR_V);
      if sum(isnan(LiDAR_cent))>0
        LiDAR_cent = state.p;
      end
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
      if sum(isnan(front_cent))>0
        front_cent = state.p;
      end
      front_mass = 1;
      
      
      %% 壁面との衝突を防止する
      result = (LiDAR_cent*LiDAR_mass + camera_cent*camera_mass + front_cent*front_mass)/(LiDAR_mass + camera_mass + front_mass);
      [in,~] = intersect(polybuffer(env.poly,-env.d/2), [state.p(1:2)';result(1:2)'+ state.p(1:2)' ]);% 絶対座標
      [~,ii]= mink(vecnorm(in-state.p(1:2)',2,2),2);
      result= in(ii(2),:)';

      route = a_star(state.p(1:2)',result(1:2)',env);
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
      % obj.result.state.p = (result + state.p); % .*[1;1;0]; % 重心位置（絶対座標）
      obj.result.state.p = route(2,:)';
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

function route = a_star(start,goal,env)
    %% Setting
    d = env.d;
    xp = env.xp;
    yp = env.yp;
    grid_size = [length(xp) length(yp)]; 
    grid = env.grid_in;
    poly = env.poly;
    move = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
    move_cost = [1 sqrt(2) 1 sqrt(2) 1 sqrt(2) 1 sqrt(2) ]*d;
    % move = [1 0;  0 1;  -1 0; 0 -1];
    % move_cost = [1  1  1  1 ]*d;
    
    %% Initialize
    start_grid = [find(xp+d/2 >= start(1),1) find(yp+d/2 >= start(2),1) ];
    goal_grid  = [find(xp+d/2 >= goal(1),1)  find(yp+d/2 >= goal(2),1) ];
    
    % ▼ Variable that stores the status of each node during traversal
    node_size         = 1; % 今保持しているノードの数
    node_grid         = start_grid ; % 各ノードの座標
    node_parent_index = 1; % 各ノードの親が保存されているインデックス
    node_real_cost    = 0; % 各ノードが持つ実コスト
    node_est_cost     = vecnorm(goal-start); % 各ノードが持つ推定コスト
    node_total_cost   = node_est_cost + node_real_cost; % 各ノードが持つ合計コスト
    node_status       = 1; % 各ノードの状態 0:探索済み 1:未探索 -1:無効
    
    move_len = length(move_cost);

    % close all
    % figure()
    % hold on
    % plot(env)
    
    attempt = 0;
    st = tic;

    %% Main algorithm
    loop_f = true;
    if all(start_grid==goal_grid,'all')
        loop_f=false;
        cand_grid = goal_grid;
        index = 1;
    end
    while loop_f
    
        % ▼ Decide where to explore
        index = find(node_status==1); % 未探索グリッドの検出
        index = index(node_total_cost(index) == min(node_total_cost(index))); % そのうちトータルコストが最小のindexを抽出
        index = index(node_real_cost(index) == min(node_real_cost(index)) ); % そのうち実コストが最小のindexを抽出
        % index = index(node_est_cost(index) == min(node_est_cost(index)) ); % そのうち推定コストが最小のindexを抽出
        index = index(end); % そのうちIndexが大きい方を抽出

        % ▼ Update parent node information
        node_status(index)    = 0;
        parent_grid  = node_grid(index,:);
        parent_realcost = node_real_cost(index);
        
        % ▼ Verify candidate searches from parent node in sequence
        for i = 1:move_len
            attempt = attempt +1;
            cand_pn =true;
            cand_grid = parent_grid + move(i,:);
            if ~ all(and([0 0]<cand_grid,cand_grid<=grid_size),2) % Gridが存在するかの判別
            elseif ~ grid(cand_grid(1),cand_grid(2))  % ENVのPolyshape内か判別
            else % 上記条件を満たす場合に実行
                cand_real_cost    = parent_realcost + move_cost(i);
                duplication_index = find(all(node_grid==cand_grid,2));
                
                if ~isempty(duplication_index)% 探索済と候補が重複している場合
                    if any(node_real_cost(duplication_index) <= cand_real_cost)
                        cand_pn=false; % 探索済みの実コストが小さい場合は候補を棄却
                    else 
                        node_status(duplication_index) = -1; % 候補の実コストが小さい場合は探索済みのステータスを無効に
                    end
                end
                if cand_pn
                    node_size = node_size + 1;
                    node_grid(node_size,:)       = cand_grid ;
                    node_parent_index(node_size) = index;
                    node_real_cost(node_size)    = cand_real_cost;
                    node_est_cost(node_size)     = vecnorm(goal-[xp(cand_grid(1)) yp(cand_grid(2))],1);
                    node_total_cost(node_size)   = node_est_cost(node_size) + cand_real_cost;
                    node_status(node_size)       = 1;
                    % 
                    if all(goal_grid == cand_grid)
                        loop_f=false; 
                        break;
                    end % 候補とゴールのグリッドが一致する場合に探索を終了
                end
            end
        end
    
    
        % cla;
        % hold on
        % plot(env.poly)
        % daspect([1 1 1])
        % 
        % scatter( xp(node_grid(node_status==0,1)) , yp(node_grid(node_status==0,2)) , "r.")
        % scatter( xp(node_grid(node_status==1,1)) , yp(node_grid(node_status==1,2)) , "b.")
        % scatter(start(1),start(2),'b*')
        % scatter(goal(1),goal(2),'r*')
        % drawnow
    end
    %% Routing

    grid_route = [ xp(cand_grid(1)) yp(cand_grid(2))];
    route = grid_route;
    env_buffer = polybuffer(poly , -d*sqrt(2)/2);
    while true
    
        grid_route = cat(1,[ xp(node_grid(index,1)) yp(node_grid(index,2))] , grid_route);
        [~,out_route] = intersect(env_buffer ,[ route(1,:) ;grid_route(1,:)]);
        if ~isempty(out_route)
           route = cat(1,grid_route(2,:),route);
        end
    
        % cla;
        % hold on
        % plot(env)
        % daspect([1 1 1])
        % plot(grid_route(:,1),grid_route(:,2),'g',LineWidth=2)
        % plot(route(:,1),route(:,2),'bo-',LineWidth=2)
        % plot(in_route(:,1),in_route(:,2),'b',out_route(:,1),out_route(:,2),'r')
        % drawnow
        if index == 1 
            route = cat(1,grid_route(1,:),route);
            break
        end
        index = node_parent_index(index);
    end
    %% Ploter
    % close all
    % figure()
    % cla;
    % hold on
    % plot(env.poly)
    % daspect([1 1 1])
    % scatter( xp(node_grid(node_status==0,1)) , yp(node_grid(node_status==0,2)) , "r.")
    % % scatter( xp(node_grid(node_status==-1,1)) , yp(node_grid(node_status==-1,2)) , "black.")
    % scatter( xp(node_grid(node_status==1,1)) , yp(node_grid(node_status==1,2)) , "r.")
    % scatter(start(1),start(2),'b*')
    % scatter(goal(1),goal(2),'r*')
    % 
    % plot(grid_route(:,1),grid_route(:,2),'g',LineWidth=1)
    % plot(route(:,1),route(:,2),'bo-',LineWidth=2)
    % % et = toc(st);
    % % attempt
    % % cand_real_cost
    % hold off
end