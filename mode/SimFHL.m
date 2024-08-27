ts = 0; % initial time
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
% initial_state.p = arranged_position([-1, 0], 1, 1, 0.4);
initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE");
%モデル誤差=============
%controller でモデル誤差用の入力に変換する
% agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.5884*1.5,"lx",0.08*1.3,"ly",0.08*1.3);
%=====================
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1),0);
%外乱を与える==========
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
% agent.input_transform = ADDING_DISTURBANCE(agent,InputTransform_Disturbance_drone(time)); % 外乱付与
%=====================
%モデル誤差元に戻す=============
% agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.5884,"lx",0.08,"ly",0.08);
%=====================
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_circle",{"freq",5,"init",[0;0;1],"radius",1.0},"HL"});
% agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref(readmatrix("waypoint.xlsx",'Sheet','MyNewSheet'),1));%コマンドでシートを選びたいときは位置2を1にする
% agent.controller = FUNCTIONAL_HLC(agent,Controller_FHL(dt));
agent.controller = FUNCTIONAL_HLNNC(agent,Controller_FHLNN(dt));
% agent.controller = FUNCTIONAL_HLNNC_x2xi_Simplified(agent,Controller_FHLNN(dt));

run("ExpBase");
function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end