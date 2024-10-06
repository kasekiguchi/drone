clc
ts = 0; % initial time
dt = 0.025; % sampling period
te = 500; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);

initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
initial_state.vL = [0; 0; 0];
initial_state.pT = [0; 0; -1];
initial_state.wL = [0; 0; 0];
initial_state.p = [1;0;1.46];

agent = DRONE;
agent.parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
agent.plant = MODEL_CLASS(agent,Model_Suspended_Load(dt, initial_state,1,agent));%id,dt,type,initial,varargin
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Suspended_Load(dt, initial_state, 1,agent)), ["p", "q"],"B",blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]),"Q",blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8)));
agent.sensor = DIRECT_SENSOR(agent, 0.0);
agent.reference = TIME_VARYING_REFERENCE_SUSPENDEDLOAD(agent,{"Case_study_trajectory",{[0;0;1]},"Suspended"});
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.controller.load = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dt,agent));
agent.controller.do = @controller_do;
agent.controller.result.input = [(agent.parameter.loadmass+agent.parameter.mass)*agent.parameter.gravity;0;0;0];

run("ExpBase");
%%
% clc
% for i = 1:time.te
%     if i < 20 || rem(i, 10) == 0, i, end
%     agent(1).sensor.do(time, 'f');
%     agent(1).estimator.do(time, 'f');
%     agent(1).reference.do(time, 'f');
%     agent(1).controller.do(time, 'f',0,0,agent,1);
%     agent(1).plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     %pause(1)
% end

%%
logger.plot({1,"plant.result.state.pL","p"},{1,"input",""})
% logger.plot({1,"plant.result.state.pL","p"})
%%
function result = controller_do(varargin)
controller = varargin{5}.controller;
result = controller.hlc.do(varargin);
result = merge_result(result,controller.load.do(varargin));
varargin{5}.controller.result = result;
end

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "plant.result.state.pL", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end