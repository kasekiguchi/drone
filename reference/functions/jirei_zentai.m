function [ref] = jirei_zentai(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

T=10;
x = x_0+1.5*cos(2*pi*t/T);
y = y_0+1.5*sin(2*pi*t/T);
z = z_0;
ref=@(t)[x;y;z;0];%謎x,y,z are function of t.

end

