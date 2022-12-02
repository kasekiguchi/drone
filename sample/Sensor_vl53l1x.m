function sensor=Sensor_vl53l1x(id)
    sensor.name=["VL"];
    sensor.type=["VL53L1X"];
    % 実験用
    sensor.param.portnumber = 8025;%自ポート番号
    sensor.param.RemoteIPPort = 8024;%ESPr側のポート番号
    sensor.param.ReceiveBufferSize = 1;%バッファサイズ;
    sensor.param.RemoteIPAddress = '192.168.50.174';
    sensor.param.MaximumMessageLength = 15;
    sensor.param.id=id;
end
