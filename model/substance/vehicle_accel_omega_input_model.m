function dX = vehicle_accel_omega_input_model(x,u,param)
    u = param.get("K",param.plant_or_model) * u;
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1) - param.get("D",param.plant_or_model)*x(4)];
end