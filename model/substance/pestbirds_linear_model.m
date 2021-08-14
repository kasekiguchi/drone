function X = pestbirds_linear_model(x,u,param)
    u(1) = u(1)*param.K;
%     [roll pitch yaw] = f(q)
    X = [u(1)*cos(u(3));u(1)*sin(u(3));u(2);u(4);u(5);u(6);u(7)];
%     [q0 q1 q2 q3] = f(X'(roll pitch yaw ))
%     X = X'[x y z]+[q0 q1 q2 q3]
%     A = [1 1;1 1]
%     b = [0;1]
%     u = [u1]
%     x = [x1;x2]
%     X = A*x+bu
%     X = [x1+x2;x1+x2+u1]
end
