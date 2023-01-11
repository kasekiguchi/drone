function dX = vehicle_velocity_input_model(x,u,param)
    u = param.K * u;
    dX = [(u(1)+u(2))*cos(x(3));(u(1)+u(2))*sin(x(3));u(2)-u(1)];
% %     dX = [((u(1)*cos(x(3)))+(u(2)*cos(x(3))));((u(1)*sin(x(3)))+(u(2)*sin(x(3))));(u(2)-u(1))*13.25];
end