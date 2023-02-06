function Sensor=Sensor_Motive_ROS(param)
    Sensor.name=["motive"];
    Sensor.type=["Motive_ros"];
    %50系統でROS経由での受け渡し
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopicName = {'/Robot_1/pose' };
    Sensor.param.subMsgName = {'geometry_msgs/PoseStamped' };
    Sensor.param.subTopic = ros2node("submatlab",param.DomainID);
    Sensor.param.subTopic = ros2node("submatlab2",param.DomainID);
    Sensor.param.DomainID = param.DomainID; %% check
end