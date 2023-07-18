function [loss,gradients1,gradients2] = modelLoss(net1,net2,x,dx)
%MODELLOSS モデル損失
%   教師データは学習データと同一
%   net1：Φ(phi)
%   net2：α(alpha)
%   x：学習データ(x)
%   dx：学習データ(dx)

xi = forward(net1,x); % 2*99*28 dlarray
y_alpha = forward(net2,xi); % 1*99*28 dlarray

s = size(xi);
variation = s(3); % 28種類
snap = s(2); % 99ステップ
dxi = zeros(s(1),s(2),s(3)); % dxi 事前割り当て
for i = 1:variation
    for j = 1:snap
        XI = xi(:,j,i);
        AL = y_alpha(:,j,i);
        v1 = XI(2) + XI(1) * (1 - XI(2)^2);
        v2 = - XI(1);
        v = [v1;v2];
        DXI = AL .* v;
        dxi(:,j,i) = DXI;
    end
end

w1p = net1.Learnables.Value{1,1};
b1p = net1.Learnables.Value{2,1};
w2p = net1.Learnables.Value{3,1};
b2p = net1.Learnables.Value{4,1};
w3p = net1.Learnables.Value{5,1};
b3p = net1.Learnables.Value{6,1};

w1 = double(extractdata(w1p));
b1 = double(extractdata(b1p));
w2 = double(extractdata(w2p));
b2 = double(extractdata(b2p));
w3 = double(extractdata(w3p));
b3 = double(extractdata(b3p));

xp = x;
DX = xi;

for i = 1:variation
    for j = 1:snap
        x1 = xp(1,j,i);
        x2 = xp(2,j,i);
        X1 = double(extractdata(x1));
        X2 = double(extractdata(x2));
        X = [X1;X2];
        DP = dphidx(X,w1,w2,w3,b1,b2,b3);
        DX(:,j,i) = DP \ dxi(:,j,i);
    end
end

% y_dx = dlarray(DX,'CBT'); % double → dlarray
y_dx = DX;

% 損失
loss = l2loss(y_dx,dx);

loss = l2loss(xi,x);

[gradients1,gradients2] = dlgradient(loss,net1.Learnables,net2.Learnables);

gradients1.Value{1,1}
gradients2.Value{1,1}

end

