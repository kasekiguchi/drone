clc
ts = 0;
dt = 0.025;
te = 25;
time = TIME(ts,dt,te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0);              % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);

N = 4;
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
initial_state.p = [0;0;1];
initial_state.v = [0;0;0];
initial_state.O = [0;0;0];
initial_state.qi = -1*repmat([0;0;1],N,1);
initial_state.wi = repmat([0;0;0],N,1);
initial_state.Oi = repmat([0;0;0],N,1);

% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = ""; % "eul" : euler angle, "" : euler parameter
if strcmp(qtype,"eul")
initial_state.Q = [0;0;0];
initial_state.Qi = repmat([0;0;0],N,1);
else
initial_state.Q = [1;0;0;0];
initial_state.Qi = repmat([1;0;0;0],N,1);
end
agent = DRONE;

agent.plant = MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N,qtype));
agent.parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE",N);
agent.estimator = DIRECT_ESTIMATOR(agent,struct("model",MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N,qtype)))); % estimator.result.state = sensor.result.state
%agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N)),["p","Q","v","O","qi","wi","Qi","Oi"]));

agent.sensor = DIRECT_SENSOR(agent,0.0); % sensor to capture plant position : second arg is noise 
% agent.reference = TIME_VARYING_REFERENCE(agent,Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}));
agent.reference = POINT_REFERENCE_COOPERATIVE_LOAD(agent,[1,1,1]);
agent.controller = GEOMETRIC_CONTROLLER(agent,Controller_Cooperative_Load(dt));
% agent.controller = GEOMETRIC_CONTROLLER_with_3_Drones(agent,Controller_Cooperative_Load(dt));
run("ExpBase");

%%
clc

for i = 1:20
  i
agent(1).sensor.do(time,'f');
agent(1).estimator.do(time,'f');
agent(1).reference.do(time,'f');
% agent(1).controller.result.input = repmat([1 + 0.3*cos(time.t*2*pi/3);0;0;0],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
agent(1).controller.do(time,'f');
agent(1).controller.result.input'
agent(1).plant.do(time,'f');
logger.logging(time,'f',agent);
time.t = time.t + time.dt;
end
%%
close all
mov = DRAW_COOPERATIVE_DRONES(logger, "self",agent,"target", 1:N);
mov.animation(logger,'target',1:N)
%%
logger.plot({1,"p","p"},{1,"p","e"},{1, "v", "p"},{1, "v", "e"},{1, "plant.result.state.wi","p"})
function dfunc(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.t]);
app.logger.plot({1, "q", "e"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.t]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.t]);
end