function Reference = Reference_Zigzag(agent,SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["path_ref_mpc"];
Reference.type=["ZIGZAG_REFERENCE"];

velocity = 0.1;%目標速度
Horizon = 5;%MPCのホライゾ
ztheta = 0.4;

Reference.param={velocity,Horizon,SensorRange,agent.estimator.ukfslam.constant,ztheta};