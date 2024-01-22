function Controller= Controller_Cooperative_Load(dt,N)

g1p = lqrd([0,1;0,0],[0;1],diag([1 15]),1,dt); % 1 10 1
g1z = lqrd([0,1;0,0],[0;1],diag([10 5]),1,dt); % 1 10 1
g1r = lqrd([0,1;0,0],[0;1],diag([1 10]),1,dt); % 1 10 1 : 100 1 0.01
g1rz = lqrd([0,1;0,0],[0;1],diag([1 15]),1,dt); % 1 10 1 : 100 1 0.01
g2 = lqrd([0,1;0,0],[0;1],diag([1 10]),10,dt); % 1 1 0.001 : 1 1 1
%g3 = lqrd([0,1;0,0],[0;1],diag([20 1]),10,dt);%  1 1 50 : 1 10 0.05
g3 = lqrd([0,1;0,0],[0;1],diag([3 5]),10,dt);%  1 1 50 : 1 10 0.05
Controller.gains = [g1p(1)*[1 1],g1z(1),g1r(1)*[1 1],g1rz(1),...
                    g1p(2)*[1 1],g1z(2),g1r(2)*[1 1],g1rz(2),g2,g3,1];
% gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon]';

Controller.method = "CooperativeSuspendedLoadController_"+N;
Controller.method2 = "Muid_"+N;
% 設定確認
Controller.dt = dt;
% eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end
