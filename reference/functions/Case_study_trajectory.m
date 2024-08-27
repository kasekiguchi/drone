function [ref] = Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

s = 4; 
r = 1.0;

x = x_0+r*sin(2*pi*t/s)^0.5;
y = y_0+r*cos(2*pi*t/s)^0.5;
z = z_0;

ref=@(t)[x;y;z;0];
end

