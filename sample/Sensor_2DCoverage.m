function Sensor_2DCoverage(agent)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% direct : DirectSensor
% rdensity : RangeDensity_sim
% rpos : RnagePos_sim
Sensor.name=["direct","rdensity","rpos"];
Sensor.type=["DirectSensor","RangeDensity_sim","RangePos_sim"];
rpos_param.r=300; % 隣接エージェントの位置を知るためのレンジ
rdensity_param.r=rpos_param.r/2 + 1; % 重要度マップを知るためのレンジ
for i = 1:length(agent)
    rpos_param.id=i;
    Sensor.param={[],rdensity_param,rpos_param};
    agent(i).set_sensor(Sensor);
end
