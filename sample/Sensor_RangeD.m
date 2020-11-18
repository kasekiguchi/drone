function Sensor = Sensor_RangeD(r)
    %% sensor class demo : constructor
    % sensor property をSensor classのインスタンス配列として定義
    % rdensity : RangeDensity_sim
    Sensor.name=["rdensity"];
    Sensor.type=["RangeDensity_sim"];
    rdensity_param.r=r; % 重要度マップを知るためのレンジ
    Sensor.param=rdensity_param;
end
