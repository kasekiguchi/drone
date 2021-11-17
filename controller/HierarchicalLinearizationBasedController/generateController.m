%% Define the nonlinear physical model of a quadrotor
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms u u1 u2 u3 u4 T1 T2 T3 T4 real
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
x = [q;p;dp;ob];
physicalParam = [m, Lx, Ly, lx, ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
f = F(x,physicalParam);
g = G(x,physicalParam);
%g= [g1 g2 g3 g4];
%% 1st layer
clc
% % Define virtual output: h1
h1 = p3 - xd(3);
q	= [  q0;  q1;  q2;  q3];        % Quaternion
% % **************************************** % %
% LieD(h1,g,x) % For check 
dh1 = LieD(h1,f,x)+diff(h1,t);
alpha1 = LieD(dh1,f,x)+diff(dh1,t);
beta1 = simplify(LieD(dh1,g,x));
H = [1/beta1(1),-beta1(2)/beta1(1),-beta1(3)/beta1(1),-beta1(4)/beta1(1); zeros(3,1),eye(3)];
syms e1 e2 real
He = [1/(beta1(1)+e1),-beta1(2)/(beta1(1)+e1),-beta1(3)/(beta1(1)+e1),-beta1(4)/(beta1(1)+e1); zeros(3,1),eye(3)];
% H = pinv(beta1);
% nH = null(H');


% syms v1(t) dv1(t) ddv1(t) dddv1(t) ddddv1(t)
% dv1(t) = diff(v1(t),t);
% ddv1(t) = diff(v1(t),t,2);
% dddv1(t) = diff(v1(t),t,3);
% ddddv1(t) = diff(v1(t),t,4);
% Qz = diag([1.0,1.0]);               % Weight of state
% Rz = 0.1;                           % Weight of input
% Nz = 0;
% Fz = lqr([0,1;0,0], [0;1], Qz, Rz, Nz);
 %v1 = -Fz * [h1;dh1]; % v1を事前に決めておく時はこっち
%% 2nd layer
syms v2 v3 v4
FG = simplify(f+g*H*[-alpha1+v1(t);u2;u3;u4]);	% v1を後で設計する時はこっち
g1 = simplify(MyCoeff(FG,[u2;u3;u4]));
f1 = subs(FG,[u2,u3,u4],[0,0,0]);
%simplify(FG-(f1+g1*[v2;v3;v4]))   % For check

% FG = simplify(f+g*(H*(-alpha1+v1(t))+nH*[v2;v3;v4]));	% v1を後で設計する時はこっち
% g1 = simplify(MyCoeff(FG,[v2;v3;v4]));
% f1 = subs(FG,[v2,v3,v4],[0,0,0]);

%%
% % Define virtual output: h2, h3, h4
h2 = p1 - xd(1);
h3 = p2 - xd(2);
[~,~,yaw] = Quat2Eul(q);
h4 = yaw - xd(4);
%h4 = 2*(q0*q3 + q1*q2) - xd(4); % これでは姿勢は変わらない
%% **************************************** % %
clc
dh2 = LieD(h2,f1,x)+diff(h2,t);
dh3 = LieD(h3,f1,x)+diff(h3,t);
dh4 = LieD(h4,f1,x)+diff(h4,t);
ddh2 = LieD(dh2,f1,x)+diff(dh2,t);
ddh3 = LieD(dh3,f1,x)+diff(dh3,t);
dddh2 = LieD(ddh2,f1,x)+diff(ddh2,t);
dddh3 = LieD(ddh3,f1,x)+diff(ddh3,t);
% % For check
% 	[LieD(h2,g1,x),LieD(h3,g1,x)]
% 	simplify([LieD(dh2,g1,x),LieD(dh3,g1,x)])
% 	simplify([LieD(ddh2,g1,x),LieD(ddh3,g1,x)])
% 	[LieD(h2,g1,x),LieD(h3,g1,x),LieD(h4,g1,x)]
% 	simplify([LieD(dh2,g1,x),LieD(dh3,g1,x)])
% 	simplify([LieD(ddh2,g1,x),LieD(ddh3,g1,x)])
%% 
% % Derive 2nd layer controller
alpha2 = [LieD(dddh2,f1,x)+diff(dddh2,t); LieD(dddh3,f1,x)+diff(dddh3,t); LieD(dh4,f1,x)+diff(dh4,t)];
beta2 = [LieD(dddh2,g1,x); LieD(dddh3,g1,x); LieD(dh4,g1,x)];
% Qxy = diag([1.0, 1.0, 0.1, 0.01]);	% Weight of state
% Rxy = 1.0;                          % Weight of input
% Nxy = 0;
% Fxy = lqr([0,1,0,0;0,0,1,0;0,0,0,1;0,0,0,0], [0;0;0;1], Qxy, Rxy, Nxy);
% Qr = diag([1.0, 1.0]);              % Weight of state
% Rr = 1;                             % Weight of input
% Nr = 0;
% Fr = lqr([0,1;0,0], [0;1], Qr, Rr, Nr);
% if flag.predefinedReference
%     v2 = [-F4*[h2;dh2;ddh2;dddh2]; -Fxy*[h3;dh3;ddh3;dddh3]; -Fr*[h4;dh4]];
%     U2 = inv(beta2)*(-alpha2+v2);   % v2 を事前に設計しておく時はこっち
% else
    syms v2(t) v3(t) v4(t)
    U2 = inv(beta2)*(-alpha2+[v2(t);v3(t);v4(t)]);  % v2を後で設計する時はこっち
    %U2 = beta2/(-alpha2+[v2(t);v3(t);v4(t)]);  % v2を後で設計する時はこっち
    U2e = (adjoint(beta2)/(det(beta2)+e2))*(-alpha2+[v2(t);v3(t);v4(t)]);  % v2を後で設計する時はこっち
%end
%% Initialize xd as an unspecified function of t
% % If regenerate Uf, Us or Xd functions, evaluate this section.
    xd = [xd1(t),xd2(t),xd3(t),xd4(t)];
    dxd = diff(xd,t);
    ddxd = diff(dxd,t);
    dddxd = diff(ddxd,t);
    ddddxd = diff(dddxd,t);
%% Set variables for output functions
    syms Xd1 Xd2 Xd3 Xd4 dXd1 dXd2 dXd3 dXd4 ddXd1 ddXd2 ddXd3 ddXd4 dddXd1 dddXd2 dddXd3 dddXd4 ddddXd1 ddddXd2 ddddXd3 ddddXd4 real
    syms V1 V2 V3 V4 dV1 ddV1 dddV1 real
    XD = {Xd1 Xd2 Xd3 Xd4 dXd1 dXd2 dXd3 dXd4 ddXd1 ddXd2 ddXd3 ddXd4 dddXd1 dddXd2 dddXd3 dddXd4 ddddXd1 ddddXd2 ddddXd3 ddddXd4};
    V1v = {V1 dV1 ddV1 dddV1};
    xdRef = [xd dxd ddxd dddxd ddddxd];
    vInput1 = [v1(t) diff(v1(t),t) diff(v1(t),t,2) diff(v1(t),t,3)];
%% Make functions of z
% % If either model, virtual output or parameters is changed, then evaluate this section.
    disp("Start: make functions of virtual states.");
    matlabFunction(subs([h1;dh1], [xdRef], [XD]),'file','Z1.m','vars',{x cell2sym(XD) physicalParam},'outputs',{'cZ1'});
    matlabFunction(subs([h2;dh2;ddh2;dddh2], [xdRef vInput1], [XD V1v]),'file','Z2.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'cZ2'});
    matlabFunction(subs([h3;dh3;ddh3;dddh3], [xdRef vInput1], [XD V1v]),'file','Z3.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'cZ3'});
    matlabFunction(subs([h4;dh4], [xdRef vInput1], [XD V1v]),'file','Z4.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'cZ4'});

%% Make functions of virtual inputs
clc
    disp("Start: make functions of virtual inputs.");
    clear dt
    syms f11 f12 f21 f22 f23 f24 f31 f32 f33 f34 f41 f42 dt k real
    F1 = [f11 f12];
    F2 = [f21 f22 f23 f24];
    F3 = [f31 f32 f33 f34];
    F4 = [f41 f42];
    A1=[0,1;0,0]-[0;1]*F1; % closed loop : continuous
    matlabFunction(subs([-F1*[h1;dh1],-F1*A1*[h1;dh1],-F1*A1*A1*[h1;dh1],-F1*A1*A1*A1*[h1;dh1]], [xdRef], [XD]),'file','Vf.m','vars',{x cell2sym(XD) physicalParam F1},'outputs',{'V1'});
    matlabFunction(subs([-F2*[h2;dh2;ddh2;dddh2],-F3*[h3;dh3;ddh3;dddh3],-F4*[h4;dh4]], [xdRef vInput1], [XD V1v]),'file','Vs.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam F2 F3 F4},'outputs',{'cV2'});
    A1 = expm([0,1;0,0]*dt)-int(expm([0,1;0,0]*(dt-k))*[0;1],k,[0,dt])*F1; % closed loop discrete
    matlabFunction(subs([-F1*[h1;dh1],-F1*A1*[h1;dh1],-F1*A1*A1*[h1;dh1],-F1*A1*A1*A1*[h1;dh1]], [xdRef], [XD]),'file','Vfd.m','vars',{dt x cell2sym(XD) physicalParam F1},'outputs',{'V1'});
    A2 = expm(diag([1,1,1],1)*dt)-int(expm(diag([1,1,1],1)*(dt-k))*[0;0;0;1],k,[0,dt])*F2; % closed loop discrete
    A3 = expm(diag([1,1,1],1)*dt)-int(expm(diag([1,1,1],1)*(dt-k))*[0;0;0;1],k,[0,dt])*F3; % closed loop discrete
    A4 = expm([0 1;0 0]*dt)-int(expm([0 1;0 0]*(dt-k))*[0;1],k,[0,dt])*F4; % closed loop discrete
    matlabFunction(subs([-F2*[h2;dh2;ddh2;dddh2],-F3*[h3;dh3;ddh3;dddh3],-F4*[h4;dh4]], [xdRef vInput1], [XD V1v]),'file','Vs.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam F2 F3 F4},'outputs',{'cV2'});
    
    % % For check
%     Vf(0,x0,Xd(0))
%     Vs(0,x0,Xd(0),Vf(0,x0,Xd(0)))
%% Make functions of actual inputs taking t, x, xd, v1 and v2 as arguments
% % If either model, virtual output or parameters is changed, then evaluate this section. It'll take few minutes.
% % Usage: u = Uf(...) + Us(...)
    matlabFunction(subs(H(:,1)*(-alpha1+v1(t)), [xdRef vInput1], [XD V1v]),'file','Uf.m','vars',{x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'U1'});
    matlabFunction(subs(H(:,2:4)*U2, [xdRef vInput1 v2(t) v3(t) v4(t)], [XD V1v [V2 V3 V4]]),'file','Us.m','vars',{x cell2sym(XD) cell2sym(V1v) [V2;V3;V4] physicalParam},'outputs',{'U2'});
    %matlabFunction(subs(He(:,1)*(-alpha1+v1(t)), [xdRef vInput1], [XD V1v]),'file','Ufe.m','vars',{t x cell2sym(XD) cell2sym(V1v) [physicalParam,e1,e2]},'outputs',{'cU1'});
    %matlabFunction(subs(He(:,2:4)*U2e, [xdRef vInput1 v2(t) v3(t) v4(t)], [XD V1v [V2 V3 V4]]),'file','Use.m','vars',{t x cell2sym(XD) cell2sym(V1v) [V2;V3;V4] [physicalParam,e1,e2]},'outputs',{'cU2'});
% % For check
%     Uf(0,x0,Xd(0),Vf(0,x0,Xd(0)))
%     Us(0,x0,Xd(0),Vf(0,x0,Xd(0)),Vs(0,x0,Xd(0),Vf(0,x0,Xd(0))))
% %%
% matlabFunction(subs(alpha1, [xdRef], [XD]),'file','alpha1.m','vars',{cell2sym(XD) physicalParam},'outputs',{'al1'});
% matlabFunction(subs(alpha2, [xdRef vInput1], [XD V1v]),'file','alpha2.m','vars',{t x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'al2'});
% %%
% matlabFunction(subs(beta2, [xdRef vInput1], [XD V1v]),'file','beta2.m','vars',{t x cell2sym(XD) cell2sym(V1v) physicalParam},'outputs',{'be2'});
% %%
% matlabFunction(subs(He, [xdRef vInput1], [XD V1v]),'file','He.m','vars',{t x cell2sym(XD) cell2sym(V1v) e1 physicalParam},'outputs',{'mat'});
% %%
% matlabFunction(beta1,'file','beta1.m','vars',{t x physicalParam},'outputs',{'beta1'});

%% Local functions
function tmp = DeleteCommentLine(fname)
% % DeleteCommentLine : Remove comments and blank lines in functions
% % % Load file
	fp = fopen(strcat(fname,'.m'),'r');
	str = textscan(fp,'%s','delimiter','\n');
	str = str{1};
	fclose(fp);
	tmp = length(str);
% % % Check comment line and blank line
	str = str(~strncmp(str,'%',1));
	str = str(~strncmp(str,'',1));
	tmp2 = length(str);
% % % Update file
	if (tmp~=tmp2) && (tmp2 ~= 0)
		fp = fopen(strcat(fname,'.m'),'w');
		cellfun(@(a) fprintf(fp,'%s\n',a),str,'UniformOutput',false);
		fclose(fp);
	end
end
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
function mat = MyCoeff(M,vars)
    vars = vars(:);
    mat = coder.nullcopy(sym(zeros(length(M),length(vars))));
    for i = 1:length(M)
        for j = 1:length(vars)
            mat(i,j) = subs(M(i)-subs(M(i),vars(j),0),vars(j),1);
        end
    end
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
function R=Rodrigues(u,th)
    u = u(:);
    u = u/norm(u);
    R=u*u'+cos(th)*(eye(3)-u*u')+sin(th)*Skew(u);
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
function R = RodriguesQuaternion(q)
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
