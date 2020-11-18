function Sensor=Sensor_ROS(param)
    Sensor.name=["ros"];
    Sensor.type=["ROS"];
    % X, Y. Z
    Sensor.param=param;
    Sensor.param.state_list = ["p","q"];
    Sensor.param.num_list = [3,4];
    Sensor.param.subTopic = ['/tf','/mavros/local_position/pose'];
    Sensor.param.subName = ["p","q"];
end
