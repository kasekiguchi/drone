function [ref] = Case_study_trajectory(X0, te)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

% s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
% y_offset = 5;
% r = 0.1;
% 
% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;

%%
% geta = 0.14;
% x = 0.1;
% y = 0;
% z = 1;

%% circle
% x = cos(t) -1;
% y = sin(t);
% z = 1;
%%
% x = 1/(1+exp(-t + te/2));
% y = 0;
% z = 1;

%% landing
% x = 0;
% y = 0;
% z = -1/(1+exp(-t + 5)) + 1;

%%
% x = 0;
% y = 2;
% z = 1;

%%
% x = 30*(exp(-0.8*t)-1);
% y = 10*(exp(-0.7*t)-1);
% z = -20*(exp(-0.6*t)-1);

%%
te = 10; % 何秒で移動するか
% a = 0.25;
x = 0;
% y = 1/(1+exp(a*(-t + te/2))); % ゆるやかに移動するようにしたい
z = 1;
% x = 1/(1+exp(-t + te/2));
y = 1/(1+exp(-t + te/2));

Trajectory = [x,y,z]
ref=@(t)[x;y;z;0];
end

