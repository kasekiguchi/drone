function typical_Sensor_Direct(agent)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
Sensor.name=["direct"];
Sensor.type=["DirectSensor"];
for i = 1:length(agent)
    Sensor.param=[];
    agent(i).set_sensor(Sensor);
end
end
