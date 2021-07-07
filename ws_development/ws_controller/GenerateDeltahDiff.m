%% variables setting
clear all;clc;close all;
LaserNum = 1;
x = sym('x','real');
y = sym('y','real');
theta = sym('theta','real');
v = sym('v','real');
omega = sym('omega','real');
t = sym('t','real');
d= sym('d',[1 LaserNum],'real');
alpha = sym('alpha',[1 LaserNum],'real');
phi = sym('phi',[1 LaserNum],'real');
% k = sym('k' , [1 LaserNum] , 'real');
% k = diag(k);%単位行列の作成
% observe diff calculate
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
hk2 = (d(:) - (x+v.*cos(theta).*t)*cos(alpha(:)) - (y+v.*sin(theta).*t).*sin(alpha(:)))./cos(phi(:) - alpha(:) +(theta+omega.*t));
%%
deltah = (hk1 - hk2)'* (hk1 - hk2);%観測値差分の２乗のsum
%%
D = diff(deltah,omega);%それぞれの観測値の微分表現
%%
% SS = solve(D == 0,omega,'ReturnConditions',true);
%% make matlabFunctions DeltahDiff
outputs = {'D'};
filename = 'DeltahDiff';
% Vars = {x, y, theta, v, omega, t, d, alpha, phi, k};
matlabFunction(D, 'file', filename, 'vars', {x, y, theta, v, omega, t, d, alpha, phi}, 'outputs', outputs);
%% 
DD = D^2;
outputs = {'DD'};
filename = 'DeltahPower2';
% Vars = {x, y, theta, v, omega, t, d, alpha, phi, k};
matlabFunction(DD, 'file', filename, 'vars', {x, y, theta, v, omega, t, d, alpha, phi}, 'outputs', outputs);