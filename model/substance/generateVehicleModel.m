%% Initialize
% do initialize first in main.m
%clc
%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%% Define variables
syms W M r real % tread, mass, wheel radius
syms J jw real % z-axis body inertia, wheel inertia
% xb : 進行方向，yb : 左，zb ：上
syms p [3 1] real % Global 3d position
syms dp [3 1] real % velocity
syms ddp [3 1] real % acceleration
syms q [3 1] real % body-z, right-left wheel rotation
syms ob [3 1] real % body angular velocities wrt q (not angular velocity vector)
% ob + = y-axis : positive ob means move forward.
syms u [6 1] real % right-left wheel torque
syms P real
physicalParam = {M,W,J,jw,r};
Rb0 = [cos(q1),-sin(q1),0;sin(q1),cos(q1),0;0,0,1];
% u1 - r*F1 = jw*dob(2);
% F1 = (u1 - jw*dob(2))/r;
% F2 = (u2 - jw*dob(3))/r;
% F = F1+F2;       % Drive force
% tau = (W/2)*(F1-F2); % torque
%% simplest model
x = [p;q];
f = [sign([cos(q(3)),sin(q(3))]*[u(1);u(2)])*sqrt(u(1)^2+u(2)^2)*cos(q(3));sign([cos(q(3)),sin(q(3))]*[u(1);u(2)])*sqrt(u(1)^2+u(2)^2)*sin(q(3));0;0;0;u(6)];
matlabFunction(f,'file','three_state_vehicle_model','vars',{x u P},'outputs',{'dx'});

%% Local functions
function m = Mtake(mat,m,n)
    m = mat(m,n);
end
