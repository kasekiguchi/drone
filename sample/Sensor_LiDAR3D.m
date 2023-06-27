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
    param.p0 = [0;0;0];    
    param.R0 = eye(3);
end
Sensor.env = param.env;
Sensor.radius = param.radius;
Sensor.theta_range = param.theta_range;
Sensor.phi_range = param.phi_range;
Sensor.seed = param.seed;
Sensor.noise = param.noise;
Sensor.id = id;
Sensor.p0 = param.p0;
Sensor.R0 = param.R0;
end
