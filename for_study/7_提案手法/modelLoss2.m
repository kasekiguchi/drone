function [loss1,loss2,gradients1,gradients2] = modelLoss2(net1,net2,x,u,xi,v,v1diff,Axy,Bxy,Az,Bz)
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

% dxik = A * xik + B * vk
% xikk = xik + dxik * dt
xikk = dleuler(Axy,Az,xi,Bxy,Bz,v);

% zkk = zk + dzk * dt
% xik_x = [xik(3,:);xik(4,:);xik(5,:);xik(6,:)];
% xik_y = [xik(7,:);xik(8,:);xik(9,:);xik(10,:)];
% xik_z = [xik(1,:);xik(2,:)];
% xik_yaw = [xik(11,:);xik(12,:)];
% dxik_x = [dxi(3,:);dxi(4,:);dxi(5,:);dxi(6,:)];
% dxik_y = [dxi(7,:);dxi(8,:);dxi(9,:);dxi(10,:)];
% dxik_z = [dxi(1,:);dxi(2,:)];
% dxik_yaw = [dxi(11,:);dxi(12,:)];
% xikk_x = xik_x + dxik_x .* dt;
% xikk_y = xik_y + dxik_y .* dt;
% xikk_z = xik_z + dxik_z .* dt;
% xikk_yaw = xik_yaw + dxik_yaw .* dt;

% xikk = [xikk_z(1,:);xikk_z(2,:);
%     xikk_x(1,:);xikk_x(2,:);xikk_x(3,:);xikk_x(4,:);
%     xikk_y(1,:);xikk_y(2,:);xikk_y(3,:);xikk_y(4,:);
%     xikk_yaw(1,:);xikk_yaw(2,:)];

% xikk = [xikk_z;xikk_x;xikk_y;xikk_yaw];

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

