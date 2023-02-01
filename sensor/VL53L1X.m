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
            obj.ReceiveBufferSize = param.ReceiveBufferSize;
            obj.RemoteIPPort = param.RemoteIPPort;%ESPr側 のポート番号
            obj.portnumber = param.portnumber;%自ポート番号
            obj.RemoteIPAddress = param.RemoteIPAddress;
            obj.MaximumMessageLength = param.MaximumMessageLength;
            obj.receiver = dsp.UDPReceiver('RemoteIPAddress',obj.RemoteIPAddress,'LocalIPPort',obj.portnumber,'ReceiveBufferSize',obj.ReceiveBufferSize,'MaximumMessageLength',obj.MaximumMessageLength);
            setup(obj.receiver);
        end
        
        function result=do(obj,~) 
            udpr = obj.receiver();
            if isempty(udpr)==0%受け取ったデータの確認用
                ReceiveDate = strsplit(strcat(native2unicode(udpr')),',');%取得したデータの分割
                sensor_distance = str2double(ReceiveDate);%センサ1 char→double
%                 sensor_distance(2) = str2double(ReceiveDate(2));%センサ2 char→double
                obj.result.VL_length = str2double(sensor_distance);%/1000;%センサ1 char→double
                obj.result.switch = 0;
                if obj.result.distance.VL < 65
                    obj.result.switch = 1;
                end
            else
                obj.result.switch = obj.self.sensor.VL.result.switch;
                obj.result.VL_length = obj.self.sensor.VL.result.VL_length;
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


