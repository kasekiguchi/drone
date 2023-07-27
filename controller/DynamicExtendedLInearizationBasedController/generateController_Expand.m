%% Define the nonlinear physical model of a quadrotor
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 T1 dT1 real
syms u u1 u2 u3 u4 ddT1 T2 T3 T4  real
syms m Lx Ly lx ly jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 real
%% Controller design
clc
syms xd1(t) xd2(t) xd3(t) xd4(t) v1(t)
syms t real
xd = [xd1(t),xd2(t),xd3(t),xd4(t)]; % reference を後で決める時はこっち
%% 
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
ddp	= [ddp1;ddp2;ddp3];             % Accelaletion
q	= [  q0;  q1;  q2;  q3];        % Quaternion
ob	= [  o1;  o2;  o3];             % Angular velocity
x = [q;p;dp;ob;T1;dT1];
physicalParam = [m, Lx, Ly, lx, ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
g = G(x,physicalParam);
fep= Fep(x,physicalParam) ;
gep = Gep(x,physicalParam) ;
% dxep = fep + gep*[ddT;u2;u3;u4];
%% Define virtual output: h1 h2, h3, h4
h1 = p3 - xd(3);
h2 = p1 - xd(1);
h3 = p2 - xd(2);
[~,~,yaw] = Quat2Eul(q);
h4 = yaw - xd(4);
%% **************************************** % %
% clc
dh1 = LieD(h1,fep,x)+diff(h1,t);
dh2 = LieD(h2,fep,x)+diff(h2,t);
dh3 = LieD(h3,fep,x)+diff(h3,t);
dh4 = LieD(h4,fep,x)+diff(h4,t);
ddh1 = LieD(dh1,fep,x)+diff(dh1,t);
ddh2 = LieD(dh2,fep,x)+diff(dh2,t);
ddh3 = LieD(dh3,fep,x)+diff(dh3,t);
dddh1 = LieD(ddh1,fep,x)+diff(ddh1,t);
dddh2 = LieD(ddh2,fep,x)+diff(ddh2,t);
dddh3 = LieD(ddh3,fep,x)+diff(ddh3,t);
% % For check
	% [LieD(h1,gep,x),LieD(h2,gep,x),LieD(h3,gep,x)]
	% simplify([LieD(dh1,gep,x),LieD(dh2,gep,x),LieD(dh3,gep,x)])
	% simplify([LieD(ddh1,gep,x),LieD(ddh2,gep,x),LieD(ddh3,gep,x)])
	% [LieD(h1,gep,x),LieD(h2,gep,x),LieD(h3,gep,x),LieD(h4,gep,x)]
	% simplify([LieD(dh1,gep,x),LieD(dh2,gep,x),LieD(dh3,gep,x)])
	% simplify([LieD(ddh1,gep,x),LieD(ddh2,gep,x),LieD(ddh3,gep,x)])
%% Derive controller
alpha = [LieD(dddh1,fep,x)+diff(dddh1,t);LieD(dddh2,fep,x)+diff(dddh2,t); LieD(dddh3,fep,x)+diff(dddh3,t); LieD(dh4,fep,x)+diff(dh4,t)];
beta = [LieD(dddh1,gep,x);LieD(dddh2,gep,x); LieD(dddh3,gep,x); LieD(dh4,gep,x)];
syms v1 v2 v3 v4
Uep = inv(beta)*(-alpha+[v1;v2;v3;v4]);  % v2を後で設計する時はこっち
V1234 = alpha+beta*Uep;
%% Initialize xd as an unspecified function of t
% % If regenerate Uf, Us or Xd functions, evaluate this section.
    xd = [xd1(t),xd2(t),xd3(t),xd4(t)];
    dxd = diff(xd,t);
    ddxd = diff(xd,t,2);
    dddxd = diff(xd,t,3);
    ddddxd = diff(xd,t,4);
%% Set variables for output functions
    syms Xd1 Xd2 Xd3 Xd4 dXd1 dXd2 dXd3 dXd4 ddXd1 ddXd2 ddXd3 ddXd4 dddXd1 dddXd2 dddXd3 dddXd4 ddddXd1 ddddXd2 ddddXd3 ddddXd4 real
    syms V1 V2 V3 V4 dV1 ddV1 dddV1 real
    XD = {Xd1 Xd2 Xd3 Xd4 dXd1 dXd2 dXd3 dXd4 ddXd1 ddXd2 ddXd3 ddXd4 dddXd1 dddXd2 dddXd3 dddXd4 ddddXd1 ddddXd2 ddddXd3 ddddXd4};
    XDf = fliplr(XD);
    % V1v = {V1 dV1 ddV1 dddV1};
    % V1vf = fliplr(V1v);
    xdRef = fliplr([xd dxd ddxd dddxd ddddxd]);
    % vInput1 = fliplr([v1(t) diff(v1(t),t) diff(v1(t),t,2) diff(v1(t),t,3)]);
%% Make functions of z
% % If either model, virtual output or parameters is changed, then evaluate this section.
    disp("Start: make functions of virtual states.");
    matlabFunction(subs([h1;dh1;ddh1;dddh1], xdRef, XDf),'file','Zep1.m','vars',{x cell2sym(XD) physicalParam},'outputs',{'cZep1'});
    matlabFunction(subs([h2;dh2;ddh2;dddh2], xdRef, XDf),'file','Zep2.m','vars',{x cell2sym(XD) physicalParam},'outputs',{'cZep2'});
    matlabFunction(subs([h3;dh3;ddh3;dddh3], xdRef, XDf),'file','Zep3.m','vars',{x cell2sym(XD) physicalParam},'outputs',{'cZep3'});
    matlabFunction(subs([h4;dh4], xdRef, XDf),'file','Zep4.m','vars',{x cell2sym(XD) physicalParam},'outputs',{'cZep4'});

%% Make functions of virtual inputs
clc
    disp("Start: make functions of virtual inputs.");
    clear dt
    syms f11 f12 f13 f14 f21 f22 f23 f24 f31 f32 f33 f34 f41 f42 dt k real
    F1 = [f11 f12 f13 f14];
    F2 = [f21 f22 f23 f24];
    F3 = [f31 f32 f33 f34];
    F4 = [f41 f42];
%% Make functions of actual inputs taking t, x, xd, v1 and v2 as arguments
% % If either model, virtual output or parameters is changed, then evaluate this section. It'll take few minutes.
matlabFunction(subs(Uep, [xdRef v1(t) v2(t) v3(t) v4(t)], [XDf V1 V2 V3 V4]),'file','Uep.m','vars',{x cell2sym(XD) [V1;V2;V3;V4] physicalParam},'outputs',{'Uep'});
%% Local functions
function pd = pdiff(flist, vars)
% % flistをvarsで微分したもののシンボリック配列を返す？
    flist = flist(:);
    vars = vars(:);
%    pd = arrayfun(@(x) diff(flist(1), x), vars)';
    pdiff_tmp = @(flist, vars) arrayfun(@(func) arrayfun(@(x) diff(func, x), vars)',flist,'UniformOutput',false);
    pd = cell2sym(pdiff_tmp(flist,vars));
end
function dh = LieD(h,f,x)
    x = x(:);
    dh = pdiff(h,x)*f;
end
function [eul,th,psi] = Quat2Eul(q,varargin)
% % phi...roll, th...pitch, psi...yaw
    switch nargin
        case 1
            q0 = q(1);
            q1 = q(2);
            q2 = q(3);
            q3 = q(4);
        case 4
            q0 = q;
            q1 = varargin{1};
            q2 = varargin{2};
            q3 = varargin{3};
    end
	phi = atan2((2*(q0*q1 + q2*q3)),(q0^2 - q1^2 - q2^2 + q3^2));
	th  = asin(2*(q0*q2 - q1*q3));
	psi = atan2((2*(q0*q3 + q1*q2)),(q0^2 + q1^2 - q2^2 - q3^2));
	switch  nargout
        case 1
		eul = [phi, th, psi];
        case 3
		eul = phi;
	end
end