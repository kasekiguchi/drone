function Sensor = Sensor_RangeD(param)
arguments
    param.r = 3;
    param.env;
    param.d;
    param.direction_range
end
    % sensor class demo : constructor
    % sensor property をSensor classのインスタンス配列として定義
    % rdensity : RANGE_DENSITY_SIM
    Sensor.r=param.r; % 重要度マップを知るためのレンジ
    if isfield(param,'d') ;Sensor.d = param.d; end
    if isfield(param,'direction_range') ;Sensor.direction_range = param.direction_range; end
end
