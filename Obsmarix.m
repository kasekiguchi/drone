clc
clear
close all
syms x [22 1] real %[p;q;v;w;ps;qs;l] 22状態 ps:オフセット，qs:センサへの回転(euler)，l:壁パラ
syms y real
syms param [1 17] real
A = [x(19) x(20) x(21)];
X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15) + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0];
%% 
alpha =A *(RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15));
beta = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0]);
beta2 = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*RodriguesQuaternion(Eul2Quat([0;0;pi/180]))*[1;0;0]);
y = (x(22)- alpha)/beta;
y2 = (x(22)- alpha)/beta2;
h = jacobian(y,x);
h2 = jacobian(y2,x);
O = [eye(6),zeros(6,16)];
matlabFunction([O;h;h2],'File','JacobH_param2','vars',{x,param});

