function dX = WheelChair_model(x,u,param)
    u(1) = u(1)*param.K;
    dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)];
end
