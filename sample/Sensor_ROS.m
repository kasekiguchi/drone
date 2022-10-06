function Sensor=Sensor_ROS(param)
    Sensor.name=["ros"];
    Sensor.type=["ROS"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopic = ros2node("/sensormatlab",param.DomainID);
    Sensor.param.subTopicName = ["/sensor_state"];
    Sensor.param.subMsgName = {'turtlebot3_msgs/SensorState'};
    Sensor.param.DomainID = param.DomainID; %% check
end
