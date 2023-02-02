classdef sensor_ESPr < SENSOR_CLASS
    %       self : agent 製作途中
    properties
        name      = "espr";
        self
        result
        ReceiveBufferSize
        RemoteIPPort
        portnumber
        RemoteIPAddress
        receiver
        MaximumMessageLength
        KF
    end
    
    methods
        function obj = sensor_ESPr(self,param)
            obj.self = self;
            obj.ReceiveBufferSize = param.ReceiveBufferSize;
            obj.RemoteIPPort = param.RemoteIPPort;%ESPr側 のポート番号
            obj.portnumber = param.portnumber;%自ポート番号
            obj.RemoteIPAddress = param.RemoteIPAddress;
            obj.MaximumMessageLength = param.MaximumMessageLength;
            obj.receiver = dsp.UDPReceiver('RemoteIPAddress',obj.RemoteIPAddress,'LocalIPPort',obj.portnumber,'ReceiveBufferSize',obj.ReceiveBufferSize,'MaximumMessageLength',obj.MaximumMessageLength);
            setup(obj.receiver);
            obj.KF = [];
        end
        
        function result=do(obj,~) 
            udpr = obj.receiver();
            if isempty(udpr)==0%受け取ったデータの確認用
                ReceiveDate = strsplit(strcat(native2unicode(udpr')),',');%取得したデータの分割
                sensor_distance = str2double(ReceiveDate);%センサ char→double
                %% KF
                if isempty(obj.KF)~=0
                    obj.KF.P_h = 1;
                    obj.KF.Q = 1;
                    obj.KF.R = 4;
                    sensor_distance(3) = sensor_distance(1);
                else
                    x_hm = obj.self.sensor.espr.result.distance(3);%事前推定値
                    P_hm = obj.KF.P_h+obj.KF.Q;%事前誤差共分散
                    K = P_hm/(P_hm+obj.KF.R);%カルマンゲイン
                    sensor_distance(3) = x_hm+K*(sensor_distance(1)-x_hm);%事後推定値
                    obj.KF.P_h = (1 - K)*P_hm;%事後誤差共分散
                end
                obj.result.distance = sensor_distance;
                obj.result.switch = 0;
                if obj.result.distance(1) < 65
                    obj.result.switch = 1;
                end
            else
                obj.result.switch = obj.self.sensor.espr.result.switch;
                obj.result.distance = obj.self.sensor.espr.result.distance;
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


