%% Initialize
% do initialize first in main.m
%clc
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%% Define variables
syms W M r real % tread, mass, wheel radius
syms J jw real % z-axis body inertia, wheel inertia
% xb : 進行方向，yb : 左，zb ：上
syms p [3 1] real % Global 3d position
syms dp [3 1] real % velocity
syms ddp [3 1] real % acceleration
syms q [3 1] real % body-z, right-left wheel rotation
syms ob [3 1] real % body angular velocity wrt q
% ob + = y-axis : positive ob means move forward.
syms u [2 1] real % right-left wheel torque
physicalParam = {M,W,J,jw,r};
Rb0 = [cos(q1),-sin(q1),0;sin(q1),cos(q1),0;0,0,1];
F = sum(u)/r;       % Drive force
tau = W*(u1-u2)/(2*r); % torque
%% Translational model
ddpf = [0;0;-gravity];
ddpg = Rb0*[0;0;(T1+T2+T3+T4)/m];
ddpG = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),ddpg,'UniformOutput',false)),1:3,1:4));%*IT;
% ddpg=ddpG*T
%% Rotational model
Ib = diag([jx,jy,jz]);
dq = L'*ob/2;
T2T = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),tau,'UniformOutput',false)),1:3,1:4));
simplify(tau - T2T*T)
dobf = inv(Ib)*(-Skew(ob)*Ib*ob);
dobg = simplify(inv(Ib)*T2T);
%% SS equation
% % Usage: dx=f+g*u
x = [q;p;dp;ob];            % 13 states
u = [u1;u2;u3;u4];
f = [dq;dp;ddpf;dobf];
g = [zeros(4,4);zeros(3,4);ddpG;dobg];
 %% Linearization
% xe=[[1,0,0,0]';zeros(9,1)];
% Ac=simplify(subs(subs(pdiff(f,x),x,xe)+simplify(subs(g(:,1)*(1/m),x,xe)),pParam,physicalParamV));
% Bc=simplify(subs(subs(g,x,xe),pParam,physicalParamV));
% rank(ctrb(Ac,Bc))
% rank([Bc,Ac*Bc,Ac*Ac*Bc])
%% Make function of the quadrotor model : if model is modified, then evaluate this section.
clc
matlabFunction(f,'file','F.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
matlabFunction(g,'file','G.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
%%
nonlinearModel = subs(f+g*[u1;u2;u3;u4], physicalParam, physicalParamV);
matlabFunction(nonlinearModel,'file','euler_parameter_thrust_force_model','vars',{x u},'outputs',{'dx'});
matlabFunction(f+g*[u1;u2;u3;u4],'file','euler_parameter_thrust_force_physical_parameter_model','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});

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

%% Calculate Jacobian matrix
jacobianA = jacobian(nonlinearModel,x);
matlabFunction(jacobianA,'file','JacobiA.m','vars',{x u},'outputs',{'a'});

%% Local functions
function m = Mtake(mat,m,n)
    m = mat(m,n);
end
