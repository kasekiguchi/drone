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

    end
    
    methods
        function obj = VL53L1X(self,param)
            obj.self = self;
            obj.KF.x_h = [];%状態推定値初期値
            obj.KF.P_h = 1;%共分散行列
            obj.KF.Q = 1;%システムノイズの分散
            obj.KF.R = 4;%観測ノイズの分散
            obj.ReceiveBufferSize = param.ReceiveBufferSize;
            obj.RemoteIPPort = param.RemoteIPPort;%ESPr側のポート番号
            obj.portnumber = param.portnumber;%自ポート番号
            obj.RemoteIPAddress = param.RemoteIPAddress;
            obj.MaximumMessageLength = param.MaximumMessageLength;
            obj.receiver = dsp.UDPReceiver('RemoteIPAddress',obj.RemoteIPAddress,'LocalIPPort',obj.portnumber,'ReceiveBufferSize',obj.ReceiveBufferSize,'MaximumMessageLength',obj.MaximumMessageLength);
            setup(obj.receiver);
        end
        
        function result=do(obj,~) 
            udpr = obj.receiver();
            if isempty(udpr)==0%受け取ったデータの確認用
                ReceiveDate = strcat(native2unicode(udpr'));
                obj.result.VL_length = str2double(ReceiveDate);%/1000;%センサ1 char→double
                %% KF
                x_hm = obj.KF.x_h;%事前推定値
                P_hm = obj.KF.P_h+obj.KF.Q;%事前誤差共分散
                K = P_hm/(P_hm+obj.KF.R);%カルマンゲイン
                obj.KF.x_h = x_hm+K*(obj.result.ceiling_distance-x_hm);%事後推定値
                obj.KF.P_h = (1 - K)*P_hm;%事後誤差共分散
            else             
                obj.result.VL_length = obj.self.sensor.VL.result.VL_length;
            end
            %% 実際の天井との距離に変換
            obj.result.ceiling_distance = obj.result.ceiling_distance*cos(Roll)*cos(Pitch);
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


