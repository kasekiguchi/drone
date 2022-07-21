function [ref] = line_ref(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t x0 y0 z0real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

% x = x_0;
% x = x_0+0.1*t;
% y = y_0;
% z = z_0;

%PtoP
x = x_0;
% x = x_0+0.2*sin(2*pi/10*t);
y = y_0;
z = z_0;

ref=@(t)[x;y;z;0];%謎x,y,z are function of t.

% x = x0+0.2*t;
% y = y0;
% z = z0;
% ref=@(t,x0,y0,z0)[x;y;z;0];%謎x,y,z are function of t.
end

