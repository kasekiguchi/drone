%% variables setting
clear all;clc;close all;
LaserNum = 1;
x = sym('x','real');
y = sym('y','real');
theta = sym('theta','real');
v = sym('v','real');
a = sym('a','real');
omega = sym('omega','real');
t = sym('t','real');
d= sym('d',[1 LaserNum],'real');
alpha = sym('alpha',[1 LaserNum],'real');
phi = sym('phi',[1 LaserNum],'real');
% Flag = sym('k',[LaserNum 1],'real');
%%
%runge kutta for solve x[k+1] by VOmegaModel
vec = [x;y;theta];
u = [v,omega];
k1 = VOmegaModel(vec,u);
k2 = VOmegaModel(vec+(k1)/2,u);
k3 = VOmegaModel(vec+(k2)/2,u);
k4 = VOmegaModel(vec+k3,u);
xk1 = vec + (1/6)*t.*(k1 + (2*k2) + (2*k3) + k4);
%%
% observe diff calculate
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
hk2 = (d(:) - xk1(1)*cos(alpha(:)) - xk1(2)*sin(alpha(:)))./cos(phi(:) - alpha(:) +xk1(3));
%%
r = (hk1 - hk2);%観測値差分
%% Make FIM
partial1 = diff(r,v);
partial2 = diff(r,omega);
% P = arrayfun(@(L) Flag(L) * ([partial1(L);partial2(L)]*[partial1(L);partial2(L)]') ,1:LaserNum ,'UniformOutput' ,false);
% PP = P{1,1};
% for Sumi=2:629
%     PP = PP + P{1,Sumi};
% end
P = [partial1;partial2];
PP = P*P';
% PP = simplify(PP);
%% Make FIM for AOMEGA
%runge kutta for solve x[k+1] by AOmegaModel
vec = [x;y;theta;v];
u = [a,omega];
k1 = AOmegaModel(vec,u);
k2 = AOmegaModel(vec+(k1)/2,u);
k3 = AOmegaModel(vec+(k2)/2,u);
k4 = AOmegaModel(vec+k3,u);
xk1 = vec + (1/6)*t.*(k1 + (2*k2) + (2*k3) + k4);
hk1 = (d(:) - x.*cos(alpha(:)) - y.*sin(alpha(:)))./cos(phi(:) - alpha(:) + theta);
hk2 = (d(:) - xk1(1)*cos(alpha(:)) - xk1(2)*sin(alpha(:)))./cos(phi(:) - alpha(:) +xk1(3));
r = (hk1 - hk2);%観測値差分
partial1 = diff(r,v);
partial2 = diff(r,omega);
% P = arrayfun(@(L) Flag(L) * ([partial1(L);partial2(L)]*[partial1(L);partial2(L)]') ,1:LaserNum ,'UniformOutput' ,false);
% PP = P{1,1};
% for Sumi=2:629
%     PP = PP + P{1,Sumi};
% end
P = [partial1;partial2];
APP = P*P';
%%
PV = partial1*partial1;
%%
partial1 = diff(r,v);
partial2 = diff(r,theta);
P = [partial1;partial2];
PVT = P*P';
%% make matlabFunctions DeltahDiff
outputs = {'PP'};
filename = 'FIM_ObserbSubVOmegaRungeKutta';
matlabFunction(PP, 'file', filename, 'vars', {x, y, theta, v, omega, t, d, alpha, phi}, 'outputs', outputs);
%% make matlabFunctions DeltahDiff
outputs = {'APP'};
filename = 'FIM_ObserbSubAOmegaRungeKutta';
matlabFunction(APP, 'file', filename, 'vars', {x, y, theta, v, omega, a, t, d, alpha, phi}, 'outputs', outputs);
%%
outputs = {'PV'};
filename = 'FIMOV_ObserbSubAOmegaRungeKutta';
matlabFunction(PV, 'file', filename, 'vars', {x, y, theta, v, omega, a, t, d, alpha, phi}, 'outputs', outputs);
%%
outputs = {'PVT'};
filename = 'FIMVT_ObserbSubAOmegaRungeKutta';
matlabFunction(PVT, 'file', filename, 'vars', {x, y, theta, v, omega, a, t, d, alpha, phi}, 'outputs', outputs);
%% Local function
function dX = VOmegaModel(x,u)
    dX = [u(1)*cos(x(3));u(1)*sin(x(3));u(2)];
end
function dX = AOmegaModel(x,u)
    dX = [x(4)*cos(x(3));x(4)*sin(x(3));u(2);u(1)];
end