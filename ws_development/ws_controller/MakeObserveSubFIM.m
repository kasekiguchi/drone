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
% observe diff calculate
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
hk2 = (d(:) - (x+v.*cos(theta).*t)*cos(alpha(:)) - (y+v.*sin(theta).*t).*sin(alpha(:)))./cos(phi(:) - alpha(:) +(theta+omega.*t));
%%
r = (hk1 - hk2);%観測値差分
%% Make FIM
partial1 = diff(r,v);
partial2 = diff(r,omega);
P = [partial1;partial2];
PP = P*P';
PP = simplify(PP);
%% make matlabFunctions DeltahDiff
outputs = {'PP'};
filename = 'FIM_ObserbSub';
matlabFunction(PP, 'file', filename, 'vars', {x, y, theta, v, omega, t, d, alpha, phi}, 'outputs', outputs);