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
setting.state_list = ["p"];
setting.numlist = [3, 3];
% Sensor.subTopicName=param{1,3};
% setting.subTopicName(1) = {'/scan_front'};
% setting.subTopicName(2) = {'/scan_back'};
% setting.subMsgName      = {'sensor_msgs/LaserScan'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sub 型
setting.subTopic(1,:) = {'/scan_front','sensor_msgs/LaserScan'};
setting.subTopic(2,:) = {'/scan_back' ,'sensor_msgs/LaserScan'};
Sensor.param = setting;
% Sensor.pfunc = str2func("rover_pub");
Sensor.pfunc = @rover_pub;
%% ローバー自身の点群認識
    function  ptCloudOut = rover_pub(sensor_data)
    for i = 1:length(sensor_data)
        data2pcd = rosReadCartesian(sensor_data{i});
        moving_pc(i) = pointCloud([data2pcd zeros(size(data2pcd,1),1)]); % moving:m*3           
    end
        
        roi = [0.1 0.35 -0.18 0.16 -0.1 0.1];
        
        indices_f = findPointsInROI(sensor_data(1),roi);
        Df = zeros(size(sensor_data(1).Location));
        
        indices_b = findPointsInROI(sensor_data(2),roi);
        Db = zeros(size(sensor_data(2).Location));
        
        Df(indices_f,3) = 5;
        Db(indices_b,3) = 5;
        ptCloud_tf = pctransform(sensor_data(1),Df);
        ptCloud_tb = pctransform(sensor_data(2),Db);
        % %%%%%%%%%ローバー自身の点群除去%%%%%%%%%%%%%%
        roi = [-10 10 -10 10 -1 1];%入力点群の x、y および z 座標の範囲内で直方体 ROI を定義
        
        
        indices_f = findPointsInROI(ptCloud_tf,roi);%直方体 ROI 内にある点のインデックスを検出
        sensor_data(1) = select(ptCloud_tf,indices_f);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納    
        
        indices_b = findPointsInROI(ptCloud_tb,roi);%直方体 ROI 内にある点のインデックスを検出
        sensor_data(2) = select(ptCloud_tb,indices_b);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納
        %% pcd合成
        rot = eul2rotm(deg2rad([0 0 180]),'XYZ'); %回転行列(roll,pitch,yaw)
        T = [0.46 0.023 0]; %並進方向(x,y,z)
        tform = rigidtform3d(rot,T);
        
        moving_pc2_m_b = pctransform(sensor_data(2),tform);
        
        ptCloudOut = pcmerge(sensor_data(1), moving_pc2_m_b, 0.001);
    end

end