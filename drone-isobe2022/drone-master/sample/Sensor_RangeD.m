function Sensor = Sensor_RangeD(param)
arguments
    param.r = 3;
end
    % sensor class demo : constructor
    % sensor property をSensor classのインスタンス配列として定義
    % rdensity : RANGE_DENSITY_SIM
    Sensor.name=["rdensity"];
    Sensor.type=["RANGE_DENSITY_SIM"];
    rdensity_param.r=param.r; % 重要度マップを知るためのレンジ
    Sensor.param=rdensity_param;
end
