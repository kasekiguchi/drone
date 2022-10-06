classdef VORONOI_BARYCENTER_3D < REFERENCE_CLASS
    %3次元ボロノイ重心を算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        fShow
        id
    end
    
    methods
        function obj = VORONOI_BARYCENTER_3D(self,param)
            arguments
                self
                param
            end
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',"p",'num_list',3));
            obj.id = self.sensor.motive.rigid_num;
        end
        
        function result = do(obj,Param)
            % param = range, pos_range, d, void
            % 【Output】 result = 目標値（グローバル座標）
            %% 共通設定１：ボロノイセル確定
            sensor = obj.self.sensor.result;
            state = obj.self.estimator.result.state;
            N = Param{1};
            Nb = Param{2};
            if isfield(sensor,'neighbor')
                neighbor = sensor.neighbor; % 通信領域内の他機体位置　グローバル座標
            elseif isfield(sensor,'rigid')
                neighbor = [sensor.rigid(1:size(sensor.rigid,2) ~= obj.id).p];
            end

            %% 重み分布
            % 対象領域の重要度を計算
            if ~isempty(neighbor)
                Ps = [state.p';neighbor(:,1:N - Nb -1)'];
                Ps = circshift(Ps,[obj.id - 1,0]);
                Ps = [Ps;obj.param.Vertices];
            else
                Ps = [state.p';obj.param.Vertices];
            end
            [v,c] = voronoin(Ps); % 3次元ボロノイ分割

            %% 共通設定２：3次元ボロノイセルの重み確定
            [k{obj.id},~] = convhull(v(c{obj.id},1),v(c{obj.id},2),v(c{obj.id},3),'Simplify',true); % エージェント周りのボロノイ空間
            TR = triangulation(k{obj.id},v(c{obj.id},1),v(c{obj.id},2),v(c{obj.id},3)); % 三角形分割
            F = faceNormal(TR); % 三角形分割した面に対する法線ベクトル
            Ptri = incenter(TR); % 三角形分割した面の内心

            % 領域質量
            zo = find(max(sum(Ptri.*F,2) - (F*obj.param.bx') < 0,[],1) == 0);
            phi_d = normpdf(vecnorm(sensor.bird_pos' - obj.param.bx(zo,:),2,2),0,0.6); % 重み位置と領域内ボクセルとの距離の正規分布関数
            weight_bx = obj.param.bx(zo,:).*phi_d; % 重み付きボクセル
            dmass = sum(weight_bx,1); % 各方向の重みを合算
            mass = sum(phi_d,"all"); % 全部の重みを合算

            % 領域重心
            cent = dmass / mass; % 重心
            xd = cent';

            % 描画用変数
            obj.result.state.p = xd;
            result = obj.result;
            if obj.fShow
                obj.show();
            end
        end

        function show(obj,Env)
        end
    end
end

