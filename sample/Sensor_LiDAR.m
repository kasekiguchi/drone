function Sensor = Sensor_LiDAR(id)
%% sensor class demo : constructor
% sensor property LiDAR sensor
% rpos : RnagePos_sim
Sensor.name=["LiDAR"];
Sensor.type=["LiDAR_sim"];
LiDAR_param.radius = 40;
LiDAR_param.angle_range = -pi:0.01:pi;
% X, Y. Z
% for i = 1:length(agent)
    LiDAR_param.id = id;
    Sensor.param=LiDAR_param;  

%     agent(i).set_sensor(Sensor);
% end
end