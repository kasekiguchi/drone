function X = pestbirds_linear_model(x,u,param)
% 害鳥の動作入力算出
    X = param.K*[u(1);u(2);u(3)];
end
