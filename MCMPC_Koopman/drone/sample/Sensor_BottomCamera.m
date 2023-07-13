function Sensor_BottomCamera(agent)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
Sensor.name=["Observation"];
Sensor.type=["BottomCamera"];
bc_param.Range=[-10 10;% X direction
                -10 10];% Y direction         
for i = 1:length(agent)
    Sensor.param={bc_param};
    agent(i).set_sensor(Sensor);
end
end
