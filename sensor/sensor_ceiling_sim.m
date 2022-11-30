classdef sensor_ceiling_sim
    %SENSOR_CEILING このクラスの概要をここに記述
    %   天井との距離を測定する赤外線センサ(シミュレーション用)

    properties
        name = "ceiling";
        result
        self
        pitch
        distance
        angle_range
    end

    methods
        function obj = sensor_ceiling_sim(self,param)
            obj.self=self;%ドローン状態
            obj.distance = param.distance;%距離
            obj.pitch = param.pitch;%角度
            obj.angle_range =param.angle_range;%出てくる線と角度範囲
        end

        function result = do(obj,param)
            Plant = obj.self.plant;%Plantはドローンの状態
            z = param;%天井の高さ
            pos=Plant.state.p;%ドローンの位置情報
            Roll = Plant.state.q(1);%ロール角
            Pitch = Plant.state.q(2);%ピッチ角
            Rx = [1 0 0;0 cos(Roll) -sin(Roll);0 sin(Roll) cos(Roll)];% x軸周りボディ座標から見るため転置
            Ry = [cos(Pitch) 0 sin(Pitch);0 1 0;-sin(Pitch) 0 cos(Pitch)];%y軸周り
            sensor_pos = Rx*Ry*[0 0 0.05]'+pos;%機体よりちょっと高めにセンサー位置を設定
            distance_ceiling = z - sensor_pos(3); %実際の距離
            result.ceiling_distance = sqrt((distance_ceiling*tan(Roll)/cos(Pitch))^2 + distance_ceiling^2)+random('Normal',0,0.02);%センサの取得した測定距離
            if result.ceiling_distance > obj.distance
                error_offset = obj.distance;
                error_distance = error_offset - 1 + random('Normal',0,0.5);
                result.ceiling_distance = error_distance;
            end
            obj.result = result;
        end
    end
end
