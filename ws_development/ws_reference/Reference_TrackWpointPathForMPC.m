function Reference = Reference_TrackWpointPathForMPC(WayPoint,velocity,convjudge,initial,Holizon)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
Reference.type=["TrackWpointPathForMPC"];
Reference.name=["TrackWpointPathForMPC"];
%for i = 1:length(agent)
    Reference.param={WayPoint,velocity,convjudge,initial,Holizon};
   % agent(i).set_reference(Reference);
%end
end
