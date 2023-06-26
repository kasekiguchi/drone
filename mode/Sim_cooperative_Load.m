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
initial_state.p = [0;0;0];
%initial_state.Q = [1;0;0;0];
initial_state.Q = [0;0;0];
initial_state.v = [0;0;0];
initial_state.O = [0;0;0];
initial_state.qi = -1*repmat([0;0;1],N,1);
initial_state.wi = repmat([0;0;0],N,1);
%initial_state.Qi = repmat([1;0;0;0],N,1);
initial_state.Qi = repmat([0;0;0],N,1);
initial_state.Oi = repmat([0;0;0],N,1);

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N));
agent.parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE",N);
% agent.model =
agent.estimator = DIRECT_ESTIMATOR(agent,struct("model",MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N)))); % estimator.result.state = sensor.result.state
agent.sensor = DIRECT_SENSOR(agent,0.0); % sensor to capture plant position : second arg is noise 
% agent.estimator = EKF(agent, Estimator_EKF(agent, ["p", "q"]).param);
% agent.reference = TIME_VARYING_REFERENCE(agent,Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}).param);
agent.reference = POINT_REFERENCE_COOPERATIVE_LOAD(agent,[1,1,1]);
agent.controller = GEOMETRIC_CONTROLLER(agent,Controller_Cooperative_Load(dt));
run("ExpBase");

%%
clc
for i = 1:40
agent(1).sensor.do(time,'f');
agent(1).estimator.do(time,'f');
agent(1).reference.do(time,'f');
% agent(1).controller.result.input = zeros(4*N,1);
fidata = [25,25,325,325];
M1 = [0,0,0]; M2 = [0,0,0]; M3 = [0,0,0]; M4 = [0,0,0];
udata =[fidata(1,1),M1,fidata(1,2),M2,fidata(1,3),M3,fidata(1,4),M4]';
agent(1).controller.result.input = udata;
agent(1).plant.do(time,'f');
logger.logging(time,'f',agent);
tmp = logger.data(1,"plant.result.state.Qi","");
time.t = time.t + time.dt;
end
%%
mov = DRAW_COOPERATIVE_DRONES(logger, "self",agent,"target", 1:N);
mov.animation(logger,'target',1:N)
function dfunc(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.t]);
app.logger.plot({1, "q", "e"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.t]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.t]);
end