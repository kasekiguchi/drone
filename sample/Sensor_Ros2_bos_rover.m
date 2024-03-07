function Sensor = Sensor_Ros2_bos_rover(topic_number)
%bos用メガローバーVer3.0のsensorsampleファイル
%[input]
% topic end number
%[output]
% Sensor:setting ros2 topics
Sensor.type = mfilename;
Sensor.name = ["RPLiDAR-S1" "RPLiADR-S1" "megarover Ver3.0" "switchbot"];
topics.subTopic(1,:) = {'/scan_front','sensor_msgs/LaserScan',1e6};
topics.subTopic(2,:) = {'/scan_behind' ,'sensor_msgs/LaserScan',1e6};
topics.subTopic(3,:) = {'/rover_odo', 'geometry_msgs/Twist', 1e6};
topics.subTopic(4,:) = {'/rover_sensor', 'std_msgs/Int16MultiArray', 1e6};
% topics.subTopic(5,:) = {'/elevator_status', 'std_msgs/String', 1e6};% for switch bot
% topics.pubTopic(5,:) = {'/robot_status', 'std_msgs/String'};% for switch bot
% topics.pubTopic(6,:) = {'/target_floor_to_elevator', 'std_msgs/Int8'};% for switch bot
Sensor.topics = topics;
Sensor.num = topic_number;
Sensor.pfunc = @getData_two_lidar_combine;
end
function [pcdata,detection] = getData_two_lidar_combine(data1,data2)
% ２つのLiDARデータを結合しポイントクラウドデータに変換
scanlidardata_b = data1;
scanlidardata_f = data2;
% trans n–by–2 matrix [m]
moving_f = rosReadCartesian(scanlidardata_f);
moving_b = rosReadCartesian(scanlidardata_b);
% add z axis data
front_pc  = [moving_f zeros(size(moving_f,1),1)];
behind_pc = [moving_b zeros(size(moving_b,1),1)];
% region of interest to be deleted
delete_roi = [0.1 0.35 -0.18 0.16 -0.1 0.1]; % TODO : region to be deleted due to the vehicle direction
% delete points in delete_roi
moving_pc.f = Pointcloud_manual_roi(front_pc,delete_roi,"delete");
moving_pc.b = Pointcloud_manual_roi(behind_pc,delete_roi,"delete");
% transform back lidar data into front lidar coordinate
% Yaw axis rotation
rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
% translational vector
% Tb = [0.2900    0.0230         0]; % TODO : measure from back lidar to the vehicle's origin
Tb = [-0.29    0         0]; % TODO : measure from back lidar to the vehicle's origin
Tf = [0.17 0.0 0]; % TODO : measure from front lidar to the vehicle's origin
moving_pc2_m_f = (rot*moving_pc.f' + Tf')'; % N x 3
moving_pc2_m_b = (moving_pc.b' + Tb')'; % N x 3
% merge and transform to point cloud data
pcdata = pointCloud([moving_pc2_m_f;moving_pc2_m_b]);
detection_roi = [0 0.65 -0.2 0.2 -0.1 0.1];
detection = Pointcloud_manual_roi(pcdata.Location,detection_roi,"detection");
end
function pointcloud_out_roi = Pointcloud_manual_roi(pd,roi,mode)
% extract data from pd within ROI
ids = roi(1) < pd(:,1) & pd(:,1) < roi(2) & roi(3) < pd(:,2) & pd(:,2) < roi(4);
% size(pd(ids,:))
if mode=="delete"
pd(ids,:) = [];
elseif mode=="detection"
pd = pd(ids,:);
end
pointcloud_out_roi = pd;
end
