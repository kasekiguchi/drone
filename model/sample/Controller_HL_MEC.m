function Controller=Controller_HL_MEC(dt)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
% Controller.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % xdiag([100,10,10,1])
% Controller.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % ydiag([100,10,10,1])
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角 
Controller.F1=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
Controller.F2=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[0.1]);
Controller.F3=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[0.1]);
Controller.F4=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);

Controller.dt = dt;
 eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
 
%% MEC_param.
% Kz = [200 25];
% % Kz = [65.5882 61.2427];
Kx = [50, 0 ,0, 0];
Ky = [50, 0, 0, 0];

%w/o MEC
Kz = [0 0];
% Kx = [0 0 0 0];
% Ky = [0 0 0 0];
 
Controller.K = [Kz Kx Ky];

end
