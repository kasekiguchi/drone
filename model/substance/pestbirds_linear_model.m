function X = pestbirds_linear_model(x,u,param)
    u(1) = u(1)*param.K;
    X = [u(1)*cos(x(3));u(1)*sin(x(3));u(3)];
end
