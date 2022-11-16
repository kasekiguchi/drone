function Sensor = Sensor_Map_Bird_3D(drone,param)
%3次元マップ用の重要度測定センサ
arguments
    drone
    param.d = 3;
end
% sensor class demo : constructor
% sensor propertyをSensor classのインスタンス配列として定義
% rcoverage_3D : RANGE_COVERAGE_SIM
Sensor.name = ["rcoverage_bird_3D"];
Sensor.type = ["RANGE_COVERAGE_BIRD_SIM"];
rcoverage_3D_param.d = param.d; % 重要度マップを知るためのレンジ
rcoverage_3D_param.drone = drone;
Sensor.param = rcoverage_3D_param;
end

