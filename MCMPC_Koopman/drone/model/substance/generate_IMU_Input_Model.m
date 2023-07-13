% 
%% Initialize
% do initialize first in main.m
%clc
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%% Define variables
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms a1 a2 a3 u u1 u2 u3 u4 T1 T2 T3 T4 real
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
q	= [  q1;  q2;  q3];        % Euler angle
ob	= [  o1;  o2;  o3];             % Angular velocity
[Rb0,L] = RodriguesQuaternion(Eul2Quat(q));   % Rotation matrix
Rb0 = simplify(Rb0);

% ddpg=ddpG*T
%% SS equation
% Usage: dx=f+g*u
% Rb0*a - [0;0;-g] : acceleration
% a : imu output
x = [p;dp;q];            % 13 states
f = [dp;-[0;0;-9.80665];[0;0;0]];
g = [zeros(3,6);Rb0,zeros(3,3);zeros(3,3),eye(3)];

%% euler angle model : roll-pitch-yaw(XYZ) euler angle 
syms roll pitch yaw droll dpitch dyaw real
% q0 = cos(roll)*cos(pitch)*cos(yaw) + sin(roll)*sin(pitch)*sin(yaw);
% q1 = sin(roll)*cos(pitch)*cos(yaw) - cos(roll)*sin(pitch)*sin(yaw);
% q2 = cos(roll)*sin(pitch)*cos(yaw) + sin(roll)*cos(pitch)*sin(yaw);
% q3 = cos(roll)*cos(pitch)*sin(yaw) - sin(roll)*sin(pitch)*cos(yaw);
Eq0 = cos(roll/2)*cos(pitch/2)*cos(yaw/2) + sin(roll/2)*sin(pitch/2)*sin(yaw/2);
Eq1 = sin(roll/2)*cos(pitch/2)*cos(yaw/2) - cos(roll/2)*sin(pitch/2)*sin(yaw/2);
Eq2 = cos(roll/2)*sin(pitch/2)*cos(yaw/2) + sin(roll/2)*cos(pitch/2)*sin(yaw/2);
Eq3 = cos(roll/2)*cos(pitch/2)*sin(yaw/2) - sin(roll/2)*sin(pitch/2)*cos(yaw/2);
Eq = [Eq0;Eq1;Eq2;Eq3];
[ERb0,EL] = RodriguesQuaternion(Eq) ;
er = [roll;pitch;yaw];
dP=jacobian(Eq,er);
dER=solve(dP*[droll;dpitch;dyaw]==EL'*ob/2,[droll dpitch dyaw]);
der = simplify([dER.droll;dER.dpitch;dER.dyaw]);
ddpg = ERb0*[0;0;(T1+T2+T3+T4)/m];
ddpG = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),ddpg,'UniformOutput',false)),1:3,1:4));%*IT;
% ddpg=ddpG*T
%% SS equation
% % Usage: dx=f+g*u
xp = [p;er;dp;ob];            % 13 states
fp = [dp;der;ddpf;dobf];
%fp = [dp;ob;ddpf;dobf];
gp = [zeros(3,4);zeros(3,4);ddpG;dobg];
u = [u1;u2;u3;u4];
matlabFunction(fp+gp*[u1;u2;u3;u4],'file','roll_pitch_yaw_thrust_force_physical_parameter_model','vars',{xp u cell2sym(physicalParam)},'outputs',{'dx'});
