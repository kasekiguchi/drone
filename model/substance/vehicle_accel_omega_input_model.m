function dX = vehicle_accel_omega_input_model(x,u,param)
    u = param.K * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1) - param.D*x(4)];
end