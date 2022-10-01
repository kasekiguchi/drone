function Reference = Reference_TrackWpointPathForMPC(SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["path_ref_mpc"];
Reference.type=["PathReferenceForMPC"];

velocity = 1;%目標速度
w_velocity = 0.7;%曲がるときの目標角速度
WayPoint = [0,0,0,0];%目標位置の初期値
convjudgeV = 0.5;%収束判断　% 0.5
convjudgeW = 0.5;%収束判断　
Horizon = 3;%MPCのホライゾ

Reference.param={WayPoint,velocity,w_velocity,convjudgeV,convjudgeW,Horizon,SensorRange};
end
