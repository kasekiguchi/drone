function Sensor_RangeD(agent,r)
%% sensor class demo : constructor
% sensor property ��Sensor class�̃C���X�^���X�z��Ƃ��Ē�`
% rdensity : RangeDensity_sim
Sensor.name=["rdensity"];
Sensor.type=["RangeDensity_sim"];
rdensity_param.r=r; % �d�v�x�}�b�v��m�邽�߂̃����W
for i = 1:length(agent)
    Sensor.param=rdensity_param;
    agent(i).set_sensor(Sensor);
end
end
