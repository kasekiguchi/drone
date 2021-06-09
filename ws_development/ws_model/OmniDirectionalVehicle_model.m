function dX = OmniDirectionalVehicle_model(x,u,param)
    u(1) = param.K * u(1);
    dX = zeros(3,3)*x + [1 0 0;0 1 0;0 0 1]*u';
end
