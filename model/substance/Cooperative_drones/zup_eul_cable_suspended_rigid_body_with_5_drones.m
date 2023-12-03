function dX = zup_eul_cable_suspended_rigid_body_with_5_drones(x,u,P)
ddX = zup_eul_ddx0do0_5(x,u,P,inv(zup_eul_Addx0do0_5(x,u,P)));
dX = zup_eul_tmp_cable_suspended_rigid_body_with_5_drones(x,u,P,ddX);
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
