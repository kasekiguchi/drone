function Sensor = Sensor_LSM9DS1()
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
Sensor.name=["imu"];
Sensor.type=["LSM9DS1"];
prime_param=[];
    Sensor.param=prime_param; 
  disp("Do : agent(i).sensor.imu.initialize(20)");
end
