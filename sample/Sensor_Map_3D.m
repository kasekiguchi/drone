function Sensor = Sensor_Map_3D(bird,param)
%3次元マップ用の重要度測定センサ
arguments
    bird
    param.d = 3;
end
% sensor class demo : constructor
% sensor propertyをSensor classのインスタンス配列として定義
% rcoverage_3D : RANGE_COVERAGE_SIM
Sensor.name = ["rcoverage_3D"];
Sensor.type = ["RANGE_COVERAGE_SIM"];
rcoverage_3D_param.d = param.d; % 重要度マップを知るためのレンジ
rcoverage_3D_param.bird = bird;
Sensor.param = rcoverage_3D_param;
end

