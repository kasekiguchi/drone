function dxdt = odefcn(t,x)
%SAMPLE_ODE この関数の概要をここに記述
%   詳細説明をここに記述


dxdt = zeros(2,1);
c = exp(-dot(x,x));
dxdt(1) = c * (x(2) + sin(x(1)) - 3*(x(1))^3);
dxdt(2) = c * (- x(1));


end



