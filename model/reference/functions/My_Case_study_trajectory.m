function [ref] = My_Case_study_trajectory(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

% x = x_0+0.15*t*0;
% y = y_0+0;
% z = z_0-0.0;

%PtoP
x = x_0;
y = y_0;
z = z_0;

T=10;
x=sin(2*pi*t/T);
y=cos(2*pi*t/T);
z=0.5;

% h = 0.3;
% k = 0.3;
% r = 1;
% T = 12;
% x= h + r*cos(2*pi*t/T);
% y= k + r*sin(2*pi*t/T);
% z=1.3;

% 
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

%メビウスの帯
% T = 12;r=0.5;
% x = (r*cos(2*pi*t/T)+1)*cos(2*2*pi*t/T);
% y = (r*cos(2*pi*t/T)+1)*sin(2*2*pi*t/T);
% z = z_0+r*sin(2*pi*t/T);

% 
% R1=1;
% N1=1;
% R2=1;
% N2=-2;
% S=0.5;
% x=R1*sin(N1*S*t)+R2*sin(N2*S*t);
% y=R1*cos(N1*S*t)+R2*cos(N2*S*t);
% 
% a=5;
% s=0.2;
% x=0.5*(2*sin(s*t+cos(a*s*t)));
% y=0.5*(2*cos(s*t+sin(a*s*t)));

% r =cos(2*pi*t/3); T = 43;a =2;
% x = (r*cos(pi*t/T)+a)*cos(2*pi*t/T);
% y = (r*cos(pi*t/T)+a)*sin(2*pi*t/T);
% z = r*sin(pi*t/T);

ref=@(t)[x;y;z;0];
end
