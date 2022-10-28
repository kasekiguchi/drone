function [ref] = Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
y_offset = 5;
r = 0.1;

x = x_0+r*16*sin(t/s)^3;
y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
z = z_0;

T=10;
x = x_0+1.5*cos(2*pi*t/T);
y = y_0+1.5*sin(2*pi*t/T);%r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
z = z_0;

%%%桜サイエンス
%no1
% x = x_0 + cos(t/s);
% y = y_0 + sin(2*t/s);
% z = 1 + 0.5 * sin(pi*x_0);

% %no2
% s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
% y_offset = 5;
% r = 0.1;
% 
% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;
% 
% %no3
% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0 + 0.2 * sign(sin(4*t/s));%やばいやつ
% 
% %no4
% x = x_0+cos(t/s);
% y = y_0;
% z = z_0+0.5*sin(t/s);
% 
% %no5
% x = x_0+cos(t/s);
% y = y_0+sin(2*t/s);
% z = z_0+sin(t/s)*cos(t/s);
% 
% %no6
% x = x_0+cos(t/s);
% y = y_0+sin(2*t/s);
% z = z_0+0.25*cos(t/s);
% 
% %no7
x = x_0+cos(t/s);
y = y_0+sin(2*t/s);
z = 0.75*z_0+0.25*cos(6*t/s);
%%%

%             if time.t < 10
%                 x = 0;
%                 y = 0;
%                 z = 1;
%             elseif time.t < 15 && time.t > 10
%                 x = 1.5;
%                 y = 0;
%                 z = 1;
%             elseif time.t < 20 && time.t 15
%                 x = 1.5;
%                 y = 1.5;
%                 z = 1;
%             elseif time.t < 25 && time.t >20
%                 x = -1.5;
%                 y = 1.5;
%                 z = 1;
%             elseif time.t < 30 && time.t > 25
%                 x = -1.5;
%                 y = -1.5;
%                 z = 1;
%             elseif time.t < 35 && time.t > 30
%                 x = 1.5;
%                 y = -1.5;
%                 z = 1;
%             else
%                 x = 1.5;
%                 y = 0;
%                 z = 1;
%             end

ref=@(t)[x;y;z;0];
end

