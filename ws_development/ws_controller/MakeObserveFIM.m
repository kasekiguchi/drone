%% comment
%観測値のみのFisher情報量を算出する関数を吐き出すプログラム
%% variables setting
clear all;clc;close all;
% LaserNum = 1;
x = sym('x','real');
y = sym('y','real');
theta = sym('theta','real');
% v = sym('v','real');
% omega = sym('omega','real');
% t = sym('t','real');
d= sym('d','real');
alpha = sym('alpha','real');
phi = sym('phi','real');
% Flag = sym('k',[LaserNum 1],'real');
% observe diff calculate
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
%% Make FIM
partial1 = diff(hk1,x);
partial2 = diff(hk1,y);
partial3 = diff(hk1,theta);
PP = [partial1;partial2;partial3]*[partial1;partial2;partial3]';
% PP = P{1,1};
% for Sumi=2:629
%     PP = PP + P{1,Sumi};
% end
%% make matlabFunctions h
outputs = {'PP'};
filename = 'FIM_Observe';
vars = {x, y, theta, d, alpha, phi};
matlabFunction(PP, 'file', filename, 'vars',vars , 'outputs', outputs);
%%