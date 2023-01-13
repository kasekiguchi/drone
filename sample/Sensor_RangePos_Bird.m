function Sensor = Sensor_RangePos_Bird(id,param)
% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
arguments
    id
    param.r = 3
end
Sensor.name=["rpos_bird"];
Sensor.type=["RANGE_POS_SIM_BIRD"];
rpos_bird_param.r=param.r; % 隣接エージェントの位置を知るためのレンジ
    rpos_bird_param.id=id;
    Sensor.param=rpos_bird_param;
end
