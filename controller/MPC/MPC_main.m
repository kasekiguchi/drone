%% mpc sample main
% set path
clc
clear all
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
clc;disp('Setup for simulation...');
tmp = matlab.desktop.editor.getActive;warning('off','all');
cd(fileparts(tmp.Filename)); close all; userpath('clear');addpath(genpath('./src'));

%% simulation setting
n = 4;
m = 2;
dt = 0.1;     % sampling time
Td = 0.1;      % prediction step size
Te = 5;	                            % end time
x = [0; zeros(n/2-1,1);1; zeros(n/2-1,1)];                          % initial state
u = [0; 0];                          % initial input
H = 25;
vr = ones(H,1)*1;
ur = repmat([0;0],H,1);                          % input reference
Xo = [1;0];                             % obstacle position

%% mpc setting
agent.model = LINEAR_MODEL(@(Td) MassModel2d(n,Td),dt,x); % model class
agent.controller = MPC(agent.model,x,u,Td,H); % controller class
%agent.controller = CBFMPC(agent.model,x,u,Td,H); % controller class
agent.estimator.result.state.p = x;
agent.estimator.result.state.xo = Xo;%[Xo(1);zeros(n/2-1,1);Xo(2);zeros(n/2-1,1)];
agent.reference.result.state.xd = [];
%% main
logger = LOGGER(agent.controller,x,u,round(Te / dt)); % data logger
%profile on
idx = 1;                    % loop index
while idx*dt <= Te

  % output function
  y = agent.model.Cd*x;

  % gen reference
  % xr = Reference(n, agent.controller.H, vr, y, Td);
  % xr(find(xr(1:4:end,1)>2.5)+1,1) = 1;
   xr = [[y(1);0] + [vr';0*vr'].*(Td:Td:agent.controller.H*Td);vr';0*vr'];
   xr(2,(xr(1,:) > 2.5)) = 1; % change the reference at x = 2.5
   xr = reshape([xr(1,:);vr';xr(2,:);vr'*0],[],1);
  %% model predictive control
  agent.estimator.result.state.p = x;
  %agent.reference.result.state.xd = xr; %CBFMPC
  agent.reference.result.state.xd = [xr;ur]; % MPC
  %[var, fval, exitflag, output, lambda, grad, hessian] = agent.controller.do([],[],[],[],agent);
  [var,fval, exitflag, output, lambda] = agent.controller.do([],[],[],[],agent);
  % extract current input
  u = var(n*H+1:n*H+m); % MPC
  %u = var(1:m); % CBFMPC
  % logging
  %logger.log(idx,idx * dt,[x',u',xr(1:n,1)',ur(1:m,1)'],var, fval, exitflag, output, lambda, grad, hessian)
  logger.log(idx,idx * dt,[x',u',xr(1:n,1)',ur(1:m,1)'],var, fval, exitflag, output, lambda,0,0);
  x = agent.model.do(u);  % update plant model
  idx = idx + 1 % time update
end
%profile viewer
%%
plot_figure(logger.data,Xo,Te,n,m);

