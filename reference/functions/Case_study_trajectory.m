function [ref] = Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0{1}(1);
y_0 = X0{1}(2);
z_0 = X0{1}(3);

s = X0{2}; % s = 2 → period = 4*pi (12 sec)ハート1周
y_offset = 5;
r = 0.1;
% 
% x = x_0+sin(t/s);%r*16*sin(t/s)^3;
% y = y_0+cos(t/s);%r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;
x = sin(t/2);
y = cos(t/2);
z = z_0;

ref=@(t)[x;y;z;0];
end

