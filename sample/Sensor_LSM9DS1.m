function Sensor_LSM9DS1(agent)
%% sensor class demo : constructor
% sensor property ��Sensor class�̃C���X�^���X�z��Ƃ��Ē�`
% rpos : RnagePos_sim
Sensor.name=["imu"];
Sensor.type=["LSM9DS1"];
prime_param=[];
for i = 1:length(agent)
    Sensor.param=prime_param; 
    agent(i).set_sensor(Sensor);
    agent(i).sensor.imu.initialize(20);
end
 
end
