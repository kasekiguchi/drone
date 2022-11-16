function dX = vehicle_velocity_omega_input_model(x,u,param)
    u = param.K * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end