ts = 0; % initial time
dt = 0.025; % sampling period
te = 30; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([-1, 0], 1, 1, 0.4);
% initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
% agent.parameter = DRONE_PARAM("DIATONE");
%モデル誤差=============
agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.5884*1.5,"lx",0.08*1.3,"ly",0.08*1.3);
% %=====================
fmodel_error=0;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1),fmodel_error);
%外乱を与える=============
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
% agent.input_transform = ADDING_DISTURBANCE(agent,InputTransform_Disturbance_drone(time)); % 外乱付与
%モデル誤差元に戻す=============
agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.5884,"lx",0.08,"ly",0.08);
%=====================

agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.estimator =DIRECT_ESTIMATOR(agent,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)));
% agent.sensor = DIRECT_SENSOR(agent);
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1.2],"size",[1,1,0.8]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[0,0,1]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[2;2;1.2],"g",[-0.2;0.2;0.8],"h",[-0.2;-0.2;1.2],"j",[0.2;-0.2;0.8],"k",[0;0;1],"m",[-2;2;3]),10});%縦ベクトルで書く,
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[2;1;1.2],"h",[-0.2;-0.8;0.5]),10});%縦ベクトルで書く,
% agent.reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));
% agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));%引数に指定しているシートを使うときは位置3を1にする
fApprox_FTxy = 0;%approximate x,y directional FTC input : 1
fNewParam = 0;%新しく更新する場合 : 1
fConfirmFig =0;%近似入力のfigureを確認する場合 : 1
agent.controller = FTC(agent,Controller_FT(dt, fApprox_FTxy, fNewParam, fConfirmFig));
run("ExpBase");
function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "p1-p2", "pr"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end