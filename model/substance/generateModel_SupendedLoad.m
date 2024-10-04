%% Initialize
% do initialize first in main.m
clear 
%clc
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%% Define variables
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms u u1 u2 u3 u4 T1 T2 T3 T4 real
syms R real
syms m l jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 real
syms mL Length real % 
syms pl1 pl2 pl3 dpl1 dpl2 dpl3 ol1 ol2 ol3 real
syms pT1 pT2 pT3 real
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
q	= [  q0;  q1;  q2;  q3];        % Quaternion
ob	= [  o1;  o2;  o3];             % Angular velocity
pl  = [ pl1; pl2; pl3];             % Load position
dpl = [dpl1;dpl2;dpl3];             % Load velocity
ol  = [ ol1; ol2; ol3];             % Load angular velocity
pT  = [ pT1; pT2; pT3];             % String position
[Rb0,L] = RodriguesQuaternion(q);   % Rotation matrix
T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
% 前：ｘ軸，　左：y軸，　上：ｚ軸
% motor configuration 
% T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
% T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
%tau = [sqrt(2)*l*(T3+T4-T1-T2)/2; sqrt(2)*l*(T1+T3-T2-T4)/2; km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body
% IT=inv([1, 1, 1, 1;simplify(mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),tau,'UniformOutput',false)),1:3,1:4))]);
%% Translational model
ddpf = [0;0;-gravity];
%ddpg = Rb0*[0;0;(T1+T2+T3+T4)/m];
ddpg = Rb0*[0;0;u1/m];
ddpG = [Rb0*[0;0;1/m],zeros(3)];
%% Rotational model
Ib = diag([jx,jy,jz]);
dq = L'*ob/2;
%T2T = simplify(Mtake(cell2sym(arrayfun(@(A) fliplr(coeffs(A, T)),tau,'UniformOutput',false)),1:3,1:4));
%simplify(tau - T2T*T)
dobf = inv(Ib)*(-Skew(ob)*Ib*ob);
dobg = simplify([zeros(3,1),inv(Ib)]);
%% SS equation
% % Usage: dx=f+g*u
x = [q;p;dp;ob];            % 13 states
u = [u1;u2;u3;u4]; % thrust, torques
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
% matlabFunction(f,'file','F.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
% matlabFunction(g,'file','G.m','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
%%
nonlinearModel = subs(f+g*[u1;u2;u3;u4], physicalParam, physicalParamV);
% matlabFunction(nonlinearModel,'file','euler_parameter_thrust_force_model','vars',{x u},'outputs',{'dx'});
% matlabFunction(f+g*[u1;u2;u3;u4],'file','euler_parameter_thrust_force_physical_parameter_model','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});

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
% matlabFunction(fp+gp*[u1;u2;u3;u4],'file','roll_pitch_yaw_thrust_force_physical_parameter_model','vars',{xp u cell2sym(physicalParam)},'outputs',{'dx'});

%% Calculate Jacobian matrix
%jacobianA = jacobian(nonlinearModel,x);
% matlabFunction(jacobianA,'file','JacobiA.m','vars',{x u},'outputs',{'a'});
%% 単機牽引用の変数
clear
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms u u1 u2 u3 u4 T1 T2 T3 T4 real
syms R real
syms m l jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 Lx Ly lx ly lz rotor_r cableL real
syms mL Length real % 
syms pl1 pl2 pl3 dpl1 dpl2 dpl3 ol1 ol2 ol3 real
syms pT1 pT2 pT3 real
e3=[0;0;1];                         % z directional unit vector
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
ddp	= [ddp1;ddp2;ddp3];             % Accelaletion
q	= [  q0;  q1;  q2;  q3];        % Quaternion
ob	= [  o1;  o2;  o3];             % Angular velocity
pl  = [ pl1; pl2; pl3];             % Load position
dpl = [dpl1;dpl2;dpl3];             % Load velocity
ol  = [ ol1; ol2; ol3];             % Load angular velocity
pT  = [ pT1; pT2; pT3];             % String position
[Rb0,L] = RodriguesQuaternion(q);   % Rotation matrix
U = [u1;u2;u3;u4];                  % Thrust force ：正がzb 向き
%オイラー角をクオータニオンに変換
syms roll pitch yaw droll dpitch dyaw real
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
Ib = diag([jx,jy,jz]);
dq = L'*ob/2;
%% With load model 階層型線形化用論文通りのモデル
syms Lx Ly lx ly lz rotor_r cableL real
% physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r, Length, mL, cableL};
physicalParam = {m, jx, jy, jz, gravity, mL, cableL};

e3=[0;0;1];
dol  = cross(-pT,u1*Rb0*e3)/(m*cableL); % ケーブル角加速度
dpT  = cross(ol,pT); % 機体から見たケーブル上の単位長さの位置の速度
ddpT = cross(dol,pT)+cross(ol,dpT); % 単位長さの位置の加速度
ddpl  = [0;0;-gravity]+(dot(pT,u1*Rb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL); % 牽引物体の加速度
ddp  = ddpl-cableL*ddpT;
dob  = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];%ケーブルの張力は未考慮
dq   = L'*ob/2;
x=[q;ob;pl;dpl;pT;ol];
f=[dq;dob;dpl;ddpl;dpT;dol];
U = [u1;u2;u3;u4];
Fl= subs(f,U,[0;0;0;0]);
Gl =  [subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl, subs(subs(f,[u1;u3;u4],[0;0;0]),u2,1)-Fl, subs(subs(f,[u2;u1;u4],[0;0;0]),u3,1)-Fl, subs(subs(f,[u2;u3;u1],[0;0;0]),u4,1)-Fl];    
simplify(f - (Fl+Gl*U))
% matlabFunction(Fl,'file','FL','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
% matlabFunction(Gl,'file','GL','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
% matlabFunction(f,'file','with_load_model','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});
matlabFunction(Fl,'file','FL2','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
matlabFunction(Gl,'file','GL2','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
matlabFunction(f,'file','with_load_model2','vars',{x u cell2sym(physicalParam)},'outputs',{'dx'});
%% plant用ドローンの位置と速度も計測できるようになっている
dol  = cross(-pT,u1*Rb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddpT = cross(dol,pT)+cross(ol,dpT);
ddpl  = [0;0;-gravity]+(dot(pT,u1*Rb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
ddp  = ddpl-cableL*ddpT;
dob  = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
dq   = L'*ob/2;
x=[p;q;dp;ob;pl;dpl;pT;ol];
f=[dp;dq;ddp;dob;dpl;ddpl;dpT;dol];
matlabFunction(f,'file','with_load_model_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% estimate用ドローンの位置と速度も計測できるようになっている
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddP  = ddPL-cableL*ddPT;
x=[p;er;dp;ob;pl;dpl;pT;ol];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL];
matlabFunction(f,'file','with_load_model_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% 質量推定も可能
% a*mL = mL*g + mu
syms mLDummy
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r, Length, mLDummy, cableL};
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
ddP  = ddPL-cableL*ddPT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
x=[p;er;dp;ob;pl;dpl;pT;ol;mL];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL;0];
matlabFunction(f,'file','with_load_model_mL_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});

%% Local functions
function m = Mtake(mat,m,n)
    m = mat(m,n);
end
