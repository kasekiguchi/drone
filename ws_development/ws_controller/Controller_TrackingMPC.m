function Controller= Controller_TrackingMPC(dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.dt = dt;
Controller_param.H = 3;
% Controller.type="TrackingMPC_Controller";
% Controller.name="TrackingMPC_Controller";
Controller.type="TrackingMPCMEX_Controller";
Controller.name="ref_track";
Controller.param=Controller_param;
end
