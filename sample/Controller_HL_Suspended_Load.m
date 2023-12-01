function Controller = Controller_HL_Suspended_Load(dt)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
Controller.P=getParameter_withload();
Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,10]),[1],dt);
Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.1],dt);
Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.1],dt);
Controller.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F2)
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F3)

Controller.dt = dt;

end
