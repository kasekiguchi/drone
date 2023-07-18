function [loss,gradients1,gradients2] = modelLoss(net1,net2,x,dx)
%MODELLOSS モデル損失
%   教師データは学習データと同一
%   net1：Φ(phi)
%   net2：α(alpha)
%   x：学習データ(x)
%   dx：学習データ(dx)

xi = forward(net1,x); % 2*99*28 dlarray
y_alpha = forward(net2,xi); % 1*99*28 dlarray

% 1：状態数，2：ステップ数，3：本数
s = size(x);

% for i = 1:variation
%     for j = 1:snap
%         XI = xi(:,j,i);
%         AL = y_alpha(:,j,i);
%         v1 = XI(2) + XI(1) * (1 - XI(2)^2);
%         v2 = - XI(1);
%         v = [v1;v2];
%         DXI = AL .* v;
%         dxi(:,j,i) = DXI;
%     end
% end

% dxi = calcDXI(xi,y_alpha);
%-------------------------------
for i = 1:s(3)
    for j = 1:s(2)
        v1 = xi(2,j,i) + xi(1,j,i) .* (1 - xi(2,j,i)^2);
        v2 = - xi(1,j,i);
        v = [v1;v2];
        dxi(:,j,i) = y_alpha(:,j,i) .* v;
    end
end

% dxi = dlarray(dxi,'CBT');
%-------------------------------

% w1 = net1.Learnables.Value{1,1};
% b1 = net1.Learnables.Value{2,1};
% w2 = net1.Learnables.Value{3,1};
% b2 = net1.Learnables.Value{4,1};
% w3 = net1.Learnables.Value{5,1};
% b3 = net1.Learnables.Value{6,1};

% xp = x;
% DX = xi;

% for i = 1:variation
%     for j = 1:snap
%         x1 = xp(1,j,i);
%         x2 = xp(2,j,i);
%         X1 = double(extractdata(x1));
%         X2 = double(extractdata(x2));
%         X = [X1;X2];
%         DP = dphidx(X,w1,w2,w3,b1,b2,b3);
%         DX(:,j,i) = DP \ dxi(:,j,i);
%     end
% end

% y_dx = dlarray(DX,'CBT'); % double → dlarray
% y_dx = DX;

% y_dx = calcYDX(net1,x,dxi);
%-------------------------------
w1 = net1.Learnables.Value{1,1};
b1 = net1.Learnables.Value{2,1};
w2 = net1.Learnables.Value{3,1};
b2 = net1.Learnables.Value{4,1};
w3 = net1.Learnables.Value{5,1};
b3 = net1.Learnables.Value{6,1};

for i = 1:s(3)
    for j = 1:s(2)
        X = [x(1,j,i);x(2,j,i)];
        out1 = asinh(w1 .* X + b1);
        out2 = asinh(w2 .* out1 + b2);
        out3 = asinh(w3 .* out2 + b3);
        a = out3(1,1);
        b = out3(1,2);
        c = out3(2,1);
        d = out3(2,2);
        de = a * d - b * c;
        A = [d -b;-c a];
        inverse = (1/de) * A;
        % y_dx(:,j,i) = inverse .* dxi(:,j,i);
        y_dx(1,j,i) = inverse(1,1)*dxi(1,1,1) + inverse(1,2)*dxi(2,1,1);
        y_dx(2,j,i) = inverse(2,1)*dxi(1,1,1) + inverse(2,2)*dxi(2,1,1);
        if isnan(y_dx(:,j,i))
            y_dx(:,j,i) = 0;
        end
    end
end

y_dx = dlarray(y_dx,'CBT');
%-------------------------------

% 損失
loss = l2loss(y_dx,dx);
% loss = l2loss(y_dx,dx,DataFormat='CBT');
% loss = dlarray(4.56); % トレースされていないため不可

[gradients1,gradients2] = dlgradient(loss,net1.Learnables,net2.Learnables);

gradients1.Value{1,1}
gradients2.Value{1,1}

end

