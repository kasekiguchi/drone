function Controller= Controller_LocalPlanningForODV(i,dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.gain = 1;
Controller_param.Particles = 10;
Controller_param.dt = dt;
Controller_param.id = i;
Controller.type="LocalPlanning_ControllerForODV";
Controller.name="LocalPlanning_ControllerForODV";
Controller.param=Controller_param;


%assignin('base',"Controller_param",Controller_param);

end
