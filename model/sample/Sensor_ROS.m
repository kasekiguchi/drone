function Sensor=Sensor_ROS(param)
    % X, Y. Z
    Sensor=param;
    Sensor.state_list = ["p"];
    Sensor.num_list = [3,3];
    Sensor.subTopic = ros2node("/sensormatlab",param.DomainID);
    Sensor.subTopicName = ["/sensor_state"];
    Sensor.subMsgName = {'turtlebot3_msgs/SensorState'};
    Sensor.DomainID = param.DomainID; %% check
end
