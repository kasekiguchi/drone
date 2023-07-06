function ref = gen_ref_for_HL_Cooperative_Load(xdt)
syms t real
%xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;r0d],[3,3,3,3,3,3,4]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表すクォータニオン
% o0d, do0d ：牽引物の角速度・角加速度

%3偕微分
xd=xdt(t);
dxd =diff(xd,t);
ddxd =diff(dxd,t);
dddxd =diff(ddxd,t);

o0d = [0;0;0];
do0d = [0;0;0];
r0d = [1;0;0;0];


%Xd.state=double(subs([xd,dxd,ddxd,dddxd,ddddxd],t,tt));
%Xd.param = param;
ref = matlabFunction([xd;dxd;ddxd;dddxd;o0d;do0d;r0d],'vars',t);
end