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

r0x = [dxd(1),dxd(2),0]'/norm(dxd);
r0z = [0;0;1];
r0y = Skew(r0z)*r0x;
R0d = [r0x,r0y,r0z];
dR0d = diff(R0d,t);
o0d = simplify(Vee(R0d'*dR0d));
do0d = simplify(diff(o0d,t));
% R0d2quat = R2q(R0d);
w_q = simplify(sqrt(R0d(1,1)+R0d(2,2)+R0d(3,3)+1)/2);
xp_q = simplify(sqrt(R0d(1,1)-R0d(2,2)-R0d(3,3)+1)/2);
yp_q = simplify(sqrt(-R0d(1,1)+R0d(2,2)-R0d(3,3)+1)/2);
zp_q = simplify(sqrt(-R0d(1,1)-R0d(2,2)+R0d(3,3)+1)/2);

[Ele,Id]=max([w_q,xp_q,yp_q,zp_q]); % max element
Ele = 4*Ele;

qd = [w_q;(R0d(3,2)-R0d(2,3))/Ele;(R0d(1,3)-R0d(3,1))/Ele;(R0d(2,1)-R0d(1,2))/Ele];

% o0d = [0;0;0];
% do0d = [0;0;0];
% r0d = [1;0;0;0];


%Xd.state=double(subs([xd,dxd,ddxd,dddxd,ddddxd],t,tt));
%Xd.param = param;
ref = matlabFunction([xd;dxd;ddxd;dddxd;o0d;do0d;qd],'vars',t);
end