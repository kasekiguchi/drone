function dXddX0 = zup_cable_suspended_rigid_body_with_6_drones(x,u,P)
R0 = RodriguesQuaternion(x(4:7));
Ri = RodriguesQuaternion(reshape(x(50:73),4,[]));
ddX0 = ddx0do0_6(x,R0,Ri,u,P,inv(Addx0do0_6(x,R0,u,P)));
dX = tmp_cable_suspended_rigid_body_with_6_drones(x,R0,Ri,u,P,ddX0);
dXddX0 = [dX;zeros(6,1)];
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
%ペイロードの加速度，角度
% ddX = [ddx0;do0]
