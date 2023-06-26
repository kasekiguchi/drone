function Aapp = Jacobian_zup_eul_cable_suspended_rigid_body_with_3_drones(x,P)
iA = inv(zup_eul_Addx0do0_3(x,zeros(12,1),P));
ddX = zup_eul_ddx0do0_3(x,zeros(12,1),P,iA);
Aapp = zup_eul_jacobian_3(x,P,ddX);
Aapp(7:12,:)= iA*zup_eul_dAddx0do0_3(x,P,ddX);
end
