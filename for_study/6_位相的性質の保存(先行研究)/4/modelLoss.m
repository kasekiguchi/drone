function [loss,gradients,state] = modelLoss(net,X,T)
% モデル損失関数

% Forward data through network.
[Y,state] = forward(net,X);

% 損失
loss = l2loss(Y,T);

% 学習可能パラメーターについての損失の勾配
gradients = dlgradient(loss,net.Learnables);

end

