function Sensor = Sensor_LiDAR(id)
%% sensor class demo : constructor
% sensor property 2D LiDAR sensor
Sensor.name = ["lrf"];
Sensor.type = ["LiDAR_SIM"];
Sensor.param.radius = 20;
Sensor.param.angle_range = -pi:0.01:pi;
Sensor.param.id = id;
end
