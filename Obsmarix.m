% clc
% clear
% close all
syms x [18 1] real %[p;q;v;w;ps;qs;l] 22状態 ps:オフセット，qs:センサへの回転(euler)，l:壁パラ
syms y real
syms param [1 17] real
syms a b c d real
syms dummy
A = [a, b, c];
X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15) + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0];
%% 
alpha =A *(x(1:3)+RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15));
beta = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0]);
beta2 = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*RodriguesQuaternion(Eul2Quat([0;0;pi/90]))*[1;0;0]);
%% ax+by+cz+d=0⇔AX=-dじゃね？
y = (-d- alpha)/beta;
y2 = (-d- alpha)/beta2;
h = jacobian(y,x);
h2 = jacobian(y2,x);
O = [eye(6),zeros(6,12)];
H = [O;h;h2];
yh = [x(1:6);y;y2];
matlabFunction(H,'File','JacobH_18_2','vars',{x,[a,b,c,d],param});
matlabFunction(yh,'File','H_18_2','vars',{x,[a,b,c,d],dummy});

% syms x [12 1] real %[p;q;v;w;ps;qs;l] 22状態 ps:オフセット，qs:センサへの回転(euler)，l:壁パラ
% syms y real
% syms param [1 17] real
% syms a b c d real
% syms psb [3 1] real 
% syms qs [3 1] real 
% syms dummy 
% % wall_param = [0,1,0,-9];
% % a=0;
% % b=1;
% % c=0;
% % d=-9;
% % psb = [0.1;0.1;0.1];
% % qs = [0;0;pi/2];
% A = [a, b, c];
% X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*psb + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0];
% %% 
% % alpha =(A*x(1:3) + A*RodriguesQuaternion(Eul2Quat(x(4:6)))*psb);
% % beta = A*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0];
% % %% ax+by+cz+d=0⇔AX=-dじゃね？
% % y = (-d-alpha)/beta;
% y = (-d - A*x(1:3) - A*RodriguesQuaternion(Eul2Quat(x(4:6)))*psb)/(A*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0]);%ここチェックしてみる
% % h = jacobian(y,x);
% % O = [eye(6),zeros(6,6)];
% H = [O;h];
% yh = [x(1:6);y];
% matlabFunction(yh,'File','H_12_kiti','Vars',{x,[a,b,c,d],psb,qs,param});

