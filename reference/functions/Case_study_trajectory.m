function ref = Case_study_trajectory(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述
% arguments
%     param.freq = 10% 周期
%     param.orig = [0 0 0]% サドルの中心
%     param.size = [1 1 0]% 各軸の振幅
%     param.phase = -pi% 位相
% end

syms t real
%% 
% s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
% y_offset = 5;
% r = 0.1;
% 
% x = x_0+r*16*sin(t/s)^3;
% y = y_0+r*(13*cos(t/s)-5*cos(2*t/s)-2*cos(3*t/s)-cos(4*t/s)-y_offset);
% z = z_0;

%% z方向も回転する軌道
% T = 20;
% x = sin(2*pi*t/T);
% y = cos(2*pi*t/T);
% z = 0.5*cos(3*pi*t/T)+1;

% x = 0.5*sin(3*pi*t/T);
% y = 0.5*cos(3*pi*t/T);
% z = 0.5*sin(3*pi*t/T)+1;

%% 円旋回
T = 15;
x = cos(2*pi*t/T);
y = sin(2*pi*t/T);
z = 1;

% x = cos(2*pi*t/T) - cos(pi*t/T);
% y = sin(2*pi*t/T);
% z = 1;

%% hovering
% x = 0;
% y = 0;
% z = 1;

%% 縦円旋回
% x = 0.5*sin(2*pi*t/T);
% y = 0;
% z = 0.5*cos(2*pi*t/T)+1; %1:オフセットを入れる必要あり
% yaw = 2*pi*t/5;

%% 八の字
% x = sin(2*t/T);
% y = sin(t/T);
% z = 1;

%% 
% s = 8;
% x = t/s;
% y = x^2;
% z = 1;

%% 八の字拡張版
% s = 8;
% x = sin(2*t/s);
% y = cos(3*t/s);
% z = 1;

%% 直線
% x = 0;
% y = 0;
% z = 1;

%% sigmoid
% te = 10; % 何秒で移動するか
% % a = 0.25;
% x = 0;
% % y = 1/(1+exp(a*(-t + te/2))); % ゆるやかに移動するようにしたい
% z = 1;
% % x = 1/(1+exp(-t + te/2));
% y = 1/(1+exp(-t + te/2));
% 
timevarying_refrence=[x y z]
ref=@(t)[x;y;z;0];
end

