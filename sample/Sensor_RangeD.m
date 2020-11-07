function Sensor_RangeD(agent,r)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rdensity : RangeDensity_sim
Sensor.name=["rdensity"];
Sensor.type=["RangeDensity_sim"];
rdensity_param.r=r; % 重要度マップを知るためのレンジ
for i = 1:length(agent)
    Sensor.param=rdensity_param;
    agent(i).set_sensor(Sensor);
end
end
