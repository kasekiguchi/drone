function ref = gen_ref_for_HL_Cooperative_Load(xdt)
syms t real
%xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;R0d],[3,3,3,3,3,3,9]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表す回転行列
% o0d, do0d ：牽引物の角速度・角加速度

%3偕微分
xd=xdt(t);
dxd =diff(xd,t);
ddxd =diff(dxd,t);
dddxd =diff(ddxd,t);
if norm(dxd) == 0
  r0x = [1;0;0];%目標軌道がない場合[0.001;0;0]特異点阻止
else
  r0x = [dxd(1),dxd(2),0]'/norm(dxd);%(37)x
end
r0z = [0;0;1];%(37)z
r0y = Skew(r0z)*r0x;%(37)y
R0d = [r0x,r0y,r0z];%(37)
dR0d = diff(R0d,t);%目標速度

o0d = Vee(R0d'*dR0d);%(38)ペイロード角速度
do0d = simplify(diff(o0d,t));%(38)ペイロード角加速度

%Xd.state=double(subs([xd,dxd,ddxd,dddxd,ddddxd],t,tt));
%Xd.param = param;
%ref_func_name = "cooperative_drones_reference.m";
%matlabFunction([xd;dxd;ddxd;dddxd;o0d;do0d;reshape(R0d,[],1)],'file',ref_func_name,'vars',t);
%ref = str2func(ref_func_name);
ref = matlabFunction([xd;dxd;ddxd;dddxd;o0d;do0d;reshape(R0d,[],1)],'vars',t);
end