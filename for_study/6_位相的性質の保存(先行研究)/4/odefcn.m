function dxdt = odefcn(t,x)
%ODEFCN 位相的性質の保存
%   対称モデル常微分方程式

dxdt = zeros(2,1);
c = exp(-dot(x,x));
dxdt(1) = c * (x(2) + sin(x(1)) - 3*(x(1))^3);
dxdt(2) = c * (- x(1));

end

