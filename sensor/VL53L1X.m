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
%                 ReceiveDate = strcat(native2unicode(udpr'));%取得したデータの分割
%                 obj.self.sensor.UDP.result = str2double(ReceiveDate);%赤外線センサchar→double
                ReceiveDate = strcat(native2unicode(udpr'));
                %ReceiveDate = strsplit(strcat(native2unicode(udpr')),',');%取得したデータの分割
                obj.result.VL_length = str2double(ReceiveDate);%/1000;%センサ1 char→double
            else             
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


