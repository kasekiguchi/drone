function Sensor = Sensor_RangePos(id,param)
% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
arguments
    id
    param.r = 3
end
Sensor.name=["rpos"];
Sensor.type=["RANGE_POS_SIM"];
rpos_param.r=param.r; % 隣接エージェントの位置を知るためのレンジ
    rpos_param.id=id;
    Sensor.param=rpos_param;
end
