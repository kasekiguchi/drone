function [loss,gradients1,gradients2] = modelLoss2(net1,net2,x,dx)
%MODELLOSS モデル損失
%   教師データは学習データと同一
%   net1：Φ(phi)
%   net2：α(alpha)
%   x：学習データ(x)
%   dx：学習データ(dx)

xi = forward(net1,x); % 2*99*28 dlarray
% y_alpha = forward(net2,xi);
[y_alpha,y_xi] = forward(net2,xi,Outputs=["PreOutput" "skipNN"]);
preloss = l2loss(y_xi,xi);

% 1：状態数，2：スナップショット
s = size(x);

for i = 1:s(2)
    v1 = xi(2,i) + xi(1,i) .* (1 - xi(2,i)^2);
    v2 = - xi(1,i);
    v = [v1;v2];
    dxi(:,i) = y_alpha(:,i) .* v;
end
% for i = 1:s(2)
%     v1 = y_xi(2,i) + y_xi(1,i) .* (1 - y_xi(2,i)^2);
%     v2 = - y_xi(1,i);
%     v = [v1;v2];
%     dxi(:,i) = y_alpha(:,i) .* v;
% end

% dxi = dlarray(dxi,'CBT');

w1 = net1.Learnables.Value{1,1};
b1 = net1.Learnables.Value{2,1};
w2 = net1.Learnables.Value{3,1};
b2 = net1.Learnables.Value{4,1};
w3 = net1.Learnables.Value{5,1};
b3 = net1.Learnables.Value{6,1};


for i = 1:s(2)
    X = [x(1,i);x(2,i)];
    out1 = asinh(w1 .* X + b1);
    out2 = asinh(w2 .* out1 + b2);
    out3 = asinh(w3 .* out2 + b3);
    a = out3(1,1);
    b = out3(1,2);
    c = out3(2,1);
    d = out3(2,2);
    de = a .* d - b .* c;
    A = [d -b;-c a];
    inverse = (1/de) * A;
    % y_dx(:,j,i) = inverse .* dxi(:,j,i);
    y_dx(1,i) = inverse(1,1)*dxi(1,1) + inverse(1,2)*dxi(2,1);
    y_dx(2,i) = inverse(2,1)*dxi(1,1) + inverse(2,2)*dxi(2,1);
    % if isnan(y_dx(:,i))
    %     y_dx(:,i) = 0;
    % end
end


y_dx = dlarray(y_dx,'CT');
% y_dx = dlarray(y_dx);

% 損失
loss = l2loss(y_dx,dx);
% loss = l2loss(y_dx,dx,DataFormat='CT');

[gradients1,gradients2] = dlgradient(loss,net1.Learnables,net2.Learnables);
[gradients21,gradients22] = dlgradient(preloss,net1.Learnables,net2.Learnables);

gradients1.Value{1,1}
gradients2.Value{1,1}
gradients21.Value{1,1}
gradients22.Value{1,1}

end



