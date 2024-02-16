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
setting.subTopic(1,:) = {'/scan_front','sensor_msgs/LaserScan',10*exp(5)};
setting.subTopic(2,:) = {'/scan_behind' ,'sensor_msgs/LaserScan',10*exp(5)};
setting.subTopic(3, :) = {'/rover_odo', 'geometry_msgs/Twist', 10*exp(5)}; % sub topic name
setting.subTopic(4, :) = {'/rover_sensor', 'std_msgs/Int16MultiArray', 10*exp(5)}; % sub topic name
setting.getData = @getData_two_lidar_combine;
Sensor.param = setting;
% Sensor.pfunc = str2func("rover_pub");

end

function pcdata = getData_two_lidar_combine(obj)
data1 = obj.ros{2};
data2 = obj.ros{1};
% ２つのLiDARデータを結合しポイントクラウドデータに変換
% get Laser scan message
scanlidardata_b = data1.getData;
scanlidardata_f = data2.getData;
% trans n–by–2 matrix [m]
moving_f = rosReadCartesian(scanlidardata_f);
moving_b = rosReadCartesian(scanlidardata_b);
% add z axis data
moving_pc.f = [moving_f zeros(size(moving_f,1),1)];
moving_pc.b = [moving_b zeros(size(moving_b,1),1)];
% region of interest to be deleted
delete_roi = [0.1 0.35 -0.18 0.16 -0.1 0.1]; % TODO : region to be deleted due to the vehicle direction
% delete points in delete_roi
moving_pc.f = obj.Pointcloud_manual_delete_roi(moving_pc.f,delete_roi);
moving_pc.b = obj.Pointcloud_manual_delete_roi(moving_pc.b,delete_roi);

% transform back lidar data into front lidar coordinate
% Yaw axis rotation
rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
% translational vector
Tb = [0.2900    0.0230         0]; % TODO : measure from back lidar to the vehicle's origin
Tf = [0.17 0 0]; % TODO : measure from front lidar to the vehicle's origin
%moving_pc2_m_b = tform_manual(moving_pc.b,rot,T);
moving_pc2_m_f = (rot*moving_pc.f' + Tf')'; % N x 3
moving_pc2_m_b = (moving_pc.b' + Tb')'; % N x 3
% merge and transform to point cloud data
pcdata = pointCloud([moving_pc2_m_f;moving_pc2_m_b]);
end
