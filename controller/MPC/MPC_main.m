%% mpc sample main
% set path
clear all
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
clc;disp('Setup for simulation...');
tmp = matlab.desktop.editor.getActive;warning('off','all');
cd(fileparts(tmp.Filename)); close all; userpath('clear');addpath(genpath('./src'));

%% simulation setting
n = 2;
dt = 0.05;     % sampling time
Td = 0.1;      % prediction step size
Te = 5;	                            % end time
x = [0; 1];                          % initial state
u = [0; 0];                          % initial input
H = 25;
ur = [repmat([0.5;0],1,H),[0;0]];                          % input reference
Xo = [3;1];                             % obstacle position

%% mpc setting
model = LINEAR_MODEL(@(Td) MassModel2d(n,Td),dt,x); % model class
controller = MPC(model,x,u,Td,H); % controller class
%% main
logger = LOGGER(controller,x,u,round(Te / dt)); % data logger 
%profile on
idx = 1;                    % loop index
while idx*dt <= Te

  % output function
  y = model.Cd*x;

  % gen reference
  xr = Reference(controller.H+1, ur, y, Td);       

  %% model predictive control
  [var, fval, exitflag, output, lambda, grad, hessian] = controller.do(x,xr,ur);
  % extract current input
  u = var(:,H+2); 

  % logging
  logger.log(idx,[idx * dt,x',u',xr(:,1)',ur(:,1)'],var, fval, exitflag, output, lambda, grad, hessian)
  x = model.do(u);  % update plant model
  idx = idx + 1 % time update
end
%profile viewer
%%
plot_figure(logger.data,Xo,Te);

