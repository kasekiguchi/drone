function Sensor = Sensor_Ros2_bos_rover(param)
%bos用メガローバーVer3,0のsensorsampleファイル
arguments
  param
end
param = param.plant;
Sensor.type = "Sensor_Ros2_bos_rover";
Sensor.name = ["RPLiDAR-S1" "RPLiADR-S1"];
setting.conn_type = "ros2";
setting.state_list = ["p","q"];
setting.numlist = [3, 3];
setting.subTopic(1,:) = {'/scan_front','sensor_msgs/LaserScan',10*exp(5)};
setting.subTopic(2,:) = {'/scan_behind' ,'sensor_msgs/LaserScan',10*exp(5)};
setting.subTopic(3, :) = {'/rover_odo', 'geometry_msgs/Twist', 10*exp(4)};
% setting.subTopic(4, :) = {'/rover_sensor', 'std_msgs/Int16MultiArray', 10*exp(5)};
% setting.getData = @getData_two_lidar_combine;
Sensor.param = setting;
Sensor.pfunc = @getData_two_lidar_combine;
end
function pcdata = getData_two_lidar_combine(data1,data2)
% data1 = obj.ros{2};
% data2 = obj.ros{1};
% ２つのLiDARデータを結合しポイントクラウドデータに変換
% get Laser scan message
% scanlidardata_b = data1.getData;
% scanlidardata_f = data2.getData;
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
moving_pc.f = Pointcloud_manual_delete_roi(front_pc,delete_roi);
moving_pc.b = Pointcloud_manual_delete_roi(behind_pc,delete_roi);

% transform back lidar data into front lidar coordinate
% Yaw axis rotation
rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
% translational vector
% Tb = [0.2900    0.0230         0]; % TODO : measure from back lidar to the vehicle's origin
Tb = [-0.29    0         0]; % TODO : measure from back lidar to the vehicle's origin
Tf = [0.17 0.05 0]; % TODO : measure from front lidar to the vehicle's origin
%moving_pc2_m_b = tform_manual(moving_pc.b,rot,T);
moving_pc2_m_f = (rot*moving_pc.f' + Tf')'; % N x 3
moving_pc2_m_b = (moving_pc.b' + Tb')'; % N x 3
% merge and transform to point cloud data
pcdata = pointCloud([moving_pc2_m_f;moving_pc2_m_b]);
end
function pointcloud_out_roi = Pointcloud_manual_delete_roi(pd,roi)
% extract data from pd within ROI
ids = roi(1) < pd(:,1) & pd(:,1) < roi(2) & roi(3) < pd(:,2) & pd(:,2) < roi(4);
pd(ids,:) = [];
pointcloud_out_roi = pd;
end
