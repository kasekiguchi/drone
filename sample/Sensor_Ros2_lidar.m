function Sensor = Sensor_Ros2_lidar(topic_number)
% sensor sample file for ros2
%[input]
% topic end number
%[output]
% Sensor:setting ros2 topics
% ↓ How to set topics.
% setting.subTopic(n,:) = {topic name, topic msg type, Hz};
% setting.pubTopic(n,:) = {topic name, topic msg type};
% topic name     : トピックの名前(char or string)
% topic msg type : トピックのメッセージタイプ(char or string)
% Hz             : トピックを受け取る周期[hz]
Sensor.num = topic_number;
Sensor.type = mfilename;
Sensor.name = ["RPLiDAR-S1"];
setting.subTopic(1,:) = {'/scan','sensor_msgs/LaserScan',10*exp(5)};
Sensor.topics = topics;
Sensor.pfunc = @scan2pcd;
end
function pc = scan2pcd(data)
% convert scan data to pcd
%[input]
% data:sensor_msgs/LaserScan (struct)
%[output]
% pc:pointCloud for ndt
moving = rosReadCartesian(data);
pc  = pointCloud([moving zeros(size(moving,1),1)]);
end