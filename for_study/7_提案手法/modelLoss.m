function [loss1,loss2,gradients1,gradients2] = modelLoss(net1,net2,x,u,xi,v,v1diff,Ax,Bx,Ay,By,Az,Bz)
%MODELLOSS モデル損失
%   あ

D1 = [x;x(9,:);x(12,:)];
D2 = xi;
% D3はステップ進めたものを使用する
% D3 = [xi;v;v1diff(2,:);v1diff(3,:)];
% D4 = [x;u];

xik = forward(net1,D1); % D1->NN1->D2

dt = 0.01; % 刻み幅

loss1 = l2loss(xik,D2); % NN1のloss

% dzk = A * zk + B * vk
for i = 1:length(xik)
    xikvec_x = [xik(3,i);xik(4,i);xik(5,i);xik(6,i)]; % xi_x
    xikvec_y = [xik(7,i);xik(8,i);xik(9,i);xik(10,i)]; % xi_y
    xikvec_z = [xik(1,i);xik(2,i)]; % xi_z
    xikvec_yaw = [xik(11,i);xik(12,i)]; % xi_yaw
    Azk_x = mattimesvec(Ax,xikvec_x);
    Azk_y = mattimesvec(Ay,xikvec_y);
    Azk_z = mattimesvec(Az,xikvec_z);
    Azk_yaw = mattimesvec(Az,xikvec_yaw);
    vkvec = v(:,i);
    Bvk_x = mattimesvec(Bx,vkvec);
    Bvk_y = mattimesvec(By,vkvec);
    Bvk_z = Bz .* vkvec(1,1);
    Bvk_yaw = Bz .* vkvec(1,1);
    dxik_x(:,i) = Azk_x + Bvk_x;
    dxik_y(:,i) = Azk_y + Bvk_y;
    dxik_z(:,i) = Azk_z + Bvk_z;
    dxik_yaw(:,i) = Azk_yaw + Bvk_yaw;
end

% zkk = zk + dzk * dt
xik_x = [xik(3,:);xik(4,:);xik(5,:);xik(6,:)];
xik_y = [xik(7,:);xik(8,:);xik(9,:);xik(10,:)];
xik_z = [xik(1,:);xik(2,:)];
xik_yaw = [xik(11,:);xik(12,:)];
xikk_x = xik_x + dxik_x .* dt;
xikk_y = xik_y + dxik_y .* dt;
xikk_z = xik_z + dxik_z .* dt;
xikk_yaw = xik_yaw + dxik_yaw .* dt;

% 1ステップ進めた状態でlossを取る場合 旧ver.
% zkt = zk(:,2:end);
% zkt(9,:) = [];
% zkt(11,:) = [];
% zkk = [zkk_x(1,:);zkk_y(1,:);zkk_z(1,:);
%     zkk_x(2,:);zkk_y(2,:);zkk_z(2,:);
%     zkk_x(3,:);zkk_y(3,:);
%     zkk_x(4,:);zkk_y(4,:)];
% zkk(:,end) = [];
% loss1 = l2loss(zkk,zkt);

xikk = [xikk_x(1,:);xikk_y(1,:);xikk_z(1,:);
    xikk_x(2,:);xikk_y(2,:);xikk_z(2,:);
    xikk_x(3,:);xikk_y(3,:);
    xikk_x(4,:);xikk_y(4,:)];
xikk = [xikk_z(1,:);xikk_z(2,:);
    xikk_x(1,:);xikk_x(2,:);xikk_x(3,:);xikk_x(4,:);
    xikk_y(1,:);xikk_y(2,:);xikk_y(3,:);xikk_y(4,:);
    xikk_yaw(1,:);xikk_yaw(2,:)];
xikk(:,end) = []; % 最終列の削除(元の2～endになる)
vkk = v(:,2:end);
dv1 = v1diff(2,2:end);
ddv1 = v1diff(3,2:end);
D3 = [xikk;vkk;dv1;ddv1];
D4 = [x;u];
D4(:,1) = [];

xkk = forward(net2,D3); % xi->NN2->x
loss2 = l2loss(xkk,D4);

gradients1 = dlgradient(loss1,net1.Learnables);
gradients2 = dlgradient(loss2,net2.Learnables);

end

