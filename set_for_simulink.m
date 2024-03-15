% for simulation on Simulink

%% Base setting
Flag.Exe.Mode = "Sim";
Flag.Controller.Constraint = "None";

dt = time.dt;

%% Plant
% Sim model
plant_c = @(x,u,p) agent.plant.method(x,u,p);
x0 = agent.plant.state.get();
nx = length(x0);
% disturbance
Qs = zeros(nx);
% parameter
P = agent.parameter;

%% Sensing
Env = NULL_PARAM("null");
EX0 = agent.estimator.result.state.get();

%% Estimator
U0 = zeros(4,1);  
ny = size(agent.estimator.result.G,2);
StateEKF = @(t, P, xh, u, y) agent.estimator.do(struct("t",t,"dt",dt));

%% Reference
Td = dt ;  % predicition step
GenReference = @(Pinfo,X,Env,t,U) agent.reference.do(struct("t",t,"dt",dt));

%% Pre treatment

%% Constraint

%% Controller
mpc = @(x,up,ref, Constraints) agent.controller.do()
%% Post treatment

