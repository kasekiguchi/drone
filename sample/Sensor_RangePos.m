function Sensor_RangePos(agent,r)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
Sensor.name=["rpos"];
Sensor.type=["RangePos_sim"];
rpos_param.r=r; % 隣接エージェントの位置を知るためのレンジ
for i = 1:length(agent)
    rpos_param.id=i;
    Sensor.param=rpos_param;
    agent(i).set_sensor(Sensor);
end
end
