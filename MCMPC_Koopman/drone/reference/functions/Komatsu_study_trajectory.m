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
% x = t-10;
% y = 0;


% %% circle
x = sin(2*pi*t/10);
y = cos(2*pi*t/10);
z = 1;

% x = 0;
% y = 1;
% z = 1;

% x = cos(t);
% y = sin(t);
% z = 1;

% x = 0;
% y = 0;
% z = 1;

% x = t/2;
% y = 0;
% z = 1;

% x = t;
% y = sin(t);
% z = 1;

% x = t - sin(t);
% y = 2*(1 - cos(t));
% z = 1;
%% landing
% T = 10;  % Time
% rz0 = 0.01; % start
% rz = 1; % target
% 
% a = -2/T^3 * (rz-rz0);
% b = 3/T^2 * (rz-rz0);
% z = a*(t)^3+b*(t)^2+rz0;

%%
ref=@(t)[x;y;z;0];  % xyz yaw
end

