clc;
ts = 0; % initial timefghj
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 1); % [x, y], 機数，1, z (初期位置)
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%% クープマンモデルの設定
% model_file = "EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat";
model_file = "2024-12-23_Exp_Kiyama_code23_saddle_increased_weight10";
% model_file = "2024-12-19_Exp_Kiyama_code26_saddle";
load(model_file,'est'); % main
[A,B,C] = AB_transfer(est.A, est.B, est.C, dt, 0.08);
agent = DRONE;
%% 非線形モデルをプラントに設定する場合
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% クープマンモデルをプラントに設定する場合
% model_discrete: クープマンモデルを使用するうえでA,B行列の設定をする、discrete_linear_modelの観測量
% agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0);
% agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)); 
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% controller and reference and sensor (common)
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive)); % GUIで回すとき
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1]},"HL"});
agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog_simulation_v2(agent,Controller_MPC_Koopman(dt, model_file, agent)); %最適化手法：QP
run("SimBase");

%%
function dfunc(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "w", "e"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end