classdef consensus_agreement < REFERENCE_CLASS
    % 合意重心を算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        N
        offset
    end
    
    methods
        %%　計算式
        function obj = consensus_agreement(self,param)
            obj.self = self;
            obj.N = param.N;
            obj.offset = param.offset;
            obj.result.state = STATE_CLASS(struct('state_list',["p"],'num_list',[3]));
        end

            
       %% 目標位置
        function  result= do(obj,param)
            % 【Input】Param = {sensor,estimator,env,param}
            %  param = range, pos_range, d, void,
            % 【Output】 result = 目標値（グローバル位置）
            %% 共通設定１：単純ボロノイセル確定
            sensor = obj.self.sensor.result;%Param{1}.result;　%　他の機体の位置
            state = obj.self.estimator.result.state;%Param{2}.state; % 自己位置
%             env = obj.self.env;%Param{3}.param;             % 環境として予測したもの
%             param = Param{4}; % 途中で変えられる必要があるか？
%             if isfield(param,'range'); obj.param.r = param.range;  end
%             if isfield(param,'pos_range'); obj.param.R = param.pos_range;  end
%             if isfield(param,'d'); obj.param.d = param.d;  end
%             if isfield(param,'void'); obj.param.void = param.void;  end
%             r = obj.param.r; % 重要度を測距できるレンジ
%             R = obj.param.R; % 通信レンジ
%             d = obj.param.d; % グリッド間隔
%             void = obj.param.void; % VOID幅
%             if isfield(sensor,'neighbor')
%                 neighbor=sensor.neighbor; % 通信領域内のエージェント位置 絶対座標
%             elseif isfield(sensor,'rigid')
%                 neighbor=[sensor.rigid(1:size(sensor.rigid,2)~=obj.self.id).p];
%             end
%             if ~isempty(neighbor)% 通信範囲にエージェントが存在するかの判別
%                 neighbor_rpos=neighbor-state.p; % 通信領域内のエージェントの相対位置
%     %        if size(neighbor_rpos,2)>=1 % 隣接エージェントの位置点重み更新
%                 % 以下は計算負荷を下げられるが重み付きvoronoiをやるとセル形状が崩れる
%                 %     tri=delaunay([0,neighbor_rpos(1,:)],[0,neighbor_rpos(2,:)]); % 自機体(0,0)を加えたドロネー三角形分割
%                 %     tmpid=tri(logical(sum(tri==1,2)),:); % 1 つまり自機体を含む三角形だけを取り出す．
%                 %     tmpid=unique(tmpid(tmpid~=1))-1; % tmpid = 隣接エージェントのインデックス （neighbor_rpos内のインデックス番号）
%                 %     neighbor_rpos=neighbor_rpos(:,tmpid); % 隣接エージェントの相対位置
%                 %     neighbor.pos=neighbor.pos(:,tmpid); % 隣接エージェントの位置
%                 %     neighbor.weight=sensor_obj.output.neighbor.weight(tmpid); % neighbor weight
%                 %     neighbor.mass=sensor_obj.output.neighbor.mass(tmpid); % neighbor mass
% %                 Vn=voronoi_region([[0;0;0],(neighbor_rpos)],[R,R;-R,R;-R,-R;R,-R],1:size(neighbor,2)+1);% neighborsとのみボロノイ分割（相対座標）
%             else % 通信範囲にエージェントがいない場合
% %                 Vn=voronoi_region([0;0;0],[R,R;-R,R;-R,-R;R,-R],1);
%             end
            if obj.N==3
            obj.result.state.p = (((state.p+(obj.offset(:,obj.self.id)))+sensor.neighbor(:,1)+sensor.neighbor(:,2))/obj.N); %　3機
            end
            if obj.N==4
            obj.result.state.p = (((state.p+(obj.offset(:,obj.self.id)))+sensor.neighbor(:,1)+sensor.neighbor(:,2)+sensor.neighbor(:,3))/obj.N);%.*[1;1;0]; % 4機
            end
%             obj.result.state.p(3) = 1; % リファレンス高さは１ｍ
            result = obj.result;
        end
        function show(obj,param)
        end
    end
end