function Reference = Reference_TrackWpointPathForMPC(WayPoint,velocity,w_velocity,convjudgeV,convjudgeW,initial,Holizon)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["TrackWpointPathForMPC"];
Reference.type=["PathReferenceForMPC"];
Reference.param={WayPoint,velocity,w_velocity,convjudgeV,convjudgeW,initial,Holizon};
end
