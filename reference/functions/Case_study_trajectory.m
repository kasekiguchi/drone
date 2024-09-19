function [ref] = Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

% s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
% y_offset = 5;
% r = 0.1;

% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;

x = x_0;
y = y_0;
z = z_0;
T=9;
x = 1.0*sin(2*pi*t/T);
y = 1.0*cos(2*pi*t/T);
z = z_0;
% x=1;
% y=0;


ref=@(t)[x;y;z;0];
end

