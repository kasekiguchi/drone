clc
clear
close all
% syms p [3 1] real
% syms q [3 1] real
% syms qs [3 1] real
% syms y y2 real 
% syms Rs [3 3] real
% syms Rn [3 3] real
% syms Re [3 3] real
% syms psb [3 1] real
% syms a b c d real
% 
% A = [a b c];
% X = p +RodriguesQuaternion(Eul2Quat(q))*psb + y*RodriguesQuaternion(Eul2Quat(q))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0];
% %%
% alpha =A *(p +RodriguesQuaternion(Eul2Quat(q))*psb);
% beta = A*(RodriguesQuaternion(Eul2Quat(q))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0]);
% y = d- alpha/beta;
% joutai = [p;q;psb;qs;a;b;c;d];
% jacobian_y = jacobian(y, joutai');
% mattlabFuntion(jacobian_y,'vars',joutai,param)



syms x [22 1] real
syms y real
syms p [1 17] real
A = [x(19) x(20) x(21)];
X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15) + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0];
%%
alpha =A *(RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15));
beta = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0]);
y = (x(22)- alpha)/beta;
h = jacobian(y,x);
O = [eye(6),zeros(6,16)];
matlabFunction([O;h],'File','JacobH_param','vars',{x,p});
