% function Sensor = Sensor_VL53L1X(id)
function Sensor = Sensor_VL53L1X(DomainID)
    Sensor.name=["VL"];
    Sensor.type=["VL53L1X"];
    % ESPr
%     Sensor.param.portnumber = 8025;%自ポート番号
%     Sensor.param.RemoteIPPort = 22;%raspiのポート番号
%     Sensor.param.ReceiveBufferSize = 1;%バッファサイズ;
%     Sensor.param.RemoteIPAddress = '192.168.100.137';
%     Sensor.param.MaximumMessageLength = 15;
%     Sensor.param.id=id;

    % X, Y. Z（ros2）
%     Sensor.param=param;
    Sensor.state_list = ["p"];
    Sensor.num_list = [3,3];
%     Sensor.subTopic = ros2node("/Sensormatlab",33);
%     Sensor.subTopicName = ["/vl53l1x/range"];%ros2 topic listででる
%     Sensor.subMsgName = ["sensor_msgs/Range"];%ros2 topic list -t で出る
    Sensor.DomainID = DomainID; %% check
end