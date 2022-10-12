function Sensor = Sensor_LiDAR(id,param)
arguments
    id
    param.radius = 20;
    param.angle_range = -pi:0.01:pi;
    param.seed = 0;
    param.noise = 0;
end
%% sensor class demo : constructor
% sensor property 2D LiDAR sensor
Sensor.name = ["lrf"];
Sensor.type = ["LiDAR_sim"];
Sensor.param.radius = param.radius;
Sensor.param.angle_range = param.angle_range;
Sensor.param.seed = param.seed;
Sensor.param.noise = param.noise;
Sensor.param.id = id;
end
