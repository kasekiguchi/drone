function Sensor_2DCoverage(agent)
%% sensor class demo : constructor
% sensor property ��Sensor class�̃C���X�^���X�z��Ƃ��Ē�`
% direct : DirectSensor
% rdensity : RangeDensity_sim
% rpos : RnagePos_sim
Sensor.name=["direct","rdensity","rpos"];
Sensor.type=["DirectSensor","RangeDensity_sim","RangePos_sim"];
rpos_param.r=300; % �אڃG�[�W�F���g�̈ʒu��m�邽�߂̃����W
rdensity_param.r=rpos_param.r/2 + 1; % �d�v�x�}�b�v��m�邽�߂̃����W
for i = 1:length(agent)
    rpos_param.id=i;
    Sensor.param={[],rdensity_param,rpos_param};
    agent(i).set_sensor(Sensor);
end
