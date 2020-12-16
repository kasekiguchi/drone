function dX = WheelChair_AAlpha_model(x,u,param)
    u(1) = param.K * u(1);
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));x(5);u(1);u(2)];
end
