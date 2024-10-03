ts = 0; % initial time
dt = 0.025; % sampling period
te = 45; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
%追加
% logger_2p = LOGGER_2p(1, size(ts:dt:te, 2), 0, [],[]);
%
initial_state.p = arranged_position([0, 0], 1, 1, 0); %arranged_position.mで関数定義
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
%追加
% initial_state_2p.p = arranged_position_2p([1, 1], 1, 1, 0);
% initial_state_2p.q = [1; 0; 0; 0];
% initial_state_2p.v = [0; 0; 0];
% initial_state_2p.w = [0; 0; 0];
%

agent = DRONE; %ドローンの描画に関するもの？DRONE.mで関数定義
agent.parameter = DRONE_PARAM("DIATONE"); %ドローンの物理パラメータ DRONE_PARAM.mで関数定義
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1)); %ドローンの状態を更新している MODEL_CLASS.mで定義
%外乱を与える==========
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
% agent.input_transform = ADDING_DISTURBANCE(agent,InputTransform_Disturbance_drone(time)); % 外乱付与
%=====================
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",0,"orig",[0;0;1],"size",[0,0,0]},"HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.2;0.2;1.2],"g",[-0.2;0.2;0.8],"h",[-0.2;-0.2;1.2],"j",[0.2;-0.2;0.8],"k",[0;0;1],"m",[-2;2;3]),0});%縦ベクトルで書く,
agent.controller = HLC(agent,Controller_HL(dt));
run("ExpBase");
function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end