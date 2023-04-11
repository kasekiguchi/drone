classdef BIRD_CONTROLLER < CONTROLLER_CLASS    
%     referenceとして渡された状態を返すコントローラ
%     質点モデルで参照点に次時刻に行く時に利用
    properties
        self
        result
    end
    methods
        function obj = BIRD_CONTROLLER(self,~)
            obj.self= self;
        end
        
        function u = do(obj,~,~)
          % param = {state, xd}
            sensor = obj.self.sensor.result; % センサデータ
            state = obj.self.estimator.result.state; % 自己位置
            Ref = obj.self.reference.birdmove.result.state.p; % 目標位置
                        
            % 近傍の個体との群れ形成
            if ~isempty(sensor.neighbor)
                neighbor = sensor.neighbor;
                join = sum(neighbor,2)/size(neighbor,2) - state.p; % 群れ形成のベクトル
                separate_eij = (neighbor - state.p)/norm(neighbor - state.p);
                separate = -separate_eij/norm(neighbor - state.p);
                separate = sum(separate,2); % 分離
            else
                join = [0;0;0];
                separate = [0;0;0];
            end

            % 畑への進行，ドローンからの逃避
            go = (Ref - state.p)/norm(Ref - state.p); % 畑に向かう方向のベクトル
            away_epx = (sensor.drone_pos - state.p)/norm(sensor.drone_pos - state.p); % ドローンから離れる方向の単位ベクトル
            away = -away_epx/norm(sensor.drone_pos - state.p);
            away = sum(away,2); % ドローンから逃げる方向のベクトル

            % 地面からの反力
            field_away_e = ([state.p(1:2);0] - state.p)/norm(state.p - [state.p(1:2);0]); % 地面からの単位ベクトル
            field_away = -field_away_e/norm(state.p - [state.p(1:2);0]); % 距離に応じた地面からの反力

            % ゲイン
            join_gain = 1.1; % 群れの形成
            separate_gain = 1.1; % 接触回避
            go_gain = 1.5; % 畑に向かう
            away_gain = 1.2; % ドローンから離れる
            field_away_gain = 1.0; % 地面からの反力

            % 目標姿勢角
            Roll = state.v(1);
            Pitch = state.v(2);
            Yaw = state.v(3);

            
            % 入力
            obj.result.input = join_gain*join + separate_gain*separate + go_gain*go + away_gain*away + field_away_gain*field_away;
%             obj.result.input = [0;0;0];
            obj.self.input = obj.result.input;
            u=obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

