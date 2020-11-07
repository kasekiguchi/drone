classdef VoronoiBarycenter < REFERENCE_CLASS
    % ボロノイ重心を算出するクラス
    %   詳細説明をここに記述
    properties
        param
        self
    end
    
    methods
        function obj = VoronoiBarycenter(self,varargin)
            obj.self= self;
            if isfield(varargin{1},'r'); obj.param.r = varargin{1}.r;  end
            if isfield(varargin{1},'R'); obj.param.R = varargin{1}.R; else obj.param.R = 100; end
            if isfield(varargin{1},'d'); obj.param.d = varargin{1}.d;  end
            if isfield(varargin{1},'void'); obj.param.void = varargin{1}.void;  end
            obj.result.state = STATE_CLASS(struct('state_list',["p"],'num_list',[3]));
        end
        function  result= do(obj,Param)
            % 【Input】Param = {sensor,estimator,env,param}
            %  param = range, pos_range, d, void,
            % 【Output】 result = 目標値（グローバル位置）
            %% 共通設定１：単純ボロノイセル確定
            sensor = obj.self.sensor.result;%Param{1}.result;
            state = obj.self.model.state;%Param{2}.state; % handle 注意　予測状態
            env = obj.self.env;%Param{3}.param;             % 環境として予測したもの
%             param = Param{4}; % 途中で変えられる必要があるか？
%             if isfield(param,'range'); obj.param.r = param.range;  end
%             if isfield(param,'pos_range'); obj.param.R = param.pos_range;  end
%             if isfield(param,'d'); obj.param.d = param.d;  end
%             if isfield(param,'void'); obj.param.void = param.void;  end
            r = obj.param.r; % 重要度を測距できるレンジ
            R = obj.param.R; % 通信レンジ
            d= obj.param.d; % グリッド間隔
            void=obj.param.void; % VOID幅
            if isfield(sensor,'neighbor')
                neighbor=sensor.neighbor; % 通信領域内のエージェント位置 絶対座標
            elseif isfield(sensor,'rigid')
                neighbor=[sensor.rigid(1:size(sensor.rigid,2)~=obj.self.id).p];
            end
            if ~isempty(neighbor)% 通信範囲にエージェントが存在するかの判別
                neighbor_rpos=neighbor-state.p; % 通信領域内のエージェントの相対位置
    %        if size(neighbor_rpos,2)>=1 % 隣接エージェントの位置点重み更新
                % 以下は計算負荷を下げられるが重み付きvoronoiをやるとセル形状が崩れる
                %     tri=delaunay([0,neighbor_rpos(1,:)],[0,neighbor_rpos(2,:)]); % 自機体(0,0)を加えたドロネー三角形分割
                %     tmpid=tri(logical(sum(tri==1,2)),:); % 1 つまり自機体を含む三角形だけを取り出す．
                %     tmpid=unique(tmpid(tmpid~=1))-1; % tmpid = 隣接エージェントのインデックス （neighbor_rpos内のインデックス番号）
                %     neighbor_rpos=neighbor_rpos(:,tmpid); % 隣接エージェントの相対位置
                %     neighbor.pos=neighbor.pos(:,tmpid); % 隣接エージェントの位置
                %     neighbor.weight=sensor_obj.output.neighbor.weight(tmpid); % neighbor weight
                %     neighbor.mass=sensor_obj.output.neighbor.mass(tmpid); % neighbor mass
                Vn=voronoi_region([[0;0;0],(neighbor_rpos)],[R,R;-R,R;-R,-R;R,-R],1:size(neighbor,2)+1);% neighborsとのみボロノイ分割（相対座標）
            else % 通信範囲にエージェントがいない場合
                Vn=voronoi_region([0;0;0],[R,R;-R,R;-R,-R;R,-R],1);
            end
            V=intersect(sensor.region,Vn{1}); % range_regionセンサの結果との共通部分（相対座標）
            region=polybuffer(V,-void); % 自領域のVOIDマージンを取ったpolyshape
            
            %%
            
            if area(region)<=0 
                %% 領域の面積０
                % ここにくる多くの場合がbugか？（voidを取るとありえる）なら動かない（ref = state）
                result=[0;0;0]; % 相対位置
                obj.param.region=region;
                region_phi=[];
                yq=[];
                xq=[];
                warning("ACSL : The voronoi region is empty.")
            else
              if ~inpolygon(0,0,region.Vertices(:,1),region.Vertices(:,2))
                % 領域が自機体を含まない（voidを取るとありえる）なら動かない（ref = state）
                % ここにくる多くの場合がbugか？
                result=[0;0;0]; % 相対位置
                obj.param.region=region;
                region_phi=[];
                yq=[];
                xq=[];
                warning("ACSL : The agent is out of the voronoi region.")
              end
                %% 共通設定２：単純ボロノイセルの重み確定
                xq = sensor.xq;
                yq = sensor.yq;
                region_phi = sensor.grid_density;
                in = inpolygon(xq,yq,region.Vertices(:,1),region.Vertices(:,2)); % （相対座標）測距領域判別
                region_phi = region_phi.*in;  % region_phi(i,j) : grid (i,j) の位置での重要度：測距領域外は０
                mass=sum(region_phi,'all'); % 領域の質量
                cogx=sum(region_phi.*xq,'all')/mass;% 一次モーメント/質量
                cogy=sum(region_phi.*yq,'all')/mass;% 一次モーメント/質量
                result = [cogx;cogy;0]; % 相対位置
            end
            % 描画用変数
            obj.result.region_phi=region_phi;
            obj.result.xq=xq;
            obj.result.yq=yq;
            % ここまで相対座標
            obj.result.region=region.Vertices+state.p(1:2)';
            obj.result.state.p =(result+state.p);%.*[1;1;0]; % 重心位置（絶対座標）
            obj.result.state.p(3) = 1; % リファレンス高さは１ｍ
            result = obj.result;
        end
        function show(obj,param)
            draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
        function draw_movie(obj,logger,N,Env)
                rp=strcmp(logger.items,'reference.result.state.p');
                ep=strcmp(logger.items,'estimator.result.state.p');
                sp=strcmp(logger.items,'sensor.result.state.p');
                %sp=strcmp(logger.items,'plant.state.p');
                regionp=strcmp(logger.items,'reference.result.region');
                gridp=strcmp(logger.items,'env.density.param.grid_density');
                tmpref=@(k,span) arrayfun(@(i)logger.Data.agent{k,rp,i}(1:3),span,'UniformOutput',false);
                tmpest=@(k,span) arrayfun(@(i)logger.Data.agent{k,ep,i}(1:3),span,'UniformOutput',false);
                tmpsen=@(k,span) arrayfun(@(i)logger.Data.agent{k,sp,i}(1:3),span,'UniformOutput',false);
                %make_gif(1:1:ke,1:N,@(k,span) draw_voronoi(arrayfun(@(i)  logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmppos(k,span),tmpref(k,span)],Vertices),@() Env.draw,fig_param);
                make_animation(1:10:logger.i-1,1:N,@(k,span) draw_voronoi(arrayfun(@(i) logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmpsen(k,span),tmpref(k,span),tmpest(k,span)],Env.param.Vertices),@() Env.show);
                %%
                %    make_animation(1:10:logger.i-1,1,@(k,span) contourf(Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,span}),@() Env.show_setting());
                make_animation(1:10:logger.i-1,1,@(k,span) arrayfun(@(i) contourf( Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,i}),span,'UniformOutput',false), @() Env.show_setting());            
        end
    end
end

