classdef sensor_ceiling_sim < SENSOR_CLASS
    %SENSOR_CEILING このクラスの概要をここに記述
    %   天井との距離を測定する赤外線センサ(シミュレーション用)

    properties
        name = "celing";
        result
        self
        pitch
        distance
        angle_range
        KF
        z_d
        A
        b
        c
    end

    methods
        function obj = sensor_ceiling_sim(self,param)
            obj.self=self;%ドローン状態
            obj.distance = param.distance;%距離
            obj.pitch = param.pitch;%角度
            obj.angle_range =param.angle_range;%出てくる線と角度範囲
            obj.KF.x_h = [];%状態推定値初期値
            obj.KF.P_h = 1;%共分散行列
            obj.KF.Q = 1;%システムノイズの分散
            obj.KF.R = 4;%観測ノイズの分散
            obj.z_d = 0;
        end

        function result = do(obj,param)
            Plant = obj.self.plant;%Plantはドローンの状態
            z = param;%天井の高さ
            pos=Plant.state.p;%ドローンの位置情報
            Roll = Plant.state.q(1);%ロール角
            Pitch = Plant.state.q(2);%ピッチ角
            Rx = [1 0 0;0 cos(Roll) -sin(Roll);0 sin(Roll) cos(Roll)];% x軸周りボディ座標から見るため転置
            Ry = [cos(Pitch) 0 sin(Pitch);0 1 0;-sin(Pitch) 0 cos(Pitch)];%y軸周りボディ座標から見るため転置
            sensor_pos = Rx*Ry*[0 0 0.05]'+pos;%機体よりちょっと高めにセンサー位置を設定

            if pos(1) > 1 && pos(1) < 1.3   % 1 < x < 1.5の時天井に窪み
                distance_ceiling = z - sensor_pos(3)-0.5; %‐0.5m低くする
            else
                distance_ceiling = z - sensor_pos(3); %実際の距離
            end
            sensor_distance = sqrt((distance_ceiling*tan(Roll)/cos(Pitch))^2 + distance_ceiling^2);%+random('Normal',0,0.02);%センサの取得した測定距離に変換
            %% カルマンフィルタ
            if isempty(obj.KF.x_h)
                obj.KF.x_h = sensor_distance;%状態推定値初期値
            else
                if abs(sensor_distance-obj.KF.x_h) > 0.1 %測定値の変化率
                    obj.z_d = sensor_distance-obj.KF.x_h;
                    sensor_distance=sensor_distance-obj.z_d;
                end
                x_hm = obj.KF.x_h;%事前推定値
                P_hm = obj.KF.P_h+obj.KF.Q;%事前誤差共分散
                K = P_hm/(P_hm+obj.KF.R);%カルマンゲイン
                obj.KF.x_h = x_hm+K*(sensor_distance-x_hm);%事後推定値
                obj.KF.P_h = (1 - K)*P_hm;%事後誤差共分散
            end
            %% 天井との距離に変換
            obj.result.ceiling_distance = (obj.KF.x_h)*cos(Roll)*cos(Pitch);
            result = obj.result;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
            else
                disp("do measure first.");
            end
        end
    end
end
