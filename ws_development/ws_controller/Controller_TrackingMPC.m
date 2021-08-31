function Controller= Controller_TrackingMPC(id,dt,Holizon)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.dt = dt;
Controller_param.H = Holizon;

% Controller.type="LocalPlanning_Controller";
% Controller.name="LocalPlanning_Controller";
Controller.type="TrackingMPC_Controller";
Controller.name="TrackingMPC_Controller";
Controller.param=Controller_param;

%assignin('base',"Controller_param",Controller_param);

end
