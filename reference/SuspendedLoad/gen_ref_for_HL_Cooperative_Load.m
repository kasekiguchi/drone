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
  % norm_dxd = sqrt(dxd(1)^2+dxd(2)^2+dxd(3)^2);%手動でnorm(dxd)
  norm_dxd = sqrt(dxd'*dxd);%手動でnorm(dxd)
  r0x = [dxd(1),dxd(2),0]'/norm_dxd;
  % r0x = [dxd(1),dxd(2),0]'/norm(dxd);%norm(dxd)でabsが出現し，do0dでt=0の時にNaNになる
end
r0z = [0;0;1];%z
r0y = Skew(r0z)*r0x;%y
R0d = [r0x,r0y,r0z];%理想的or目標とするペイロードの姿勢を表す回転行列
dR0d = diff(R0d,t);%目標速度

o0d = Vee(R0d'*dR0d);%理想的or目標とするペイロード角速度
do0d = diff(o0d,t);%理想的or目標とするペイロード角加速度
ref = matlabFunction([xd;dxd;ddxd;dddxd;o0d;do0d;reshape(R0d,[],1)],'vars',t);
end