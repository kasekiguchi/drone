function [ref] = Case_study_trajectory2(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

s = 1; % s = 2 → period = 4*pi (12 sec)ハート1周
y_offset = 5;
r = 0.1;

x = x_0+sin(t/s);
y = y_0+cos(t/s);
z = z_0;

ref=@(t)[x;y;z;0];
end

