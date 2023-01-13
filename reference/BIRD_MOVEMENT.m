classdef BIRD_MOVEMENT < REFERENCE_CLASS
    %鳥の動きを算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        id
        farm
    end
    
    methods
        function obj = BIRD_MOVEMENT(self,param)
            arguments
                self
                param
            end
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',"p",'num_list',3));
            obj.id = self.sensor.motive.rigid_num;
            obj.farm = [0;0;0];
        end
        
        function result = do(obj,Param)
            sensor = obj.self.sensor.result; % センサデータ
            state = obj.self.estimator.result.state; % 自己位置
            time = Param{1}; % 現在時刻
            N = Param{2}; % ドローンの数
            Nb = Param{3}; % 鳥の数
            initial_state = Param{4};
            ref = obj.farm; % 畑の位置（目標地点）
            if ~isempty(sensor.neighbor)
                neighbor = sensor.neighbor;
                join = sum(neighbor,2)/size(neighbor,2) - state.p;%群れ形成のベクトル
                separate_eij = (neighbor - state.p)/norm(neighbor - state.p);
                separate = -separate_eij/norm(neighbor - state.p);
                separate = sum(separate,2); % 分離
            else
                join = [0;0;0];
                separate = [0;0;0];
            end
            
            
            go = (ref - state.p)/norm(ref - state.p); % 畑に向かう方向のベクトル
            away_epx = (sensor.drone_pos - state.p)/norm(sensor.drone_pos - state.p); % のドローンから離れる方向のベクトル
            away = -away_epx/norm(sensor.drone_pos - state.p);
            away = sum(away,2); % ドローンから逃げる方向のベクトル
            field_away = [0;0;-((0 - state.p(3))/norm(0 - state.p(3)))/norm(0 - state.p(3))];
%             if state.p(3)<0.25
%                 field_away = [0;0;1];
%             else
%                 field_away = [0;0;0];
%             end
            
            join_gain = 0.3; % 群れの形成
            separate_gain = 0.2; % 接触回避
            go_gain = 0.9; % 畑に向かう
            away_gain = 0.3; % ドローンから離れる
            field_away_gain = 0.4; % 地面からの反力

            % 目標値
%             if obj.id == 1
%                 obj.result.state.p = [cos(time.t);sin(time.t);abs(sin(time.t))];
%             elseif obj.id == 2
%                 obj.result.state.p = [sin(time.t);sin(time.t);2];
%             else
%                 obj.result.state.p = [sin(time.t);sin(time.t);1];
%             end
            
            u = join_gain*join + separate_gain*separate + go_gain*go + away_gain*away + field_away_gain*field_away;
            gain = 0.8;
            obj.result.farm = ref;
            obj.result.state.p = initial_state(obj.id).p;%state.p + gain*u/norm(u);
            result = obj.result;
        end

        function show(obj,verargin)
        end
    end
end

