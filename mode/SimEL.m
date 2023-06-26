ts = 0; % initial time
dt = 0.025; % sampling period
te = 15; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
initial_state.Trs = [9.81; 0];%divison by zero やちゃんと計算されないので初期値は[0.1; 0.1]にする．

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
%target tragectory
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.0]},"HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",1,"orig",[0;0;1],"size",[0,0,0]},"HL"});
fFT=1;%1:FT, other:LS
agent.controller = ELC(agent,Controller_EL(dt,fFT));
run("ExpBase");
function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end