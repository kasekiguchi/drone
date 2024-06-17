clc
ts = 0; % initial time
dt = 0.025; % sampling period
te = 100; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 1); % [x, y], 機数，1, z (初期位置)
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%% 非線形モデルをプラントに設定する場合
% agent = DRONE;
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
% agent.parameter = DRONE_PARAM("DIATONE");
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% % agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
% agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});
% % agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0;0;0],"g",[0;0;1],"h",[0;0;0],"j",[0;0;1]),5});
% % agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",60,"orig",[0;0;1],"size",[1,1,1]},"HL"});

%% クープマンモデルをプラントに設定する場合
load("EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat",'est') %vzから算出したzで学習、総推力
% load("EstimationResult_2024-05-03_Exp_Kiyama_code03_2.mat", "est");
sys = ss(est.A, est.B, est.C, zeros(size(est.C,1), size(est.B,2)), 0.07); % サンプリングタイムの変更
A = sys.A; % default: est.A
B = sys.B;
C = sys.C;
agent = DRONE;
agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0);
agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)); 
% model_discrete: クープマンモデルを使用するうえでA,B行列の設定をする、discrete_linear_modelの観測量
% 4入力：model_get_name = 4入力モデルに変更
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",20,"orig",[0;0;1],"size",[1,1,0.5]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0;0.7],"g",[0;0;1],"h",[0.5;0;0.7],"j",[0;0;1]),5}); %P2Pリファレンス
% agent.controller = MPC_CONTROLLER_KOOPMAN_fmincon(agent,Controller_MPC_Koopman(agent)); %最適化手法：SQP
%% Sampleクラスもクープマンモデルをセットする
agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog_simulation(agent,Controller_MPC_Koopman(dt)); %最適化手法：QP

run("ExpBase");

%% modeファイル内でプログラムを回す
for i = 1:te/dt
    if i < 20 || rem(i, 10) == 0 end
    tic
    agent(1).sensor.do(time, 'f');
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    agent(1).controller.do(time, 'f');
    %agent(1).controller.result.input = repmat([1.01 + 0.0*cos(time.t*2*pi/3);0.001*[sin(time.t*(pi)/1);0*cos(time.t*(pi)/1);0]],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    %agent(1).controller.result.input = repmat([1;0;0;0],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    %agent(1).controller.result.input = agent(1).controller.result.input.*repmat([-1;1;-1;-1],N,1);
    %agent(1).controller.result.input(4:4:end) = 0;
    agent(1).plant.do(time, 'f');
    logger.logging(time, 'f', agent);
    time.t = time.t + time.dt;
    %pause(1)
    all = toc
end
%%
logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);

%%
% function dfunc(app)
% % app.logger.plot({1, "p1-p2", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% % app.logger.plot({1, "p1-p2-p3", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "q", "e"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% % Graphplot(app)
% end