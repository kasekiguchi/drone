function Controller= Controller_TrackingMPC(id,dt,Holizon)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.dt = dt;
Controller_param.H = Holizon;
% Controller.type = "PtoP_contoller";
% Controller.type="TrackingMPC_Controller";
% Controller.name="TrackingMPC_Controller";
Controller.type="TrackingMPCMEX_Controller";
Controller.name="TrackingMPCMEX_Controller";
Controller.param=Controller_param;
end
