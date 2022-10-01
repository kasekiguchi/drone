function Sensor= Sensor_Direct(noise)
arguments
    noise = 0;
end
    %% sensor class demo : constructor
    % sensor property をSensor classのインスタンス配列として定義
    Sensor.name=["direct"];
    Sensor.type=["DirectSensor"];
    Sensor.param=noise;
end
