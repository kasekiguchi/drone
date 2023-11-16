function Sensor=Sensor_Yolo(param)
    Sensor.name=["Yolo"];
    Sensor.type=["YOLO"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopicName = {'/boundingbox_msgs'};
    Sensor.param.subMsgName = {'std_msgs/Float32MultiArray'};
    Sensor.param.subTopic = ros2node("submatlab",param.DomainID);
    Sensor.param.subTopic = ros2node("submatlab2",param.DomainID);
    Sensor.param.DomainID = param.DomainID; %% check
end