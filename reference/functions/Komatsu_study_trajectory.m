function [ref] = Komatsu_study_trajectory(X)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
xg = X(1); %目標値
yg = X(2);
zg = X(3);
T = X(4);   % 目標到達までの時間
r = xg;  % 目標値
r0 = 0; % 現在地

a = -2/T^3 * (r-r0);
b = 3/T^2 * (r-r0);

x = a*(t-10)^3+b*(t-10)^2 ; % 目標値関数
y = yg;
z = zg;

ref=@(t)[x;y;z;0];  % xyz yaw
end

