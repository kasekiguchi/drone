function Sensor = Sensor_Map_3D(param)
%3次元マップ用の重要度測定センサ
arguments
    param.r = 3;
end
% sensor class demo : constructor
% sensor popertyをSensor classのインスタンス配列として定義
% rcoverage_3D : RANGE_COVERAGE_SIM
Sensor.name = ["rcoverage_3D"];
Sensor.type = ["RANGE_COVERAGE_SIM"];
rcoverage_3D_param.r = param.r; % 重要度マップを知るためのレンジ
Sensor.param = rcoverage_3D_param;
end

