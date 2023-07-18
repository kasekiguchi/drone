function [loss,g1,g2] = modelLoss3(n1,n2,ydx,dx,x)

y = forward(n1,x);
yy = forward(n2,y);

loss = l2loss(ydx,dx);

% 学習可能パラメーターについての損失の勾配
[g1,g2] = dlgradient(loss,n1.Learnables,n2.Learnables);

g1.Value{1,1}
g2.Value{1,1}


end

