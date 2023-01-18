function Reference = Reference_Jirei(agent,SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["jirei"];
Reference.type=["JIREI_REFERENCE"];

velocity = 0.1;%目標速度
screenX = 640;
screenY = 480;

Reference.param={velocity,screenX,screenY};