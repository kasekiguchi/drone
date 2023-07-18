function y_dx = modelLoss2(net1,net2,x)
%MODELLOSS モデル損失
%   教師データは学習データと同一
%   net1：Φ(phi)
%   net2：α(alpha)
%   x：学習データ(x)
%   dx：学習データ(dx)



xi = forward(net1,x); % 2*99*28 dlarray
y_alpha = forward(net2,xi); % 1*99*28 dlarray

%-----------------------------
% ここにdlarray → doubleの処理を書く
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
%-----------------------------
% v1 = xi(2) + xi(1) * (1 - xi(2)^2);
% v2 = - xi(1);
% v = [v1;v2];
% dxi = y_alpha .* v;

w1 = double(extractdata(net1.Learnables.Value{1,1}));
b1 = double(extractdata(net1.Learnables.Value{2,1}));
w2 = double(extractdata(net1.Learnables.Value{3,1}));
b2 = double(extractdata(net1.Learnables.Value{4,1}));
w3 = double(extractdata(net1.Learnables.Value{5,1}));
b3 = double(extractdata(net1.Learnables.Value{6,1}));



DX = zeros(s(1),s(2),s(3));


% x：dlarray → double
for i = 1:variation
    for j = 1:snap
        X1 = double(extractdata(x(1,j,i)));
        X2 = double(extractdata(x(2,j,i)));
        X = [X1;X2];
        DP = dphidx(X,w1,w2,w3,b1,b2,b3);
        DX(:,j,i) = DP \ dxi(:,j,i);
    end
end

y_dx = dlarray(DX,'CBT'); % double → dlarray








end

