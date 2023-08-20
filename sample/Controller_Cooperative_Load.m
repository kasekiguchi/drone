function Controller= Controller_Cooperative_Load(dt,N)

%%
%g4 = lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,10,10,100]),1,dt);
% g1r = lqrd([0,1;0,0],[0;1],diag([1 10]),1,dt); % 1 10 1 : 100 1 0.01
% g3 = lqrd([0,1;0,0],[0;1],diag([1 1]),10,dt);%  1 1 50 : 1 10 0.05
% g4 = lqrd(diag([1,1,1],1),[0;0;0;1],diag([5,1,1,1]),10,dt);
% g1r = lqrd([0,1;0,0],[0;1],diag([10 10]),1,dt); % 1 10 1 : 100 1 0.01
% g3 = lqrd([0,1;0,0],[0;1],diag([1 1]),0.1,dt);%  1 1 50 : 1 10 0.05 r
%%
g1p = lqrd([0,1;0,0],[0;1],diag([10 1]),100,dt); % 1 10 1
g1r = lqrd([0,1;0,0],[0;1],diag([10 1]),10,dt); % 1 10 1 : 100 1 0.01
g2 = lqrd([0,1;0,0],[0;1],diag([1 100]),100,dt); % 1 1 0.001 : 1 1 1
g3 = lqrd([0,1;0,0],[0;1],diag([1 1]),1000,dt);%  1 1 50 : 1 10 0.05
% g1p = lqrd([0,1;0,0],[0;1],diag([1 1]),1000,dt); % 1 10 1
% g1r = lqrd([0,1;0,0],[0;1],diag([1 1]),100,dt); % 1 10 1 : 100 1 0.01
% g2 = lqrd([0,1;0,0],[0;1],diag([1 1]),1,dt); % 1 1 0.001 : 1 1 1
% g3 = lqrd([0,1;0,0],[0;1],diag([1 1]),1,dt);%  1 1 50 : 1 10 0.05
%Controller.gains = [g1p(1)*[1 1 1],g1r(1),g1p(2)*[1 1 1],g1r(2),g2,g3,0.1];
%Controller.gains = [g4(1)*[1 1 1],g1r(1),g4(2)*[1 1 1],g1r(2),g4(3),g4(4),g3,0.1];
% Controller.gains = [g4(1)*[1 1], g1p(1),g4(1),g4(2)*[1 1], g1p(2),g4(2),g4(3),g4(4),g3,1];
Controller.gains = [g1p(1)*[1 1 1],g1r(1),g1p(2)*[1 1 1],g1r(2),g2,g3,1];
% gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon]';

Controller.method = "CooperativeSuspendedLoadController_"+N;
% 設定確認
Controller.dt = dt;
% eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end
