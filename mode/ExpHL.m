ts = 0; % initial time
dt = 0.025; % sampling period
te = 10000; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);

motive = Connector_Natnet('ClientIP', '192.168.100.120'); % connect to Motive
motive.getData([], []); % get data from Motive
rigid_ids = [1]; % rigid-body number on Motive
sstate = motive.result.rigid(rigid_ids);
initial_state.p = sstate.p;
initial_state.q = sstate.q;
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_Drone_Exp(dt, initial_state, "udp", [50, 132]));
agent.parameter = DRONE_PARAM("DIATONE");
agent.model = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone().param); % 推力からスロットルに変換

agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive).param);
agent.estimator = EKF(agent, Estimator_EKF(agent, ["p", "q"]).param);
agent.reference = TIME_VARYING_REFERENCE(agent,Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}).param);
agent.controller = HLC(agent,Controller_HL(dt).param);

run("ExpBase");

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "er"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end