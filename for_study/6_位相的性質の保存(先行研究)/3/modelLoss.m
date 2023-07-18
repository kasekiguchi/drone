function [loss,gradients,state] = modelLoss(net,X,T)
% モデル損失関数

% Forward data through network.
[Y,state] = forward(net,X);



% Y_xi = forward(net_xi,X); % xi1,xi2
% Y_alpha = forward(net_alpha,Y_xi);
% xi_dot = Y_alpha * [Y_xi(2) + Y_xi(1)*(1-Y_xi(2)^2);-Y_xi(1)];
% 
%---------------------------------matlabFunction
% phi = calcPhi(net_xi.w,net_xi.b); % 関数
% phi_dot = diffPhi(phi); % 偏微分
% x_dot = (phi_dot)^-1 * xi_dot;
%---------------------------------

% 損失
loss = l2loss(Y,T);
% loss = l2loss(x_dot,T); % T:x_dotの教師

% 学習可能パラメーターについての損失の勾配
gradients = dlgradient(loss,net.Learnables);

end

