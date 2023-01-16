function [ref] = Komatsu_study_trajectory(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
% xg = X(1); %目標値
% yg = X(2);
% zg = X(3);
% T = X(4);   % 目標到達までの時間 T=10

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

%% circle
% x = cos(t/2);
% y = sin(t/2);

%%
% x = cos(t)+sin(t)^2;
% y = sin(t)+2*sin(t);
% z = 1;

%% Liner
x = (t/2)^2;
y = 0;
z = 1.0;

%% hovering
% x = 0;
% y = 0;
% z = 1;

%% star
% x = 5*cos(2*t/3) + 2*cos(t)-7;
% y = -5*sin(2*t/3) + 2*sin(t);
% z = 1.0;

%% landing
% T = 10;  % Time
% rz0 = 1; % start
% rz = 0.05; % target
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;
% z = 1.0;

%%
ref=@(t)[x;y;z;0];  % xyz yaw
end

