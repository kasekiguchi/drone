function [ref] = Case_study_trajectory_2012021(X0)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

syms t real
x_0 = X0(1);
y_0 = X0(2);
z_0 = X0(3);



%% 円軌道(見本)
s = 4; % s = 2 → period = 4*pi (12 sec)
x = x_0+cos(t/s);
y = y_0+sin(t/s);
z = 1;

%% 自由(ここを編集)
% 経過時間はt 目標座標は(x,y,z) その他周回周期や周波数は自分で定義すること
% 条件はx,yぞれぞれが-1.5m～1.5mに収まること
d=2;
T=30; %
seta=2*pi*(t+d)/T; %
y=(-0.1+cos(2*seta)).*(sin(seta));
x=(0.1+cos(2*seta)).*(cos(seta));
z=1;
ref=@(t)[x;y;z;0];
end

