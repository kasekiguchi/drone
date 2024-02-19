function Sensor = Sensor_Ros2_multi(param)
% sensor sample file for ros2
% ↓ How to set topics.
% setting.subTopic(n,:) = {topic name, topic msg type, Hz};
% topic name     : ほしいトピックの名前(char or string)
% topic msg type : ほしいトピックのメッセージタイプ(char or string)
% Hz             : トピックを受け取る周期[hz]
arguments
  param
end
param = param.plant;
Sensor.type = "ROS2_SENSOR_multi";
Sensor.name = ["RPLiDAR-S1"];%複数を想定
setting.conn_type = "ros2";
setting.state_list = ["p","q"];
setting.numlist = [3, 3];
setting.subTopic(1,:) = {'/scan','sensor_msgs/LaserScan',10*exp(5)};
setting.subTopic(3, :) = {'/rover_odo', 'geometry_msgs/Twist', 10*exp(5)};
Sensor.param = setting;
end
