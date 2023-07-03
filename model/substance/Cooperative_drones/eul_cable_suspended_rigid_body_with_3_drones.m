function dx = eul_cable_suspended_rigid_body_with_3_drones(x,u,P)
eui = reshape(x(31:39),3,[]);
r0 = Eul2Quat(x(4:6));
 ri = Eul2Quat(eui);
R0 = RodriguesQuaternion(r0);
Ri = RodriguesQuaternion(ri);
X = [x(1:3);r0;x(7:30);reshape(ri,[],1);x(40:end)];
ddX = ddx0do0_3(X,R0,Ri,u,P,inv(Addx0do0_3(X,R0,u,P)));
dX = tmp_cable_suspended_rigid_body_with_3_drones(X,R0,Ri,u,P,ddX);
deu0 = pinv(dQdEu(x(4:6)))*dX(4:7); dP = dQdEu(eui); dq = reshape(dX(32:43),4,[]);
deui = zeros(3,3);
 for i = 1:3
 deui(:,i)=pinv(dP(:,:,i))*dq(:,i);
dx = [dX(1:3);deu0;dX(8:31);reshape(deui,[],1);dX(44:end)];
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
