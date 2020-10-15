function typical_Sensor_Motive(agent)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
Sensor.name=["motive"];
Sensor.type=["Motive"];
prime_param.Flag = struct('Noise',     0,                          'Occlusion', 0);
       % '1' = Addition of noise
prime_param.ObjFeature=4;
prime_param.LocalX     = [ 0.075, -0.075,  0.015;              -0.075, -0.075, -0.015;-0.075,  0.075,  0.015;0.075,  0.075, -0.015]; 
prime_param.LPF_T=10;
% X, Y. Z
for i = 1:length(agent)
    Sensor.param=prime_param;  
    agent(i).set_sensor(Sensor);
end
end
