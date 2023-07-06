function [ref] = Komatsu_study_trajectory(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
% xg = X(1); %目標値
% yg = X(2);
% zg = X(3);
% T = X(4);   % 目標到達までの時間 T=10

% x = 1;
% y = 0;
% z = 1;

%% takeoff
% T = 10;
% rz0 = 0;
% rz = 1; %rz = 1;
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;
% x = 0;
% y = 0;
% yaw = 0;

%%
% x = 0 * t;
% y = 0 * t;
% z = 0 * t;
%% 
% x = 0;
% y = 0;
% z = 1/2 * sin(t/2);

%% circle
x = cos(t/2);
y = sin(t/2);
z = 1.0;
yaw = 0;

%%
% x = cos(t)+sin(t)^2;
% y = sin(t)+2*sin(t);
% z = 1;

%% Liner
% x = t;
% y = 0;
% z = 1.0;
% yaw = 0.1;

%% Vertical vibration
% x = 0;
% y = 0;
% z = 1/2 * sin(2*t)+1;
% z = 1/2 * sin(2*t)+1 + 1/10 * cos(t);
% z = 1/2 * sin(2*t)+1 - 1/10 + 1/5*cos(3*t)+sin(t)+1;

%% hovering
% x = 0;
% y = 0;
% z = 1;
% yaw = 0;

%% star
% x = 5*cos(2*t/3) + 2*cos(t)-7;
% y = -5*sin(2*t/3) + 2*sin(t);
% z = 1.0;

%% landing
% T = 13;  % Time
% rz0 = 1; % start
% rz = 0.05; % target
% StartT = -3;
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t-StartT)^3+b*(t-StartT)^2+rz0;
% % z = 1.0;
% x = 6/100 * t -3/10;
% y = 0;

%% syamen これ！！
% phaseT = 2;
% zt = 0.5; % 減衰係数 小さくすれば傾き増加
% xt = 0.3; % x方向速度増大
% z = 2*exp(-(t-phaseT)/zt)-0.1;
% x = -exp(-(t-phaseT)/xt);
% y = 0;
%% slope P2P
% x = -0.2;
% y = 0;
% z = 0.1;

%% landing liner
% x = 6/100*t - 2.7;
% y = 0;
% z = -10/3*t + 10;

% x = 6/10*t;
% y = 0;
% % z = 0.5;
% z = (t-1)^2 + 0.05;

%% Star
% a = 0.81;
% b = 0.14;
% c = 1.0;
% n = 5;
% xmax = sqrt(-log(2*exp(-a^2)-1)/b^2);
% r0 = 0.1*xmax;
% T = 10*pi;
% r = r0 + sqrt(-log(2*exp(-a^2) - exp(-b^2*xmax^2*sin((2*pi*t/T-pi/2)*n/2)^2)))/c;
% x = 0.7*r*sin(2*pi*t/T);
% y = 0.7*r*cos(2*pi*t/T);
% z = 1;
%%
ref=@(t)[x;y;z;yaw];  % xyz yaw
end
