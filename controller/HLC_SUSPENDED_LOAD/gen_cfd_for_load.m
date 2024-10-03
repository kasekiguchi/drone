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
%このモデルでは無理，推力の一階微分が入力になるシステムに拡張すればできる
e3 = [0;0;1];
h0 = -cos(C) - pT'*e3;

h1 = LieD(h0,fl,x) + LieD(h0,glu,x) + a(1)*h0;
hEnd = LieD(h1,fl,x) + LieD(h1,glu,x) + a(2)*h1;%hEnd>=0
%% 線形化後に対して制約
clear h
syms C real
syms a [6,1] real
syms xQ yQ yL real
syms xL [6,1] real
syms v real
f = [xL(2:end);v];
% h = num2sym(zeros(7,1));
h(1) = C^2 - (xQ-xL(1))^2 -(yQ-yL)^2;%X^2+Y^2<C^2
for i = 2:6
    h(i,1) = LieD(h(i-1),f,xL) + a(i-1)*h(i-1);
end
i = i+1;
A = LieD(h(i-1),[0*f(1:5);1],xL);
B = LieD(h(i-1),[f(1:5);0],xL) + a(i-1)*h(i-1);
% Au+B>=0を-Au <= B;に変換
% matlabFunction(-A,B,'file','conic_cfb_HL.m','vars',{xL,yL,xQ yQ,a,C},'outputs',{'A','B'});
%% 制約の形に変換
% Au <= B
A = simplify(LieD(h1,gl,x));
B = simplify(hEnd - A*u);
simplify(subs(hEnd,u,zeros(4,1))-B)

matlabFunction(-A,B,'file','conic_cfb.m','vars',{x,physicalParam,a,C},'outputs',{'A','B'});
%% 線形化後に対して制約xiは目標軌道との誤差
clear h A B 
syms C real
syms a [6,1] real
syms t real
syms xL(t) yL(t)
syms xQ(t) yQ(t) 
syms sxQ syQ real
syms refx [7,1] real
syms refy [7,1] real
syms xix [6,1] real
syms xiy [6,1] real
syms vx vy real

% f = [xi(2:end);v];
% h = num2sym(zeros(7,1));
h(1) = C^2 - (xQ-xL)^2 -(yQ-yL)^2;%X^2+Y^2<C^2
for i = 2:7
    h(i,1) = diff(h(i-1),t) + a(i-1)*h(i-1);
end
subsXL = flip([xix;vx]);
subsYL = flip([xiy;vy]);
subsXQ = flip([sxQ - refx(1);-refx(2:end)]);
subsYQ = flip([syQ - refy(1);-refy(2:end)]);
dxL = [diff(xL,t,6);diff(xL,t,5);diff(xL,t,4);diff(xL,t,3);diff(xL,t,2);diff(xL,t,1);xL];
dyL = [diff(yL,t,6);diff(yL,t,5);diff(yL,t,4);diff(yL,t,3);diff(yL,t,2);diff(yL,t,1);yL];
dxQ = [diff(xQ,t,6);diff(xQ,t,5);diff(xQ,t,4);diff(xQ,t,3);diff(xQ,t,2);diff(xQ,t,1);xQ];
dyQ = [diff(yQ,t,6);diff(yQ,t,5);diff(yQ,t,4);diff(yQ,t,3);diff(yQ,t,2);diff(yQ,t,1);yQ];
d7h = subs(h(7),[dxL,dyL,dxQ,dyQ],[subsXL,subsYL,subsXQ,subsYQ]);
d7hexp = expand(d7h);
d7hState = subs(d7hexp,[vx, vy],[0,0]);
d7hInput = d7hexp - d7hState;
d7hInputCoVx = factor(subs(d7hInput,vy,0),vx);
d7hInputCoVy = factor(subs(d7hInput,vx,0),vy);
% Au+B>=0を-Au <= B;に変換
A = -[d7hInputCoVx(1), d7hInputCoVx(1)];
B = d7hState;
matlabFunction(A,B,'file','conic_cfb_HL.m','vars',{refx, refy, xix, xiy, sxQ, syQ, a,C},'outputs',{'A','B'});

%% 線形化後に対して制約xiは目標軌道との誤差
clear h A B 
syms C real
syms a [6,1] real
syms xQ yQ refx refy real
syms xix [6,1] real
syms xiy [6,1] real
syms vx vy real

%xQrel,yQrel目標値からの機体の位置，xix,xiy目標値からの牽引物のx,y位置
xi = [xix;xiy];
f = [xix(2:end);0;xiy(2:end);0];
zero61 = zeros(6,1);
zero51 = zeros(5,1);
g = reshape([zero51;1;zero61;zero61;zero51;1],12,[]);
v = [vx;vy];

xQrel = xQ-refx;
yQrel = yQ-refy;
h(1) = C^2 - (xQrel-xix(1))^2 -(yQrel-xiy(1))^2;%X^2+Y^2<C^2
for i = 2:6
    h(i,1) = LieD(h(i-1),f,xi) + LieD(h(i-1),g,xi)*v + a(i-1)*h(i-1);
end
i = i+1;
A = -LieD(h(i-1),g,xi);
B = LieD(h(i-1),f,xi) + a(i-1)*h(i-1);

% Au+B>=0を-Au <= B;に変換
matlabFunction(A,B,'file','conic_cfb_HL2.m','vars',{refx, refy, xix, xiy, xQ, yQ, a,C},'outputs',{'A','B'});

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