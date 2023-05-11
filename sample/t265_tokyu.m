function sensor=t265_tokyu(param)
    sensor.name=["T265"];
    sensor.type=["t265_sensor"];
    % X, Y. Z
    sensor.param=param;
    sensor.param.state_list = ["p"];
    sensor.param.num_list = [3,3];
    sensor.param.subTopic = ros2node("/sensormatlab_tokyu",param.DomainID);
    sensor.param.subTopicName = ["/camera/pose/sample"];%ros2 topic listででる
    sensor.param.subMsgName = ["nav_msgs/Odometry"];%ros2 topic list -t で出る
    sensor.param.DomainID = param.DomainID; %% check
end