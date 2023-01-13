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
            initial_state = Param{3};
            if isfield(sensor,'neighbor')
                neighbor = sensor.neighbor; % 通信領域内の他機体位置　グローバル座標
            elseif isfield(sensor,'rigid')
                neighbor = [sensor.rigid(1:size(sensor.rigid,2) ~= obj.id).p];
            end

            %% ボロノイ分割
            % 対象領域を機体数で分割
            if ~isempty(neighbor)
                Ps = [state.p';neighbor'];
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
            farm = [0.5;-0.5;0.7]; % 畑の位置
%             bird_cent = sum(sensor.bird_pos,2) / Nb; % 鳥を個体として認識している場合の重心
            x = obj.param.qx;
            y = obj.param.qy;
            z = obj.param.qz;
            evaluation1 = var(sensor.bird_pos,0,2);     % 鳥の位置の分散
%             evaluation10 = cov(sensor.bird_pos');     % 鳥の位置の分散
            Sigma1 = [(evaluation1(1)-1)^2,(evaluation1(1)-1)*(evaluation1(2)-1),(evaluation1(1)-1)*(evaluation1(3)-1);
                      (evaluation1(2)-1)*(evaluation1(1)-1),(evaluation1(2)-1)^2,(evaluation1(2)-1)*(evaluation1(3)-1);
                      (evaluation1(3)-1)*(evaluation1(1)-1),(evaluation1(3)-1)*(evaluation1(2)-1),(evaluation1(3)-1)^2];
            evaluation2 = var([state.p,neighbor],0,2);  % ドローンの位置の分散
            for i = 1:Nb    
               distance(:,i) = norm(farm - sensor.bird_pos(:,i));
            end
            evaluation3 = distance;           % 評価値　鳥から畑までの距離

            % 領域質量
            zo = find(max(sum(Ptri.*F,2) - (F*obj.param.bx') < 0,[],1) == 0);
%             phi_d = normpdf(vecnorm(bird_cent' - obj.param.bx(zo,:),2,2),0,0.6); % 重み位置と領域内ボクセルとの距離の正規分布関数
%             weight_bx = obj.param.bx(zo,:).*phi_d; % 重み付きボクセル
            for i = 1:Nb
                phi(:,i) = normpdf(vecnorm(sensor.bird_pos(:,i)' - obj.param.bx(zo,:),2,2),0,0.6); % 鳥の重み位置と領域内ボクセルとの距離の正規分布関数
            end
            if ~isempty(neighbor)
                drone_pos = [state.p,neighbor];
                drone_pos = circshift(drone_pos,[0,obj.id - 1]);
            else
                drone_pos = state.p;
            end
            for j = 1:N
                phi_drone(:,j) = normpdf(vecnorm(drone_pos(:,j)' - obj.param.bx(zo,:),2,2),0,0.6); % ドローンの重み位置と領域内ボクセルとの距離の正規分布関数
            end
            phi_bird_all = sum(phi,2);
            phi_drone_all = sum(phi_drone,2);
            phi_all = phi_bird_all - phi_drone_all;
            negative = find(phi_all < 0);
            phi_all(negative) = zeros(size(negative));
            weight_bx = obj.param.bx(zo,:).*phi_all; % 重み付きボクセル
            dmass = sum(weight_bx,1); % 各方向の重みを合算
            mass = sum(phi_all,"all"); % 全部の重みを合算

            % 領域重心
            cent = dmass / mass; % 重心

            % 評価関数
            J_bird = norm(evaluation1);
            J_drone = 1/norm(evaluation2);
            J_farm = 1/norm(evaluation3);

            % 目標地点
            xd = cent';

            % 群れの描画
            scatter3(sensor.bird_pos(1,:),sensor.bird_pos(2,:),sensor.bird_pos(3,:));
            S = sqrtm(sensor.bird_pos*sensor.bird_pos');
            M = mean(sensor.bird_pos,2);
            [V,D] = eig(S);
            D = D/(sqrt(Nb)/2);
            [X,Y,Z] = ellipsoid(M(1),M(2),M(3),D(1,1),D(2,2),D(3,3));
            A = V(1,1)*X + V(1,2)*Y + V(1,3)*Z;
            B = V(2,1)*X + V(2,2)*Y + V(2,3)*Z;
            C = V(3,1)*X + V(3,2)*Y + V(3,3)*Z;

            % 描画用変数
            obj.result.state.p = initial_state(obj.id).p;
%             obj.result.state.p = state.p + 0.9*(xd - state.p)/norm(xd - state.p);
            obj.result.qx = x;
            obj.result.qy = y;
            obj.result.qz = z;
            obj.result.k{obj.id} = k{obj.id};
            obj.result.v = v;
            obj.result.c = c;
            obj.result.J(1,:) = J_bird;
            obj.result.J(2,:) = J_drone;
            obj.result.J(3,:) = J_farm;
            obj.result.A = A;
            obj.result.B = B;
            obj.result.C = C;
            obj.result.M = M;
            result = obj.result;
            if obj.fShow
                obj.show();
            end
        end

        function show(obj,Env)
        end
    end
end

