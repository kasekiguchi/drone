function Sensor=Sensor_ROS(param)
    Sensor.name=["ros"];
    Sensor.type=["ROS"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p"];
    Sensor.param.num_list = [3,3];
    Sensor.param.subTopic = ["/mavros/local_position/pose"];
    Sensor.param.subName = ["p"];
    Sensor.ROSHostIP = param.ROSHostIP;
end
