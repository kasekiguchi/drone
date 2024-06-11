function ref = gen_ref_for_HL_Cooperative_Load(xdt)
syms t real
%xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;R0d],[3,3,3,3,3,3,9]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表す回転行列
% o0d, do0d ：牽引物の角速度・角加速度

%3偕微分
x0d=xdt(t);
dx0d =diff(x0d,t);
d2x0d =diff(dx0d,t);
d3x0d =diff(d2x0d,t);
d4x0d =diff(d3x0d,t);
d5x0d =diff(d4x0d,t);

norm_dxd = sqrt(dx0d(1:2)'*dx0d(1:2));%dxdはz方向を0にしているのでノルムはx,y方向で作成!!!!!!!!!!
if norm_dxd == 0 || dx0d(1) == 0
    R0d = eye(3);
else
    r0x = [dx0d(1);dx0d(2);0] / norm_dxd;
    % r0x = % [dxd(1),dxd(2),0]'/norm(dxd);%norm(dxd)でabsが出現し，do0dでt=0の時にNaNになる．
    r0z = [0;0;1];%z
    r0y = cross(r0z,r0x);%y
    R0d = [r0x,r0y,r0z];%理想的or目標とするペイロードの姿勢を表す回転行列
end
%     norm_dxd = sqrt(dxd'*dxd);%手動でnorm(dxd)
%     r0x = dxd / norm_dxd;
%     e1 = [1;0;0];
%     cos = e1'*r0x;
%     sin = sqrt(1 - cos^2);
%     n = cross(e1,dxd);
%     hat_n = Skew(n);
%     R0d = ones(3) + sin*hat_n + (1 - cos)*hat_n^2;
dR0d = diff(R0d,t);%回転行列の時間微分，目標速度

o0d = Vee(R0d'*dR0d);%理想的or目標とするペイロード角速度
do0d = diff(o0d,t);%理想的or目標とするペイロード角加速度
ref = matlabFunction([x0d;dx0d;d2x0d;d3x0d;d4x0d;d5x0d;o0d;do0d;reshape(R0d,[],1)],'vars',t);
end