function y_dx = calcYDX(net,x,dxi)
%YDX この関数の概要をここに記述
%   net：phi(x → xi)

w1 = net.Learnables.Value{1,1};
b1 = net.Learnables.Value{2,1};
w2 = net.Learnables.Value{3,1};
b2 = net.Learnables.Value{4,1};
w3 = net.Learnables.Value{5,1};
b3 = net.Learnables.Value{6,1};

% 1：状態数，2：ステップ数，3：本数
s = size(x);

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

% y_dx = dlarray(y_dx,'CBT');

end

