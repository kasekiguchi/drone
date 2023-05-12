function sensor=Sensor_Flightcontroller(param)
    sensor.name=["flightcontroller"];
    sensor.type=["Flightcontroller"];
    % X, Y. Z
    sensor.param=param;
    sensor.param.state_list = ["p"];
    sensor.param.num_list = [3,3];
    sensor.param.subTopic = ros2node("/sensormatlab_flight",40);
    sensor.param.subTopicName = ["/mavlinkdriver/Tokyu_ESC_status"];%ros2 topic listででる
    sensor.param.subMsgName = ["std_msgs/Float64MultiArray"];%ros2 topic list -t で出る
    sensor.param.DomainID = param.DomainID; %% check
end