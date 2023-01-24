classdef VL53L1X < SENSOR_CLASS
    %       self : agent 製作途中
    properties
        name      = "VL";
        self
        result
        ReceiveBufferSize
        RemoteIPPort
        portnumber
        RemoteIPAddress
        receiver
        MaximumMessageLength
        KF
        z_d
    end
    
    methods
        function obj = VL53L1X(self,param)
            obj.self = self;
            obj.KF.x_h = [];%状態推定値初期値
            obj.KF.P_h = 1;%共分散行列
            obj.KF.Q = 1;%システムノイズの分散
            obj.KF.R = 4;%観測ノイズの分散
            obj.KF.A = eye(2);
            obj.KF.b = [1;1];
            obj.KF.c = eye(2);
            obj.z_d = 0;
            obj.ReceiveBufferSize = param.ReceiveBufferSize;
            obj.RemoteIPPort = param.RemoteIPPort;%ESPr側のポート番号
            obj.portnumber = param.portnumber;%自ポート番号
            obj.RemoteIPAddress = param.RemoteIPAddress;
            obj.MaximumMessageLength = param.MaximumMessageLength;
            obj.receiver = dsp.UDPReceiver('RemoteIPAddress',obj.RemoteIPAddress,'LocalIPPort',obj.portnumber,'ReceiveBufferSize',obj.ReceiveBufferSize,'MaximumMessageLength',obj.MaximumMessageLength);
            setup(obj.receiver);
        end
        
        function result=do(obj,~) 
            %% パラメータ
            Plant = obj.self.sensor.motive.result;%Plantはドローンの状態
            Roll = Plant.state.q(1);%ロール角
            Pitch = Plant.state.q(2);%ピッチ角
            Yaw = Plant.state.q(3);%ピッチ角
            %% 通信
            udpr = obj.receiver();
            if isempty(udpr)==0%受け取ったデータの確認用
                ReceiveDate = strsplit(strcat(native2unicode(udpr')),',');
                sensor_distance(1) = str2double(ReceiveDate(1));%/1000;%センサ1 char→double
                sensor_distance(2) = str2double(ReceiveDate(2));%/1000;%センサ1 char→double
                %% KF
                if isempty(obj.KF.x_h)
                    obj.KF.x_h = sensor_distance';%状態推定値初期値
                else
                    if abs(sensor_distance(1)-obj.KF.x_h(1)) > 100 %測定値の変化率
                        obj.z_d = sensor_distance(1)-obj.KF.x_h(1);
                        sensor_distance(1)=sensor_distance(1)-obj.z_d;
                    end
                    x_hm = obj.KF.A*obj.KF.x_h;%事前推定値
                    P_hm = obj.KF.A*obj.KF.P_h*obj.KF.A'+obj.KF.Q*obj.KF.b*obj.KF.b';%事前誤差共分散
                    K = P_hm*obj.KF.c/(obj.KF.c'*P_hm*obj.KF.c+obj.KF.R);%カルマンゲイン
                    obj.KF.x_h = x_hm+K*(sensor_distance'-obj.KF.c'*x_hm);%事後推定値
                    obj.KF.P_h = (1 - K*obj.KF.c')*P_hm;%事後誤差共分散
                end
            else             
                obj.result= obj.self.sensor.VL.result;
            end
            %% 実際の天井との距離に変換
            obj.result.distance.VL = (obj.KF.x_h(1))*cos(Roll)*cos(Pitch)/1000;
            obj.result.distance.teraranger = (obj.KF.x_h(2))*cos(Roll)*cos(Yaw)/1000;
            obj.result.switch = 0;
            if obj.result.distance.VL < 0.05
                obj.result.switch = 1;
            end
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


