%% Initialize
% do initialize first in main.m
clear 
%clc
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%% 単機牽引用の変数
clear
syms p1 p2 p3 dp1 dp2 dp3 q0 q1 q2 q3 o1 o2 o3 real
syms u1 u2 u3 u4 T1 T2 T3 T4 real
syms R real
syms m l jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 Lx Ly lx ly lz rotor_r cableL real
syms mL real % 
syms pl1 pl2 pl3 dpl1 dpl2 dpl3 ol1 ol2 ol3 real
syms pT1 pT2 pT3 real
e3=[0;0;1];                         % z directional unit vector
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
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
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mL, cableL};

dol  = cross(-pT,u1*Rb0*e3)/(m*cableL); % ケーブル角加速度
dpT  = cross(ol,pT); % 機体から見たケーブル上の単位長さの位置の速度
ddpT = cross(dol,pT)+cross(ol,dpT); % 単位長さの位置の加速度
ddpl  = [0;0;-gravity]+(dot(pT,u1*Rb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL); % 牽引物体の加速度
ddp  = ddpl-cableL*ddpT;
dob  = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];%ケーブルの張力は未考慮
x=[q;ob;pl;dpl;pT;ol];
f=[dq;dob;dpl;ddpl;dpT;dol];
Fl= subs(f,U,[0;0;0;0]);
Gl =  [subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl, subs(subs(f,[u1;u3;u4],[0;0;0]),u2,1)-Fl, subs(subs(f,[u2;u1;u4],[0;0;0]),u3,1)-Fl, subs(subs(f,[u2;u3;u1],[0;0;0]),u4,1)-Fl];    
simplify(f - (Fl+Gl*U))
matlabFunction(Fl,'file','FL','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
matlabFunction(Gl,'file','GL','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
matlabFunction(f,'file','with_load_model','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
% matlabFunction(Fl,'file','FL2','vars',{x cell2sym(physicalParam)},'outputs',{'dxf'});
% matlabFunction(Gl,'file','GL2','vars',{x cell2sym(physicalParam)},'outputs',{'dxg'});
% matlabFunction(f,'file','with_load_model2','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% plant用ドローンの位置と速度も計測できるようになっている
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mL, cableL};
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
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mL, cableL};
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddP  = ddPL-cableL*ddPT;
x=[p;er;dp;ob;pl;dpl;pT;ol];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL];
matlabFunction(f,'file','with_load_model_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% 質量推定も可能
% a*mL = mL*g + mu
syms mLDummy real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mLDummy, cableL};
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
ddP  = ddPL-cableL*ddPT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
x=[p;er;dp;ob;pl;dpl;pT;ol;mL];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL;0];
matlabFunction(f,'file','with_load_model_mL_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% 質量推定+推力外乱推定も可能
% a*mL = mL*g + mu
syms mLDummy real
syms fdst real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mLDummy, cableL};
dOL = cross(-pT,(u1+fdst)*ERb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddPL = [0;0;-gravity]+(dot(pT,(u1+fdst)*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL);
ddP  = ddPL-cableL*ddPT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
x=[p;er;dp;ob;pl;dpl;pT;ol;mL;fdst];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL;0;0];
matlabFunction(f,'file','with_load_model_mL_fdst_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% 質量推定+x,y外乱推定も可能
syms mLDummy real
syms dstx dsty dstz real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mLDummy, cableL};
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL) + [dstx;dsty;dstz];
ddP  = ddPL-cableL*ddPT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
x=[p;er;dp;ob;pl;dpl;pT;ol;mL;dstx;dsty];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL;0;0;0];
matlabFunction(f,'file','with_load_model_mL_dstxyz_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% 質量推定+x,y,z外乱推定も可能
syms mLDummy real
syms dstx dsty real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mLDummy, cableL};
dOL = cross(-pT,u1*ERb0*e3)/(m*cableL);
dpT  = cross(ol,pT);
ddPT = cross(dOL,pT)+cross(ol,dpT);
ddPL = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL) + [dstx;dsty;0];
ddP  = ddPL-cableL*ddPT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4];
x=[p;er;dp;ob;pl;dpl;pT;ol;mL;dstx;dsty];
f=[dp;der;ddP;dob;dpl;ddPL;dpT;dOL;0;0;0];
matlabFunction(f,'file','with_load_model_mL_dstxy_euler_for_HL','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% With load model (Extend & Euler)
syms ex ey ez real
% physicalParam = {m, l, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4, mL, Length, ex, ey, ez};
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r, mL, cableL, ex, ey, ez};
e3=[0;0;1];
e1=[1;0;0];
dol  = cross(-pT,u1*ERb0*e3)/(m*cableL); % ケーブル角加速度
dpT  = cross(ol,pT); % 機体から見たケーブル上の単位長さの位置の速度
ddpT = cross(dol,pT)+cross(ol,dpT); % 単位長さの位置の加速度
ddpl  = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*cableL*dot(dpT,dpT))*pT/(m+mL); % 牽引物体の加速度
ddp  = ddpl-cableL*ddpT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4]+inv(Ib)*cross(ERb0*[ex;ey;-ez],-mL*(ddpl+[0;0;gravity]));
x=[p;er;dp;ob;pl;dpl;pT;ol];
f=[dp;der;ddp;dob;dpl;ddpl;dpT;dol];
U = [u1;u2;u3;u4];
Fl= subs(f,U,[0;0;0;0]);
Gl =  [subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl, subs(subs(f,[u1;u3;u4],[0;0;0]),u2,1)-Fl, subs(subs(f,[u2;u1;u4],[0;0;0]),u3,1)-Fl, subs(subs(f,[u2;u3;u1],[0;0;0]),u4,1)-Fl];    
simplify(f - (Fl+Gl*U))
matlabFunction(f,'file','euler_with_load_model','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% With load model (Extend & Euler & Parameter Estimation)
syms Length real
syms ex ey ez real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r,mL, cableL};
e3=[0;0;1];
e1=[1;0;0];
dol  = cross(-pT,u1*ERb0*e3)/(m*Length); % ケーブル角加速度
dpT  = cross(ol,pT); % 機体から見たケーブル上の単位長さの位置の速度
ddpT = cross(dol,pT)+cross(ol,dpT); % 単位長さの位置の加速度
ddpl  = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*Length*dot(dpT,dpT))*pT/(m+mL); % 牽引物体の加速度
ddp  = ddpl-Length*ddpT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4]+inv(Ib)*cross(ERb0*[ex;ey;-ez],-mL*(ddpl+[0;0;gravity]));
dq   = EL'*ob/2;
x=[p;er;dp;ob;pl;dpl;pT;ol;ex;ey;ez];%ここが違う
f=[dp;der;ddp;dob;dpl;ddpl;dpT;dol;0;0;0];
U = [u1;u2;u3;u4];
Fl= subs(f,U,[0;0;0;0]);
Gl =  [subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl, subs(subs(f,[u1;u3;u4],[0;0;0]),u2,1)-Fl, subs(subs(f,[u2;u1;u4],[0;0;0]),u3,1)-Fl, subs(subs(f,[u2;u3;u1],[0;0;0]),u4,1)-Fl];    
simplify(f - (Fl+Gl*U))
matlabFunction(f,'file','euler_with_load_model_parameter_estimation','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});
%% With load model (Extend & Euler & Parameter Estimation ex-ey)
syms Length real
syms ex ey ez real
syms exDummy eyDummy real
physicalParam = {m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4,rotor_r, mL, cableL, exDummy, eyDummy, ez};
e3=[0;0;1];
e1=[1;0;0];
dol  = cross(-pT,u1*ERb0*e3)/(m*Length); % ケーブル角加速度
dpT  = cross(ol,pT); % 機体から見たケーブル上の単位長さの位置の速度
ddpT = cross(dol,pT)+cross(ol,dpT); % 単位長さの位置の加速度
ddpl  = [0;0;-gravity]+(dot(pT,u1*ERb0*e3)-m*Length*dot(dpT,dpT))*pT/(m+mL); % 牽引物体の加速度
ddp  = ddpl-Length*ddpT;
dob = inv(Ib)*cross(-ob,Ib*ob)+inv(Ib)*[u2;u3;u4]+inv(Ib)*cross(ERb0*[ex;ey;-ez],-mL*(ddpl+[0;0;gravity]));
dq   = EL'*ob/2;
x=[p;er;dp;ob;pl;dpl;pT;ol;ex;ey];%ここが違う
f=[dp;der;ddp;dob;dpl;ddpl;dpT;dol;0;0];
U = [u1;u2;u3;u4];
Fl= subs(f,U,[0;0;0;0]);
Gl =  [subs(subs(f,[u2;u3;u4],[0;0;0]),u1,1)-Fl, subs(subs(f,[u1;u3;u4],[0;0;0]),u2,1)-Fl, subs(subs(f,[u2;u1;u4],[0;0;0]),u3,1)-Fl, subs(subs(f,[u2;u3;u1],[0;0;0]),u4,1)-Fl];    
simplify(f - (Fl+Gl*U))
% matlabFunction(f,'file','euler_with_load_model_parameter_estimation_exey','vars',{x U cell2sym(physicalParam)},'outputs',{'dx'});

%% Local functions
function m = Mtake(mat,m,n)
    m = mat(m,n);
end
