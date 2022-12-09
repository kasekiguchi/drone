function sensor=Sensor_tokyu(param)
    sensor.name=["telemetry"];
    sensor.type=["Flightcontroller"];
    % X, Y. Z
    sensor.param=param;
    sensor.param.state_list = ["p"];
    sensor.param.num_list = [3,3];
    sensor.param.subTopic = ros2node("/sensormatlab",30);
    sensor.param.subTopicName = ["/mavlinkdriver/Tokyu_ESC_status"];
    sensor.param.subMsgName = ["std_msgs/Float64MultiArray"];
    sensor.param.DomainID = param.DomainID; %% check
end
