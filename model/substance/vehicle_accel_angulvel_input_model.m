function dX = vehicle_accel_angulvel_input_model(x,u,param)
% param = K
    u = param * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end