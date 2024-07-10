%CBF for load
% h0 = -cos(C) - pT*e3 >= 0
%%
clear
syms p1 p2 p3 dp1 dp2 dp3 ddp1 ddp2 ddp3 q0 q1 q2 q3 o1 o2 o3 real
syms f M1 M2 M3 real
syms m Lx Ly lx ly  jx jy jz gravity km1 km2 km3 km4 k1 k2 k3 k4 real
syms mL l Length cableL rotor_r real % LengthとcableLは同じ意味,lは機体の長さ正方形を仮定
syms pl1 pl2 pl3 dpl1 dpl2 dpl3 ol1 ol2 ol3 real
syms pT1 pT2 pT3 real
%% 
p	= [  p1;  p2;  p3];             % Position　：xb : 進行方向，zb ：ホバリング時に上向き
dp	= [ dp1; dp2; dp3];             % Velocity
ddp	= [ddp1;ddp2;ddp3];             % Accelaletion
q	= [  q0;  q1;  q2;  q3];        % Quaternion
ob	= [  o1;  o2;  o3];             % Angular velocity
pl  = [ pl1; pl2; pl3];             % Load position
dpl = [dpl1;dpl2;dpl3];             % Load velocity
ol  = [ ol1; ol2; ol3];             % Load angular velocity
pT  = [ pT1; pT2; pT3];             % String position
x=[q;ob;pl;dpl;pT;ol];
physicalParam = [m, Lx, Ly lx ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4, rotor_r, Length, mL, cableL];
fl = FL(x,physicalParam);
gl = GL(x,physicalParam);
u = [f;M1;M2;M3];
glu = gl*u;

dX = fl + gl*u;
physicalParam = [m, Lx, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4, mL, cableL];
%% 円錐型
syms C real
syms a [2,1] real

e3 = [0;0;1];
h0 = -cos(C) - pT'*e3;

h1 = LieD(h0,fl,x) + LieD(h0,glu,x) + a(1)*h0;
hEnd = LieD(h1,fl,x) + LieD(h1,glu,x) + a(2)*h1;%hEnd>=0
%% 制約の形に変換
% Au <= B
A = simplify(LieD(h1,gl,x));
B = simplify(hEnd - A*u);
simplify(subs(hEnd,u,zeros(4,1))-B)

matlabFunction(-A,B,'file','conic_cfb.m','vars',{x,physicalParam,a,C},'outputs',{'A','B'});
%%
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