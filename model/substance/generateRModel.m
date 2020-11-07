%% Initialize
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
%% Define variables
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms u u1 u2 u3 u4 T1 T2 T3 T4 real
syms m l jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 real
syms R r11 r12 r13 r21 r22 r23 r31 r32 r33 real
param.mass = 0.2;
param.length = 0.1;% モーター間の距離：正方形を仮定している
param.jx = 0.002237568;
param.jy = 0.002985236;
param.jz = 0.00480374;
param.gravity = 9.81;
param.km = 0.03010685884691849; % ロータ定数
param.k = 0.000008048;          % 推力定数

physicalParam = {m, l, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4};
physicalParamV		= {param.mass, param.length, param.jx, param.jy, param.jz, param.gravity, param.km, param.km, param.km, param.km, param.k, param.k, param.k, param.k};
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
ddp	= [ddp1;ddp2;ddp3];             % Accelaletion
R = [r11 r12 r13;r21 r22 r23;r31 r32 r33];
ob	= [  o1;  o2;  o3];             % Angular velocity
T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
% motor configuration 
% T1 : 左前，T2：左後，T3：右後，T4：右前（x-y平面の象限順）
% T1, T3 の回転軸 zb,  T2, T4 : -zb      [0,1,0,1] で 正のyaw回転
tau = [sqrt(2)*l*(T1+T2-T3-T4)/2; sqrt(2)*l*(T2+T3-T1-T4)/2; -km1*T1+km2*T2-km3*T3+km4*T4]; % Torque for body
% IT=inv([1, 1, 1, 1;simplify(mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),tau,'UniformOutput',false)),1:3,1:4))]);
%% Translational model
ddpf = [0;0;-gravity];
ddpg = R   *[0;0;(T1+T2+T3+T4)/m];
ddpG = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),ddpg,'UniformOutput',false)),1:3,1:4));%*IT;
% ddpg=ddpG*T
%% Rotational model
Ib = diag([jx,jy,jz]);
dR = R*Skew(ob)
T2T = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),tau,'UniformOutput',false)),1:3,1:4));
simplify(tau - T2T*T)
dobf = inv(Ib)*(-Skew(ob)*Ib*ob);
dobg = simplify(inv(Ib)*T2T);
%% SS equation
% % Usage: dx=f+g*u
x = [R2v(R);p;dp;ob];            % 18 states = [r11 r12 r13 ,....]
u = [u1;u2;u3;u4];
f = [R2v(dR);dp;ddpf;dobf];
g = [zeros(9,4);zeros(3,4);ddpG;dobg];
 %% Linearization
% xe=[[1,0,0,0]';zeros(9,1)];
% Ac=simplify(subs(subs(pdiff(f,x),x,xe)+simplify(subs(g(:,1)*(1/m),x,xe)),pParam,physicalParamV));
% Bc=simplify(subs(subs(g,x,xe),pParam,physicalParamV));
% rank(ctrb(Ac,Bc))
% rank([Bc,Ac*Bc,Ac*Ac*Bc])
%% Make function of the quadrotor model : if model is modified, then evaluate this section.
clc
matlabFunction(f,'file','RF.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
matlabFunction(g,'file','RG.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
nonlinearModel = subs(f+g*[u1;u2;u3;u4], physicalParam, physicalParamV);
matlabFunction(nonlinearModel,'file','rotation_matrix_thrust_force_model.m','vars',{x u},'outputs',{'dx'});
matlabFunction(f+g*[u1;u2;u3;u4],'file','rotation_matrix_thrust_force_physical_parameter_model.m','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});
%% Calculate Jacobian matrix

% jacobianA = jacobian(nonlinearModel,x);
% matlabFunction(jacobianA,'file','coreJacobiA.m','vars',[x' u1 u2 u3 u4],'outputs',{'a'});
% WriteWrapperFunctionForMatrix('JacobiA','coreJacobiA',{'x','u'},[13 4],{"A"},[13]);
%% Local functions
function m = Mtake(mat,m,n)
    m = mat(m,n);
end
function [R,L] = RodriguesQuaternion(q)
% % RodriguesQuaternion : R is the rotation matrix
    q  = q(:);
    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
	E = [-q1, q0,-q3, q2;
		 -q2, q3, q0,-q1;
		 -q3,-q2, q1, q0];
	L = [-q1, q0, q3,-q2;
		 -q2,-q3, q0, q1;
		 -q3, q2,-q1, q0];
	R = E*L';
end  
function Om = Skew(o)
% % Skew : Skew symmetric matrix
    o  = o(:);
    o1 = o(1);
    o2 = o(2);
    o3 = o(3);
    Om = [  0,-o3, o2;
		   o3,  0,-o1;
		  -o2, o1,  0];
end