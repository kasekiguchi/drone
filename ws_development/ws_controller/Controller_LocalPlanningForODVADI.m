function Controller= Controller_LocalPlanningForODVADI(i,dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
% Omni directional vehicle accel dimension input
Controller_param.gain = 1;
Controller_param.Particles = 10;
Controller_param.dt = dt;
Controller_param.id = i;
Controller.type="LocalPlanning_ControllerForODVADI";
Controller.name="LocalPlanning_ControllerForODVADI";
Controller.param=Controller_param;


%assignin('base',"Controller_param",Controller_param);

end
