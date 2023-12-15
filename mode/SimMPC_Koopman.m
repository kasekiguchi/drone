ts = 0; % initial time
dt = 0.025; % sampling period
te = 100; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 1); % [x, y], 機数，1, z (初期位置)
% initial_state.q = [1; 0; 0; 0];
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%-------Modelがroll_pitch_yaw_thrust_force_physical_parameter_modelか確認--------------------
agent = DRONE;
% agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1)); %総推力のトルク
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)); %各ロータの推力
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1.2]},"HL"});
% agent.controller = MPC_CONTROLLER_KOOPMAN_fmincon(agent,Controller_MPC_Koopman(agent)); %最適化手法：SQP
agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog(agent,Controller_MPC_Koopman(agent)); %最適化手法：QP
run("ExpBase");

%% クープマンモデルをプラントに設定する場合

% load("EstimationResult_12state_10_30_data=cirandrevsadP2Pxy_cir=cir_est=cir_Inputandconst.mat",'est');
% load("EstimationResult_12state_11_29_GUIsimdata.mat",'est')
% load("EstimationResult_12state_12_6_Expalldata_input=torque.mat",'est')
% 
% A = est.A;
% B = est.B;
% C = est.C;
% agent = DRONE;
% agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0);
% agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% % agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)),["p", "q"]));
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1.2]},"HL"});
% % agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",20,"orig",[0;0;1],"size",[1,1,0.5]},"HL"});
% % agent.controller = MPC_CONTROLLER_KOOPMAN_fmincon(agent,Controller_MPC_Koopman(agent)); %最適化手法：SQP
% agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog(agent,Controller_MPC_Koopman(agent)); %最適化手法：QP
% 
% run("ExpBase");

%% 実機データを用いてMPC回す場合

% data = LOGGER("experiment_6_20_circle1_Log(20-Jun-2023_16_26_34).mat");
% finitIndex = find(data.Data.phase == 102,1,'first');
% fendIndex = find(data.Data.phase == 102,1, 'last');

% for i = finitIndex:fendIndex
%     agent.sensor.result = data.Data.agent.sensor.result{i};
%     agent.estimator.result = data.Data.agent.estimator.result{i};
%     agent.reference.result = data.Data.agent.reference.result{i};
%     agent(1).controller.do(time, 'f')
%     logger.logging(time,'f',agent);
%     time.t = time.t + dt;
% end
% save('quadprog_test.mat', 'logger')

% run("ExpBase");

function dfunc(app)

% app.logger.plot({1, "p1-p2", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "p1-p2-p3", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "e"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);

Graphplot(app)
end