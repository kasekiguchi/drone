function Controller = Controller_HL_Suspended_Load(dt,agent)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
Controller.P=agent.parameter.get();
Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,10]),[1],dt);
Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.1],dt);
Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.1],dt);
Controller.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
%↓DEMOブランチから
%Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([5,1]),[1],dt);
% Controller_param.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([10000,10,10,1,1,1]),[0.1],dt);%diag([100000,1000,100,10,10,10]),[0.001],dt);
% Controller_param.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([10000,10,10,1,1,1]),[0.1],dt);%diag([100000,1000,100,10,10,10]),[0.001],dt);
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);
%↑DEMOブランチから

%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F2)
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F3)

Controller.dt = dt;

end
