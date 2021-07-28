function Reference = Reference_TrackingWaypointPath(WayPoint,velocity,convjudge,initial)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
Reference.type=["TrackingWaypointPath"];
Reference.name=["TrackingWaypointPath"];
%for i = 1:length(agent)
    Reference.param={WayPoint,velocity,convjudge,initial};
   % agent(i).set_reference(Reference);
%end
end
