function Controller = Controller_HL_Suspended_Load(dt)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
Controller_param.P=getParameter_withload();
Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10000,1]),[1],dt);
Controller_param.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1,1,1,1,1]),[1],dt);
Controller_param.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1,1,1,1,1]),[1],dt);
Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);

Controller_param.dt = dt;
Controller.type="HLController_quadcopter_Suspended_Load";
Controller.name="hl_load";
Controller.param=Controller_param;
%assignin('base',"Controller_param",Controller_param);

end
