function Sensor=Sensor_motive(param)
    Sensor.name=["motive"];
    Sensor.type=["Motive_ros"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopic = ros2node("/sensormatlab",param.DomainID);
    Sensor.param.subTopicName = {'/Robot_1/pose'};
    Sensor.param.subMsgName = {'geometry_msgs/PoseStamped'};
    Sensor.param.DomainID = param.DomainID; %% check
end