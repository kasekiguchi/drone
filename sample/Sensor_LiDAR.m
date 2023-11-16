function Sensor = Sensor_LiDAR(id,param)
arguments
    id
    param.radius = 20;
%     param.angle_range = -pi:0.02512:pi;
    param.angle_range = -pi:0.0087:pi;
%     param.angle_range = -pi:0.01:pi;
    param.seed = 0;
    param.noise = 0;
end
%% sensor class demo : constructor
% sensor property 2D LiDAR sensor
Sensor.radius = param.radius;
Sensor.angle_range = param.angle_range;
Sensor.seed = param.seed;
Sensor.noise = param.noise;
Sensor.id = id;
end
