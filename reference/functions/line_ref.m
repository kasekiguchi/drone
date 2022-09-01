function [ref] = line_ref(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

x = x_0+0.2*t;
y = y_0;
z = z_0;

%PtoP
% x = x_0+0.0;
% y = y_0;
% z = 0;
r=1;
T=6;
x = x_0+r*cos(2*pi*t/T);
% y = y_0+r*sin(2*pi*t/T);
% z = z_0;%+0.4*sin(2*pi*t/(T/2));

ref=@(t)[x;y;z;0];%謎x,y,z are function of t.


% ref=@(t,x0,y0,z0)[x;y;z;0];%謎x,y,z are function of t.
end

