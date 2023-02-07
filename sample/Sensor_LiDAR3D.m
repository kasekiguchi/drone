function Sensor = Sensor_LiDAR3D(id,param)
arguments
    id
    param.env
    % VLP-16 : https://www.argocorp.com/cam/special/Velodyne/VLP-16.html
    param.radius = 100;
    param.theta_range = [pi/2-pi/12,pi/2+pi/12]; % th : 水平から[15°, -15°]
    param.phi_range = [-pi,pi]; % phi : [-pi, pi]
    param.seed = 0;
    param.noise = 0.03; % 標準偏差
    param.dead_zone = 0.1;
end
Sensor.name = ["lidar"];
Sensor.type = ["LiDAR3D_SIM"];
Sensor.param.env = param.env;
Sensor.param.radius = param.radius;
Sensor.param.theta_range = param.theta_range;
Sensor.param.phi_range = param.phi_range;
Sensor.param.seed = param.seed;
Sensor.param.noise = param.noise;
Sensor.param.id = id;
end
