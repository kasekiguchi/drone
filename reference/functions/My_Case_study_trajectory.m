function [ref] = My_Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

x = x_0+0.15*t*0;
y = y_0+0;
z = z_0-0.0;

%PtoP
% x = x_0;
% y = y_0;
% z = z_0;

% r=1;
% T=10;
% x = x_0+r*cos(2*pi*t/T);
% y = y_0+r*sin(2*pi*t/T);
% z = z_0;%+0.4*sin(2*pi*t/T);

%-------------------------------------------------------------------
%アステロイド,ダイヤ
% a=1;
% x=a*cos(2*pi*t/T)^3 ;
% y=a*sin(2*pi*t/T)^3 ;
% z=z_0;

%リサージュ,八の字
% A=1;B=1;a=1;b=2;d=0;
% x=A*sin(a*2*pi*t/T+d);
% y=B*sin(b*2*pi*t/T);
% z=z_0;

%バラ曲線　いい感じ
% a=2;b=1;
% x=1.5*sin((a*2*pi*t/T)/b)*cos(2*pi*t/T);
% y=1.5*sin((a*2*pi*t/T)/b)*sin(2*pi*t/T);
% z=z_0;

% ref=@(t,x0,y0,z0)[x;y;z;0];%謎x,y,z are function of t.

ref=@(t)[x;y;z;0];
end
