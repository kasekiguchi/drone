classdef BIRD_MOVEMENT < REFERENCE_CLASS
    %鳥の動きを算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        id
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
        end
        
        function result = do(obj,Param)
            sensor = obj.self.sensor.result; % センサデータ
            state = obj.self.estimator.result.state; % 自己位置
            time = Param{1}; % 現在時刻
            N = Param{2}; % ドローンの数
            Nb = Param{3}; % 鳥の数
            farm = [0.5;-0.5;0.7]; % 畑の位置（目標地点）
            go = (farm - state.p)/norm(state.p - farm); % 畑に向かう方向のベクトル
            away = (state.p - sensor.drone_pos)/norm(state.p - sensor.drone_pos); % のドローンから離れる方向のベクトル
            away = sum(away,2);
            go_gain = 1.3; % 畑に向かう優先度
            away_gain = sum(1/norm(state.p - sensor.drone_pos),2); % ドローンから離れる優先度


            % 目標値
%             if obj.id == 1
%                 obj.result.state.p = [cos(time.t);sin(time.t);abs(sin(time.t))];
%             elseif obj.id == 2
%                 obj.result.state.p = [sin(time.t);sin(time.t);2];
%             else
%                 obj.result.state.p = [sin(time.t);sin(time.t);1];
%             end
            
            obj.result.farm = farm;
            obj.result.state.p = state.p + go_gain*go + away_gain*away;
            result = obj.result;
        end

        function show(obj,verargin)
        end
    end
end

