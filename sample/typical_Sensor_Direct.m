function typical_Sensor_Direct(agent)
%% sensor class demo : constructor
% sensor property ��Sensor class�̃C���X�^���X�z��Ƃ��Ē�`
Sensor.name=["direct"];
Sensor.type=["DirectSensor"];
for i = 1:length(agent)
    Sensor.param=[];
    agent(i).set_sensor(Sensor);
end
end
