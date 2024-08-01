function dX = zup_eul_cable_suspended_rigid_body_with_6_drones(x,u,P)
% R0 = RodriguesQuaternion(Eul2Quat(x(4:6)));
% Ri = RodriguesQuaternion(reshape(Eul2Quat(x(49:66)),4,[]));
R0 = eul2rotm(x(4:6)');
Ri = eul2rotm(reshape(x(49:66),3,[])');
ddX = zup_eul_ddx0do0_6(x,R0,Ri,u,P,inv(zup_eul_Addx0do0_6(x,R0,u,P)));
dX = zup_eul_tmp_cable_suspended_rigid_body_with_6_drones(x,R0,Ri,u,P,ddX);
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
