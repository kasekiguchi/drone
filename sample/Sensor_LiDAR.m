function Sensor = Sensor_LiDAR(id)
%% sensor class demo : constructor
% sensor property LiDAR sensor
% rpos : RnagePos_sim
Sensor.name=["lrf"];
Sensor.type=["LiDAR_sim"];
LiDAR_param.radius = 10;
LiDAR_param.pitch = 0.1;

% X, Y. Z
% for i = 1:length(agent)
    Sensor.param.id = id;
    Sensor.param=LiDAR_param;  

%     agent(i).set_sensor(Sensor);
% end
end