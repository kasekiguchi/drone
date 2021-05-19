function Controller= Controller_LocalPlanning(id,dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.gain = 1;
Controller_param.Particles = 10;
Controller_param.dt = dt;

Controller.type="LocalPlanning_Controller";
Controller.name="LocalPlanning_Controller";
Controller.param=Controller_param;

%assignin('base',"Controller_param",Controller_param);

end
