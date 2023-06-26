function Aapp = Jacobian_zup_eul_cable_suspended_rigid_body_with_6_drones(x,P)
iA = inv(zup_eul_Addx0do0_6(x,zeros(24,1),P));
ddX = zup_eul_ddx0do0_6(x,zeros(24,1),P,iA);
Aapp = zup_eul_jacobian_6(x,P,ddX);
Aapp(7:12,:)= [1;-1;-1;1;-1;-1].*iA*zup_eul_dAddx0do0_6(x,P,ddX);
end
