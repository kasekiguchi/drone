function Controller = Controller_HL_Suspended_Load(dt,agent)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
Controller.P=agent.parameter.get();
 Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);%位置z、速度z
  Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.01],dt);%xの位置、速度、加速度%次回相対的に速度を上げて位置を下げる
  Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,100,10,10,10]),[0.01],dt);%yの位置、速度、加速度
 % Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,1000,10,10,10]),[0.1],dt);%xの位置、速度、加速度
 % Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,1000,1000,10,10,10]),[0.1],dt);%yの位置、速度、加速度
 % Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,100000,100000,1,1,1]),[0.001],dt);%xの位置、速度、加速度   加速度で滑らかになったきがした[100000,1,100000,1,1,1]),[0.001]
 % Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([100000,100000,100000,1,1,1]),[0.001],dt);%yの位置、速度、加速度[100000,1000,100000,1,1,1]),[0.001]
 % Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([60000,1000,1,0.1,0.1,0]),[0.1],dt);%xの位置、速度、加速度   加速度で滑らかになったきがした[100000,1,100000,1,1,1]),[0.001]
 % Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([60000,1000,1,0.1,0.1,0]),[0.1],dt);%yの位置、速度、加速度[100000,1000,100000,1,1,1]),[0.001]飛ぶけど収束しない。

 Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);%yawの位置、速度、100,1,1
%↓DEMOブランチから
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([5,1]),[1],dt);
% Controller.F2=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([10000,10,10,1,1,1]),[0.1],dt);%diag([100000,1000,100,10,10,10]),[0.001],dt);
% Controller.F3=lqrd([0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0],[0;0;0;0;0;1],diag([10000,10,10,1,1,1]),[0.1],dt);%diag([100000,1000,100,10,10,10]),[0.001],dt);
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);
%↑DEMOブランチから

%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F2)
%  eig(diag([1,1,1,1,1],1)-[0;0;0;0;0;1]*Controller.F3)

Controller.dt = dt;

end
