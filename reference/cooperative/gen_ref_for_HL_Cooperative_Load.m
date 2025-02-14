function [ref,rotms] = gen_ref_for_HL_Cooperative_Load(xdt)
syms t real
%xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;R0d],[3,3,3,3,3,3,9]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表す回転行列
% o0d, do0d ：牽引物の角速度・角加速度

%位置
    %5偕微分まで
    xd      = xdt.pYaw;
    dxd     = diff(xd,t);
    d2xd    = diff(dxd,t);
    d3xd    = diff(d2xd,t);
    d4xd    = diff(d3xd,t);
    d5xd    = diff(d4xd,t);
    ref     = matlabFunction([xd;dxd;d2xd;d3xd;d4xd;d5xd],'vars',t);
%回転
    %角度の5階微分まで
    q       = xdt.q;
    dq      = diff(q,t);
    d2q     = diff(dq,t);
    d3q     = diff(d2q,t);
    d4q     = diff(d3q,t);
    d5q     = diff(d4q,t);
    %角度の微分の歪対称行列
    dqh     = Skew(dq);
    d2qh    = Skew(d2q);
    d3qh    = Skew(d3q);
    d4qh    = Skew(d4q);
    d5qh    = Skew(d5q);
    %回転行列
    Rx      = [1 0 0; 0 cos(q(1)) -sin(q(1)); 0 sin(q(1)) cos(q(1))];
    Ry      = [cos(q(2)) 0 sin(q(2)); 0 1 0; -sin(q(2)) 0 cos(q(2))];
    Rz      = [cos(q(3)) -sin(q(3)) 0; sin(q(3)) cos(q(3)) 0; 0 0 1];
    R       = Rx*Ry*Rz;
    %回転行列微分
    dR      = R*dqh;
    d2R     = dR*dqh + R*d2qh;%1,1
    d3R     = d2R*dqh + 2*dR*d2qh + R*d3qh;%1,2,1
    d4R     = d3R*dqh + 3*d2R*d2qh + 3*dR*d3qh + R*d4qh;%1,,3,3,1
    d5R     = d4R*dqh + 4*d3R*d2qh + 6*d2R*d3qh + 4*dR*d4qh + R*d5qh;%1,4,6,4,1
    zero13  = zeros(1,3);

rotms = matlabFunction(q,[R;zero13;dR;zero13;d2R;zero13;d3R;zero13;d4R;zero13;d5R;zero13],'vars',t);%アルゴリズム上各行列ごとに0を入れている

%論文通り=======================================================
% %xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
% %必要パラメーター
% % [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;R0d],[3,3,3,3,3,3,9]
% % x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% % r0d : 牽引物の姿勢を表す回転行列
% % o0d, do0d ：牽引物の角速度・角加速度
% 
% %6偕微分
% x0d=xdt(t);
% dx0d =diff(x0d,t);
% d2x0d =diff(dx0d,t);
% d3x0d =diff(d2x0d,t);
% d4x0d =diff(d3x0d,t);
% d5x0d =diff(d4x0d,t);
% d6x0d =diff(d5x0d,t);
% x0p
% norm_dxd = sqrt(dx0d(1:2)'*dx0d(1:2));%dxdはz方向を0にしているのでノルムはx,y方向で作成!!!!!!!!!!
% if norm_dxd == 0 || dx0d(1) == 0
%     R0d = eye(3);
% else
%     r0x = [dx0d(1);dx0d(2);0] / norm_dxd;
%     % r0x = % [dxd(1),dxd(2),0]'/norm(dxd);%norm(dxd)でabsが出現し，do0dでt=0の時にNaNになる．
%     r0z = [0;0;1];%z
%     r0y = cross(r0z,r0x);%y
%     R0d = [r0x,r0y,r0z];%理想的or目標とするペイロードの姿勢を表す回転行列
% end
% %     norm_dxd = sqrt(dxd'*dxd);%手動でnorm(dxd)
% %     r0x = dxd / norm_dxd;
% %     e1 = [1;0;0];
% %     cos = e1'*r0x;
% %     sin = sqrt(1 - cos^2);
% %     n = cross(e1,dxd);
% %     hat_n = Skew(n);
% %     R0d = ones(3) + sin*hat_n + (1 - cos)*hat_n^2;
% dR0d = diff(R0d,t);%回転行列の時間微分，目標速度
% 
% o0d = Vee(R0d'*dR0d);%理想的or目標とするペイロード角速度
% do0d = diff(o0d,t);%理想的or目標とするペイロード角加速度
% ref = matlabFunction([x0d;dx0d;d2x0d;d3x0d;d4x0d;d5x0d;d6x0d;o0d;do0d;reshape(R0d,[],1)],'vars',t);
end