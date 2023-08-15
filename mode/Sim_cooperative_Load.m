clc
ts = 0;
dt = 0.1;
te = 25;
time = TIME(ts, dt, te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1, size(ts:dt:te, 2), 0, [], []);

N = 4;
% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = "zup"; % "eul":euler angle, "":euler parameter
% x = [p0 Q0 v0 O0 qi wi Qi Oi]


initial_state.p = [0; 0; 1];
initial_state.v = [0; 0; 0];
initial_state.O = [0; 0; 0];
initial_state.wi = repmat([0; 0; 0], N, 1);
initial_state.Oi = repmat([0; 0; 0], N, 1);

% initial_state.p = [1; 4.8; 1.5];
% initial_state.v = [0; 0; 0];
% initial_state.O = [0; 0; -1.0996];
% initial_state.wi = repmat([0; 0; 0], N, 1);
% initial_state.Oi = repmat([0; 0; 0], N, 1);

if contains(qtype, "zup")
    initial_state.qi = -1 * repmat([0; 0; 1], N, 1);
else
    initial_state.qi = 1 * repmat([0; 0; 1], N, 1);
end

if contains(qtype, "eul")
    initial_state.Q = [0; 0; 0];
    %initial_state.Qi = repmat([0; pi / 180; 0], N, 1);
    initial_state.Qi = repmat([0;0;0],N,1);
else
    initial_state.Q = [1; 0; 0; 0];
    initial_state.Q = initial_state.Q / vecnorm(initial_state.Q);
    initial_state.Qi = repmat([1; 0; 0; 0], N, 1);
    %initial_state.Qi = repmat(Eul2Quat([pi/180;0;0]),N,1);
end

agent = DRONE;

agent.plant = MODEL_CLASS(agent, Model_Suspended_Cooperative_Load(dt, initial_state, 1, N, qtype));
agent.parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent.estimator = DIRECT_ESTIMATOR(agent, struct("model", MODEL_CLASS(agent, Model_Suspended_Cooperative_Load(dt, initial_state, 1, N, qtype)))); % estimator.result.state = sensor.result.state
%agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N)),["p","Q","v","O","qi","wi","Qi","Oi"]));

agent.sensor = DIRECT_SENSOR(agent, 0.0); % sensor to capture plant position : second arg is noise
% agent.reference = TIME_VARYING_REFERENCE(agent,Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}));
% agent.reference = POINT_REFERENCE_COOPERATIVE_LOAD(agent,[1,1,1]);
% agent.reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent,Reference_Time_Varying_Cooperative_Load("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}));
agent.reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent,{"gen_ref_sample_cooperative_load",{"freq",40,"orig",[0;0;1],"size",[1,1,0]},"Cooperative"});
%agent.controller = GEOMETRIC_CONTROLLER(agent,Controller_Cooperative_Load(dt));
agent.controller = CSLC(agent, Controller_Cooperative_Load(dt, N));
% agent.controller = GEOMETRIC_CONTROLLER_with_3_Drones(agent,Controller_Cooperative_Load(dt));
run("ExpBase");

%
clc
for i = 1:200
    if i < 20 || rem(i, 10) == 0, i, end
    agent(1).sensor.do(time, 'f');
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    %agent(1).controller.do(time, 'f');
    %agent(1).controller.result.input = repmat([1.01 + 0.0*cos(time.t*2*pi/3);0.001*[sin(time.t*(pi)/1);0*cos(time.t*(pi)/1);0]],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    agent(1).controller.result.input = repmat([1;0;0;0],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    %agent(1).controller.result.input = agent(1).controller.result.input.*repmat([-1;1;-1;-1],N,1);
    agent(1).plant.do(time, 'f');
    logger.logging(time, 'f', agent);
    time.t = time.t + time.dt;
    %pause(1)
end

%%
logger.plot({1,"p","pr"},{1, "plant.result.state.wi", "p"}, {1, "plant.result.state.Q", "p"}, {1, "plant.result.state.qi", "p"}, {1, "plant.result.state.Qi", "p"},{1, "input", "p"})
%%
close all
mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
mov.animation(logger, 'target', 1:N, "gif",false)
%%
logger.plot({1,"plant.result.state.qi","p"},{1,"p","er"},{1, "v", "p"},{1, "input", "p"},{1, "plant.result.state.Qi","p"})
%%
function dfunc(app)
app.logger.plot({1, "p", "er"}, "ax", app.UIAxes, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "q", "e"}, "ax", app.UIAxes2, "xrange", [app.time.ts, app.time.t]);
appb.logger.plot({1, "input", ""}, "ax", app.UIAxes3, "xrange", [app.time.ts, app.time.t]);
end
