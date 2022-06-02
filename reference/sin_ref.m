function [ref] = sin_ref(X0)
%UNTITLED この関数の概要をここに記述
%入力の切換の速さを確認
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);

T=6-0.1*t;
if T==0.1
    T=0.1;
end
f=1/T;

% x = x_0+0.5*sin(2*pi*f*t);
% y = y_0;
% z = z_0;

% x = x_0;
% y = y_0+0.5*sin(2*pi*f*t);
% z = z_0;

x = x_0;
y = y_0;
z = z_0+0.5*sin(2*pi*0.7*t);

% x = x_0+0.5*sin(2*pi*f*t);
% y = y_0+0.5*sin(2*pi*f*t);
% z = z_0+0.5*sin(2*pi*f*t);

ref=@(t)[x;y;z;0];%x,y,z is function of t.
end

