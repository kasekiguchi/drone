function [ref] = line_ref(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

% x = x_0;
x = x_0+0.2*t;

y = y_0;
z = z_0;

ref=@(t)[x;y;z;0];%謎x,y,z is function of t.
end

