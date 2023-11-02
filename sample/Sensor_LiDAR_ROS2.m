function Sensor = Sensor_LiDAR_ROS2(param)
% Sensor.name = ["rplidar"];
% Sensor.type = ["ROS2"];
% % X, Y. Z
% Sensor.param.subTopicName = {'/scan_front'};
% end

arguments
    param
end

Sensor.type = "ROS2_LiDAR_PCD";
Sensor.name = "RPLiDAR-S1";
setting.conn_type = param(1);
setting.id = param(2);
setting.state_list = ["p"];
setting.numlist = [3, 3];
% Sensor.subTopicName=param{1,3};

Sensor.param = setting;