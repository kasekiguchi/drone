function Sensor=Sensor_ROS(param)
    Sensor.name=["lrf"];
    Sensor.type=["ROS"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopicName = {'/scan'};
    Sensor.param.subMsgName = {'sensor_msgs/LaserScan'};
    Sensor.param.subTopic = ros2node("submatlab",param.DomainID);
    Sensor.param.subTopic = ros2node("submatlab2",param.DomainID);
    Sensor.param.DomainID = param.DomainID; %% check
end