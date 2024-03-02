% for simulation on Simulink

%% Base setting
Flag.Exe.Mode = "Sim";
Flag.Controller.Constraint = "None";

%%
ts = 0; % initial time
dt = 0.025; % sampling period
te = 25; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

initial_state.p = [0;0;1];

agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE","row");
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));

parameter.values = agent.parameter.parameter;
parameter.raw = agent.parameter.parameter_raw;

dt = 0.25;%time.dt;
x0 = agent.plant.state.get();
save("plant_setting.mat","x0","dt","parameter");

%% estimator
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
eparam.n = agent.estimator.n;
eparam.B = agent.estimator.B;
eparam.Q = agent.estimator.R;
eparam.R = agent.estimator.Q;

%% reference
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
syms t x f real
matlabFunction(@(t,x,f) agent.reference.func(t),"File","gen_reference.m","Vars",[t,x,f]);
rparam = [];
%% controller
agent.controller = HLC(agent,Controller_HL(dt));
cparam.F1 = lqrd([0,1;0,0],[0;1],diag([1,1]),1,dt);
cparam.F2 = lqrd(diag([1,1,1],1),[0;0;0;1],eye(4),1,dt);
cparam.F3 = cparam.F2;
cparam.F4 = lqrd([0,1;0,0],[0;1],eye(2),1,dt);
cparam.P = agent.parameter.parameter;
%% まとめ
save("setting.mat","x0","dt","eparam","rparam","cparam","parameter");


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

