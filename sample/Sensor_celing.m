function Sensor = Sensor_celing(id)
%SENSOR_CELING この関数の概要をここに記述
%   詳細説明をここに記述
Sensor.name=["celing"];
Sensor.type=["sensor_ceiling_sim"];
celing_param.distance = 3;
celing_param.angle_range = -pi:0.1:pi;%角度
celing_param.pitch = 0.1;
Sensor.param.id = id;
Sensor.param=celing_param; 
end

