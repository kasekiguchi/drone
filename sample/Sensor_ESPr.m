function sensor=Sensor_ESPr(id)
    sensor.name=["espr"];
    sensor.type=["sensor_ESPr"];
    % 実験用
    sensor.param.portnumber = 8021;%自ポート番号
    sensor.param.RemoteIPPort = 8074;%ESPr側のポート番号
    sensor.param.ReceiveBufferSize = 1;%バッファサイズ;
    sensor.param.RemoteIPAddress = '192.168.50.174';
    sensor.param.MaximumMessageLength = 15;
    sensor.param.id=id;
end
