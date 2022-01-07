function Sensor = Sensor_Motive(rigid_num,motive)
%% sensor class demo : constructor
% sensor property をSensor classのインスタンス配列として定義
% rpos : RnagePos_sim
Sensor.name=["motive"];
Sensor.type=["Motive"];
prime_param.Flag = struct('Noise',0,'Occlusion', 0); % '1' : Active, '0' : none
prime_param.ObjFeature=4;
prime_param.LocalX     = [ 0.075, -0.075,  0.015;  -0.075, -0.075, -0.015;-0.075,  0.075,  0.015;0.075,  0.075, -0.015]; 
prime_param.LPF_T=10;
% X, Y. Z
    prime_param.rigid_num=rigid_num;
    prime_param.motive = motive;
    Sensor.param=prime_param;
end
