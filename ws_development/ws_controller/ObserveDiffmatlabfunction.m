% symbolic math toolbox generate 
%variables setup
clear all;clc;close all;
% syms x y theta real
% syms v omega t real
LaserNum = 630;
x = sym('x','real');
y = sym('y','real');
theta = sym('theta','real');
v = sym('v','real');
omega = sym('omega','real');
t = sym('t','real');
d= sym('d',[1 LaserNum],'real');
alpha = sym('alpha',[1 LaserNum],'real');
phi = sym('phi',[1 LaserNum],'real');
k = sym('k' , [1 LaserNum] , 'real');
k = diag(k);%単位行列の作成
% observe diff calculate
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
hk2 = (d(:) - (x+v.*cos(theta).*t)*cos(alpha(:)) - (y+v.*sin(theta).*t).*sin(alpha(:)))./cos(phi(:) - alpha(:) +(theta+omega.*t));
%%
deltah = (hk1 - hk2)'* k *  (hk1 - hk2);%観測値差分の２乗のsum
%%
D = diff(1/deltah,omega);%それぞれの観測値の微分表現
%%
% SS = solve(D == 0,omega,'ReturnConditions',true);
%% make matlabFunctions
outputs = {'D'};
filename = 'ObserveDiff';
% Vars = {x, y, theta, v, omega, t, d, alpha, phi, k};
matlabFunction(D, 'file', filename, 'vars', {x, y, theta, v, omega, t, d, alpha, phi, k}, 'outputs', outputs);