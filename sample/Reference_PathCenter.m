function Reference = Reference_PathCenter(SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["path_ref_mpc"];
Reference.type=["PATH_REFERENCE"];

velocity = 1;%目標速度
w_velocity = 0.7;%曲がるときの目標角速度
convjudgeV = 0.5;%収束判断　% 0.5
convjudgeW = 0.5;%収束判断　
Horizon = 3;%MPCのホライゾ

Reference.param={velocity,Horizon,SensorRange};
end
