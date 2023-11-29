% % function Sensor = Sensor_VL53L1X(param)
% function Sensor = Sensor_VL53L1X(DomainID)
%     Sensor.name=["VL"];
%     Sensor.type=["VL53L1X"];
%     % ESPr
% %     Sensor.param.portnumber = 8025;%自ポート番号
% %     Sensor.param.RemoteIPPort = 22;%raspiのポート番号
% %     Sensor.param.ReceiveBufferSize = 1;%バッファサイズ;
% %     Sensor.param.RemoteIPAddress = '192.168.100.137';
% %     Sensor.param.MaximumMessageLength = 15;
% %     Sensor.param.id=id;
% 
%     % X, Y. Z（ros2）
% %     Sensor.param=param;
%     Sensor.state_list = ["p"];
%     Sensor.num_list = [3,3];
% %     Sensor.subTopic = ros2node("/Sensormatlab",33);
% %     Sensor.subMsgName = ["sensor_msgs/Range"];%ros2 topic list -t で出
% %     Sensor.subTopicName = ["/vl53l1x/range"];%ros2 topic listででるる
%     Sensor.DomainID = DomainID; %% check

function Sensor = Sensor_VL53L1X(param)
% % X, Y. Z
% Sensor.param.subTopicName = {'/scan_front'};
% end

arguments
    param
end
param = param.plant;
Sensor.type = "VL53L1X";
Sensor.name = ["vl53"];%複数を想定
setting.conn_type = "vl53l1x";
setting.state_list = ["p"];
setting.numlist = [3, 3];
% Sensor.subTopicName=param{1,3};
% setting.subTopicName(1) = {'/scan_front'};
% setting.subTopicName(2) = {'/scan_back'};
% setting.subMsgName      = {'sensor_msgs/LaserScan'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sub 型
setting.subTopic(1,:) = {'/vl53l1x/range','sensor_msgs/Range'};%%%%%%%%%%%%sub topic name
Sensor.param = setting;
% Sensor.pfunc = str2func("rover_pub");
Sensor.pfunc = 0;
end