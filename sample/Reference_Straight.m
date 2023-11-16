function Reference = Reference_Straight(agent,waypoint)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["straight"];
Reference.type=["STRAIGHT"];

velocity = 0.1;%目標速度

Reference.param={velocity,waypoint,agent.estimator.ukfslam.constant};
end

