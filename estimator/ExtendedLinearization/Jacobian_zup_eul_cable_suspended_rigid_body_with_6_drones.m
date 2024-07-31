function Aapp = Jacobian_zup_eul_cable_suspended_rigid_body_with_6_drones(x,P)
iA = inv(zup_eul_Addx0do0_6(x,R0,u,P));
ddX = zup_eul_ddx0do0_6(x,R0,Ri,u,P,iA);
Aapp = zup_eul_jacobian_6(x,R0,Ri,P,ddX);
Aapp(7:12,:)= iA\zup_eul_dAddx0do0_6(x,R0,Ri,P,ddX);%謎
end
