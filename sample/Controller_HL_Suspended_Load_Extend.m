function Controller = Controller_HL_Suspended_Load_Extend(dt)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
Controller_param.P=getParameter_withload();
Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,10]),[1],dt);
Controller_param.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([1000000,1000,100,10,10,10]),[0.1],dt);%diag([1000000,1000,100,10,10,10]),[0.1],dt);
Controller_param.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([1000000,1000,100,10,10,10]),[0.1],dt);
Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller_param.F2)
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller_param.F3)

Controller_param.dt = dt;
Controller.type="HLController_quadcopter_Suspended_Load_Extend";
Controller.name="hl_load_extend";
Controller.param=Controller_param;
%assignin('base',"Controller_param",Controller_param);

end
