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
% matlabFunction(H,'File','JacobH_18_2','vars',{x,[a,b,c,d],param});
% matlabFunction(yh,'File','H_18_2','vars',{x,[a,b,c,d],dummy});

% clc
% clear
% close all
% syms x [12 1] real %[p;q;v;w;ps;qs;l] 22状態 ps:オフセット，qs:センサへの回転(euler)，l:壁パラ
% syms y real
% syms psb [3 1] real
% syms qs [3 1] real
% syms param [1 17] real
% syms a b c d real
% syms dummy
% A = [a, b, c];
% X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*psb + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0];
% %% 
% alpha =A *(x(1:3)+RodriguesQuaternion(Eul2Quat(x(4:6)))*psb);
% beta = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*[1;0;0]);
% beta2 = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(qs))*RodriguesQuaternion(Eul2Quat([0;0;pi/90]))*[1;0;0]);
% %% ax+by+cz+d=0⇔AX=-dじゃね？
% y = (-d- alpha)/beta;
% y2 = (-d- alpha)/beta2;
% h = jacobian(y,x);
% h2 = jacobian(y2,x);
% O = [eye(6),zeros(6,6)];
% H = [O;h;h2];
% yh = [x(1:6);y;y2];
% matlabFunction(H,'File','JacobH_12_2','vars',{x,[a,b,c,d],psb,qs,param});
% matlabFunction(yh,'File','H_12_2','vars',{x,[a,b,c,d],psb,qs,dummy});

% syms x [22 1] real %[p;q;v;w;ps;qs;l] 22状態 ps:オフセット，qs:センサへの回転(euler)，l:壁パラ
% syms y real
% syms param [1 17] real
% syms dummy
% A = [x(19), x(20), x(21)];
% d = x(22);
% X = x(1:3) +RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15) + y*RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0];
% %% 
% alpha =A *(x(1:3)+RodriguesQuaternion(Eul2Quat(x(4:6)))*x(13:15));
% beta = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*[1;0;0]);
% beta2 = A*(RodriguesQuaternion(Eul2Quat(x(4:6)))*RodriguesQuaternion(Eul2Quat(x(16:18)))*RodriguesQuaternion(Eul2Quat([0;0;pi/90]))*[1;0;0]);
% %% ax+by+cz+d=0⇔AX=-dじゃね？
% y = (-d- alpha)/beta;
% y2 = (-d- alpha)/beta2;
% h = jacobian(y,x);
% h2 = jacobian(y2,x);
% O = [eye(6),zeros(6,16)];
% H = [O;h;h2];
% yh = [x(1:6);y;y2];
% matlabFunction(H,'File','JacobH_22_2','vars',{x,param});
% matlabFunction(yh,'File','H_22_2','vars',{x,dummy});