function X = pestbirds_linear_model(x,u,param)
% 害鳥の動作入力算出
    u(1) = u(1)*param.K;
    X = [u(1)*cos(u(3));u(1)*sin(u(3));u(2);u(4);u(5);u(6);u(7)];
end
