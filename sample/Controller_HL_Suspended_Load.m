function Controller = Controller_HL_Suspended_Load(dt,agent)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
A2 = [0 1;0 0];
B2 = [0;1];
A6 = [0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1; 0 0 0 0 0 0];
B6 = [0;0;0;0;0;1];
Controller.P=agent.parameter.get();
Controller.F1=lqrd(A2,B2,diag([100,10]),[1],dt);
Controller.F2=lqrd(A6,B6,diag([100000,1000,100,10,10,10]),[0.01],dt);
Controller.F3=lqrd(A6,B6,diag([100000,1000,100,10,10,10]),[0.01],dt);
Controller.F4=lqrd(A2,B2,diag([1,1]),[1],dt);

Controller.dt = dt;

end
