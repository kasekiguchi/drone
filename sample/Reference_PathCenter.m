function Reference = Reference_PathCenter(agent,SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["path_ref_mpc"];
Reference.type=["PATH_REFERENCE"];

velocity = 0.5;%目標速度
Horizon = 5;%MPCのホライゾ

Reference.param={velocity,Horizon,SensorRange,agent.estimator.ukfslam.constant};
end
