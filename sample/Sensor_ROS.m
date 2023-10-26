function Sensor = Sensor_ROS(param)
Sensor.name = ["lrf"];
Sensor.type = ["ROS"];
% X, Y. Z
Sensor.param = param;
Sensor.param.state_list = ["p"];
Sensor.param.num_list = [3, 3];
Sensor.param.subTopicName = {'/scan_front'};
% Sensor.param.subMsgName = {'sensor_msgs/LaserScan'};
id=param.DomainID;
Sensor.param.subTopic = ros2node("/submatlab_lidar", id);
% Sensor.param.subTopic = ros2node("submatlab2", param.DomainID);
Sensor.param.DomainID = param.DomainID; % % check
end
