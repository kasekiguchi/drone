function Sensor = Sensor_LiDAR_ROS2(param)
Sensor.name = ["rplidar"];
Sensor.type = ["ROS2"];
% X, Y. Z
Sensor.param = param;
Sensor.param.state_list = ["p"];
Sensor.param.num_list = [3, 3];
Sensor.param.subTopicName = {'/scan_front'};
id=param.DomainID;
Sensor.param.DomainID = param.DomainID; % % check
end
