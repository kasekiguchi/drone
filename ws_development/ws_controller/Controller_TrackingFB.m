function Controller= Controller_TrackingFB(id,gain,dt)
%% controller class: construct
% controller property をController classのインスタンス配列として定義
Controller_param.gain = gain;
Controller_param.dt = dt;

% Controller.type="LocalPlanning_Controller";
% Controller.name="LocalPlanning_Controller";
Controller.type="TrackingFB_Controller";
Controller.name="TfackingFB_Controller";
Controller.param=Controller_param;

%assignin('base',"Controller_param",Controller_param);

end
