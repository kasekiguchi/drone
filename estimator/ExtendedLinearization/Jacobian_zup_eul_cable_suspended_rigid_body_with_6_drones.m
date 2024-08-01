function Aapp = Jacobian_zup_eul_cable_suspended_rigid_body_with_6_drones(x,p)
param = [p.g;p.m0;p.J0;reshape(p.rho,[],1);reshape(p.li,[],1);p.mi';reshape(p.Ji,[],1)]';   
u0 = zeros(24,1);
    R0 = eul2rotm(x(4:6)');
    Ri = eul2rotm(reshape(x(49:66),3,[])');
    iA = inv(zup_eul_Addx0do0_6(x,R0,u0,param));
    ddX = zup_eul_ddx0do0_6(x,R0,Ri,u0,param,iA);
    % ddX = zeros(6,1);
    Aapp = zup_eul_jacobian_6(x,R0,Ri,param,ddX);
    Aapp(7:12,:)= iA\zup_eul_dAddx0do0_6(x,R0,Ri,param,ddX);%謎
end
