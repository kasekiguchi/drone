function [ref] = Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
% x_0 = X0(1);
% y_0 = X0(2);
% z_0 = X0(3);

% %% takeoff
% T = 10;
% rz0 = 0;
% rz = 1; %rz = 1;
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;
% x = t-10;
% y = 0;

% s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
% y_offset = 5;
% r = 0.1;
% 
% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;

% 円旋回
% s = 8;
% x = sin(2*pi*t/10);
% y = cos(2*pi*t/10);
% z = 1;

x = 0.5*sin(2*pi*t/10);
y = 0;
z = 0.5*cos(2*pi*t/10);

%八の字
% x = sin(2*t/8);
% y = sin(t/8);
% z = 1;

% s = 8;
% x = t/s;
% y = x^2;
% z = 1;

%八の字拡張版
% s = 8;
% x = sin(2*t/s);
% y = cos(3*t/s);
% z = 1;

% 直線
% x = t/8;
% y = 0;
% z = 1;
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;

%離陸
% x = t/4;
% y = t/4; 
% z = t/4;

%% 
%landing
% T = 10;  % Time
% rz0 = 0.01; % start
% rz = 1; % target
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;

ref=@(t)[x;y;z;0];
end

