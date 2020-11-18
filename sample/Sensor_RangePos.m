function Sensor = Sensor_RangePos(id,r)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
Sensor.name=["rpos"];
Sensor.type=["RangePos_sim"];
rpos_param.r=r; % 隣接エージェントの位置を知るためのレンジ
    rpos_param.id=id;
    Sensor.param=rpos_param;
end
