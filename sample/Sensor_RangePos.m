function typical_Sensor_RangePos(agent,r)
%% sensor class demo : constructor
% sensor property ��Sensor class�̃C���X�^���X�z��Ƃ��Ē�`
% rpos : RnagePos_sim
Sensor.name=["rpos"];
Sensor.type=["RangePos_sim"];
rpos_param.r=r; % �אڃG�[�W�F���g�̈ʒu��m�邽�߂̃����W
for i = 1:length(agent)
    rpos_param.id=i;
    Sensor.param=rpos_param;
    agent(i).set_sensor(Sensor);
end
end
