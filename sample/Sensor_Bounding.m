function Sensor = Sensor_Bounding(param)
%ヨロのデータを読み込む用のセンサ（試作）
arguments
    param.d = 3;
end
% sensor class demo : constructor
% sensor propertyをSensor classのインスタンス配列として定義
% bounding : IMAGE_BOUNDING_BOX_SIM
Sensor.name = ["bounding"];
Sensor.type = ["IMAGE_BOUNDING_BOX_SIM"];
bounding_param.d = param.d; % boxの一辺の半分の長さ
Sensor.param = bounding_param;
end

