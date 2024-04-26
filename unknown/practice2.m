clc
clear
%ノイズ駆動モデル
syms x [3 1] real
syms u [3 1] real
syms y_T265 [3 1] real
syms y_Yoro [3 1] real

syms A [3 3] real
syms B [3 3] real
syms C [3 3] real

syms sigma_v [3 1] real
syms sigma_w [3 1] real
syms P [3 3] real

x_pre = A*x + B*u;
Y = [y_T265;y_Yoro];
P_pre = A*P*A + sigma_v*sigma_v'*B*B';
G = P_pre*C*inv(C*P_pre*C + sigma_w*sigma_w');
x = x_pre + G*(Y - C*x_pre);
P = (ones(size(C))-G*C)*P_pre;

