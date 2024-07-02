function Controller= Controller_Cooperative_Load(dt,N)
%変数に1が入っているものが重要
g1p = lqrd([0,1;0,0],[0;1],diag([1 15]),1,dt); % 1 10 1%ペイロード位置速度x,y
g1z = lqrd([0,1;0,0],[0;1],diag([10 5]),1,dt); % 1 10 1%ペイロード位置速度z
g1r = lqrd([0,1;0,0],[0;1],diag([1 10]),1,dt); % 1 10 1 : 100 1 0.01%姿勢角姿勢角速度rollpitch
g1rz = lqrd([0,1;0,0],[0;1],diag([1 15]),1,dt); % 1 10 1 : 100 1 0.01%姿勢角姿勢角速度yaw
g2 = lqrd([0,1;0,0],[0;1],diag([1 10]),10,dt); % 1 1 0.001 : 1 1 1%紐の角度,角速度を動かすための入力のゲイン(理想のリンクの方向に移動させる)rollpitchyaw統一
%g3 = lqrd([0,1;0,0],[0;1],diag([20 1]),10,dt);%  1 1 50 : 1 10 0.05
g3 = lqrd([0,1;0,0],[0;1],diag([3 5]),10,dt);%  1 1 50 : 1 10 0.05%機体の角度,角速度を動かすための入力のゲイン(理想の回転行列に移動させる)rollpitchyaw統一
% Controller.gains = [g1p(1)*[1 1],g1z(1),g1r(1)*[1 1],g1rz(1),...
                    % g1p(2)*[1 1],g1z(2),g1r(2)*[1 1],g1rz(2),g2,g3,1];%0<epsilon<epsilon*

kx0 = [g1p(1)*[1 1],g1z(1)];%ペイロード位置
kr0 = [g1r(1)*[1 1],g1rz(1)];%ペイロード速度
kdx0 = [g1p(2)*[1 1],g1z(2)];%ペイロード姿勢角
ko0 = [g1r(2)*[1 1],g1rz(2)];%ペイロード姿勢角速度
kqi = g2(1);%リンクの方向
kwi = g2(2);%リンクの角速度
kri = g3(1);%ドローンの角度
koi = g3(2);%ドローンの角速度
epsilon = 1;%安定性の為のパラメータ%0<epsilon<epsilon*
Controller.gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon];

% gains = [kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon];
% --dimention of gain--
% kx0 kr0 kdx0 ko0 = R^3
% kqi kwi kri koi epsilon = R

% Controller.method = "NewCooperativeSuspendedLoadController_"+N;
Controller.method = "CooperativeSuspendedLoadController_"+N;
Controller.method2 = "Muid_"+N;
% 設定確認
Controller.dt = dt;
end
