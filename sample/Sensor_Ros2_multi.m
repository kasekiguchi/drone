function Sensor = Sensor_Ros2_multi(param)
% Sensor.name = ["rplidar"];
% Sensor.type = ["ROS2"];
% % X, Y. Z
% Sensor.param.subTopicName = {'/scan_front'};
% end

arguments
    param
end
param = param.plant;
Sensor.type = "ROS2_SENSOR_multi";
Sensor.name = ["RPLiDAR-S1" "RPLiADR-S1"];%複数を想定
setting.conn_type = "ros2";
setting.state_list = ["p","q"];
setting.numlist = [3, 3];
% Sensor.subTopicName=param{1,3};
% setting.subTopicName(1) = {'/scan_front'};
% setting.subTopicName(2) = {'/scan_back'};
% setting.subMsgName      = {'sensor_msgs/LaserScan'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sub 型
setting.subTopic(1,:) = {'/scan_front','sensor_msgs/LaserScan',5000};
setting.subTopic(2,:) = {'/scan_behind' ,'sensor_msgs/LaserScan',5000};
Sensor.param = setting;
% Sensor.pfunc = str2func("rover_pub");


end