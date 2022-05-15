classdef VORONOI_BARYCENTER < REFERENCE_CLASS
    % ボロノイ重心を算出するクラス
    %   詳細説明をここに記述
    properties
        param
        self
    end

    methods
        function obj = VORONOI_BARYCENTER(self, varargin)
            obj.self = self;
            if isfield(varargin{1}, 'r'); obj.param.r = varargin{1}.r; end
            if isfield(varargin{1}, 'R'); obj.param.R = varargin{1}.R; else obj.param.R = 100; end
            if isfield(varargin{1}, 'd'); obj.param.d = varargin{1}.d; end
            if isfield(varargin{1}, 'void'); obj.param.void = varargin{1}.void; end
            obj.result.state = STATE_CLASS(struct('state_list', ["p"], 'num_list', [3]));
        end
        function result = do(obj, ~)
            %  param = range, pos_range, d, void,
            % 【Output】 result = 目標値（グローバル位置）
            %% 共通設定１：単純ボロノイセル確定
            sensor = obj.self.sensor.result;
            state = obj.self.estimator.result.state;
            %            r = obj.param.r; % 重要度を測距できるレンジ
            R = obj.param.R;       % 通信レンジ
            %           d= obj.param.d; % グリッド間隔
            void = obj.param.void; % VOID幅
            if isfield(sensor, 'neighbor')
                neighbor = sensor.neighbor; % 通信領域内のエージェント位置 絶対座標
            elseif isfield(sensor, 'rigid')
                neighbor = [sensor.rigid(1:size(sensor.rigid, 2) ~= obj.self.id).p];
            end
            % ここから相対座標
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
            result = obj.result;
        end
        function show(obj, param)
            draw_voronoi({obj.result.region}, 1, [param.p(1:2), obj.result.state.p(1:2)]);
        end
    end
    methods (Static)
        function draw_movie(logger, N, Env, span)
            arguments
                logger
                N
                Env
                span = 1:N
            end
            rpdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "r"), span, 'UniformOutput', false));
            epdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "e"), span, 'UniformOutput', false));
            spdata = cell2mat(arrayfun(@(i) logger.data(i, "p", "s"), span, 'UniformOutput', false));
            %make_gif(1:1:ke,1:N,@(k,span) draw_voronoi(arrayfun(@(i)  logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmppos(k,span),tmpref(k,span)],Vertices),@() Env.draw,fig_param);
            % Voronoi 被覆の様子
            make_animation(1:10:logger.k - 1, ...
            @(k) draw_voronoi( ...
                arrayfun(@(i) logger.Data.agent(i).reference.result{k}.region, span, 'UniformOutput', false) ...
                , [spdata(k, :); rpdata(k, :); epdata(k, :)] ...
                , Env.Vertices) ...
                , @() Env.show);

            % エージェントが保存している環境地図
            %make_animation(1:10:logger.k-1,@(k) arrayfun(@(i) contourf(Env.xq,Env.yq,logger.Data.agent(i).estimator.result{k}.grid_density),span,'UniformOutput',false), @() Env.show_setting());
        end
    end
end
