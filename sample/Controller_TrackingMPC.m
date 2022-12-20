function Controller= Controller_TrackingMPC(dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.dt = dt;
Controller_param.H = 5;
Controller.type="TRACKING_MPC";
Controller.name="mpc";
Controller.param=Controller_param;
end
