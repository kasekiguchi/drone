function [ref] = Komatsu_study_trajectory(X)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
xg = X(1); %目標値
yg = X(2);
zg = X(3);
T = X(4);   % 目標到達までの時間
rx = xg;  % 目標値
rz = zg;
rx0 = 0; % 現在地
rz0 = 1;

a = -2/T^3 * (rx-rx0);
b = 3/T^2 * (rx-rx0);
x = a*(t-10)^3+b*(t-10)^2 ; % 目標値関数
y = a*(t-10)^3+b*(t-10)^2 ;
a = -2/T^3 * (rz-rz0);
b = 3/T^2 * (rz-rz0);
z = a*(t-10)^3+b*(t-10)^2+rz0 ;


% fprintf("xyz: %f %f %f\n", x, y, z);
ref=@(t)[x;y;z;0];  % xyz yaw
end

