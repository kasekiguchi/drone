function dX = vehicle_velocity_omega_input_model(x,u,param)
    u = param.K * u;
    dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)-0.011];
%     dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)-0.011]; %偏差を入れる
end