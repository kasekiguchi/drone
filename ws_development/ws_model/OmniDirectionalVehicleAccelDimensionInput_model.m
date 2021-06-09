function dX = OmniDirectionalVehicleAccelDimensionInput_model(x,u,param)
    u(1) = param.K * u(1);
    A = [0 0 0 1 0 0 
           0 0 0 0 1 0 
           0 0 0 0 0 1
           0 0 0 0 0 0
           0 0 0 0 0 0 
           0 0 0 0 0 0];
    B = [0 0 0
           0 0 0 
           0 0 0
           1 0 0
           0 1 0
           0 0 1];
    dX = A*x + B*u';
end
