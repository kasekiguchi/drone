function dX = vehicle_velocity_omega_input_model(x,u,param)
    u = param.K * u;
%     dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)];
    dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)-0.01]; %偏差を入れる
end