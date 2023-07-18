function [loss,gradients1,gradients2] = modelLoss(net1,net2,x,dx)
%MODELLOSS モデル損失
%   教師データは学習データと同一
%   net1：Φ(phi)
%   net2：α(alpha)
%   x：学習データ(x)
%   dx：学習データ(dx)

% Y_xi = forward(net_xi,X); % xi1,xi2
% Y_alpha = forward(net_alpha,Y_xi);
% xi_dot = Y_alpha * [Y_xi(2) + Y_xi(1)*(1-Y_xi(2)^2);-Y_xi(1)];
% 
%---------------------------------matlabFunction
% phi = calcPhi(net_xi.w,net_xi.b); % 関数
% phi_dot = diffPhi(phi); % 偏微分
% x_dot = (phi_dot)^-1 * xi_dot;
%---------------------------------

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


% syms... ~ DP=subs... → 関数化
% syms X1 X2
% X = [X1;X2];
% p = asinh(w3*asinh(w2*asinh(w1*X+b1)+b2)+b3);
% dp11 = diff(p(1),X1);
% dp12 = diff(p(1),X2);
% dp21 = diff(p(2),X1);
% dp22 = diff(p(2),X2);
% dp = [dp11 dp12;dp21 dp22];
% y_dx = (dp^-1) * dxi;
DX = zeros(s(1),s(2),s(3));
% for i = 1:variation
%     for j = 1:snap
%         DP = subs(dp,[X1 X2],[x(1,j,i) x(2,j,i)]);
%         DX(:,j,i) = DP \ dxi(:,j,i);
%     end
% end

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
y_dx2 = forward(net1,y_dx);

yy = forward(net1,dx);
yy2 = forward(net1,y_dx);
yyy = forward(net2,dx);
yyy2 = forward(net2,y_dx);

% 損失
loss = l2loss(y_dx,dx);
loss2 = l2loss(xi,x);
% 
a = forward(net2,dx);
at = dlarray(ones(1,99,28));
loss3 = l2loss(a,at);

% x→phi→xi→alpha→a
% これは動く
b = forward(net1,x);
b1 = double(extractdata(b));
b2 = dlarray(2*b1,'CBT');
bb = 2*forward(net2,b2);
loss4 = l2loss(b,x);
loss5 = l2loss(bb,at);

% x→phi→xi→alpha→a ver.2
% ここまで(6/28)
b = forward(net1,x);
b1 = double(extractdata(b));
b2 = dlarray(2*b1,'CBT');
bb = 2*forward(net2,b2);
t = dlarray(zeros(2,99,28));
loss9 = l2loss(b,x);
loss10 = l2loss(bb,at);

%
y_dx2 = forward(net1,y_dx);
loss6 = l2loss(y_dx2,dx);

% x → phi → xi → alpha → a 通し
% layers = [
%     sequenceInputLayer(2)
%     fullyConnectedLayer(2,'Name','Hidden1')
%     functionLayer(@(X) asinh(X),Name='asinh1')
%     fullyConnectedLayer(2,'Name','Hidden2')
%     functionLayer(@(X) asinh(X),Name='asinh2')
%     fullyConnectedLayer(2,'Name','Hidden3')
%     functionLayer(@(X) asinh(X),Name='asinh3')
%     fullyConnectedLayer(2,'Name','Internal')
%     leakyReluLayer(0.01,'Name','Leaky ReLU')
%     fullyConnectedLayer(7,'Name','Hidden')
%     sigmoidLayer('Name','Sigmoid')
%     fullyConnectedLayer(1,'Name','Output')
%     ];
% net = dlnetwork(layers);
% xx = forward(net,x);
% loss7 = l2loss(xx,y_alpha);

loss11 = l2loss(y_dx2,dx);

% dlfevalをさらに使う
% dlfevalの入れ子はサポートされていない
% [loss8,gradients1,gradients2] = dlfeval(@modelLoss2,net1,net2,dx,y_dx);


% 学習可能パラメータを一つにまとめて引数にする
% tab1 = net1.Learnables;
% tab2 = net2.Learnables;
% tab = [tab1;tab2];

% 学習可能パラメーターについての損失の勾配
% gradients2 = dlgradient(loss,net1.Learnables);
% gradients1 = dlgradient(loss4,net1.Learnables);

% [gradients1,gradients2] = dlgradient(loss,net1.Learnables,net2.Learnables);

% [gradients1,gradients2] = dlgradient(loss,tab,net2.Learnables);
% [gradients1,gradients2] = dlgradient(loss2,net1.Learnables,net2.Learnables);
% gradients2 = dlgradient(loss5,net2.Learnables);
% gradients1 = dlgradient(loss,tab);
% gradients2 = dlgradient(loss3,net1.Learnables);


% [gradients1,gradients2] = dlgradient(loss7,net1.Learnables,net2.Learnables);
% gradients1 = dlgradient(loss7,net.Learnables);
% gradients2 = 0;
[gradients1,gradients2] = dlgradient(loss11,net1.Learnables,net2.Learnables);

% gradients1.Value{1,1}
% gradients2.Value{1,1}
% RetainData,EnableHigherDerivatives → ×


end

