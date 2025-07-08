%%
%% Initialize
tmp = matlab.desktop.editor.getActive;
dir = fileparts(tmp.Filename);
if ~contains(path,dir)
    cd(erase(dir,'\mode'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear ; clc;
userpath('clear');
end

clear gui
%%
clc; close all;
ts = 0; % initial timefghj
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

%% クープマンモデルの設定
model_file = "EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出";
%model_file = '2025-01-10_Exp_Kiyama_code26_saddle_increased_weight10';
load(model_file,'est'); % main
% [A,B,C] = AB_transfer(est.A, est.B, est.C, dt, 0.08);
A=est.A; B=est.B; C=est.C; % 
agent = DRONE;

%% プラントの設定
%-- 非線形モデル
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
% agent.parameter.mass = 0.5884;
% agent.parameter.mass = 0.730;
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%-- クープマンモデル
% %~~model_discrete: クープマンモデルを使用するうえでA,B行列の設定をする、discrete_linear_modelの観測量
% agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0,"mass",0.730);
% agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)); 
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% controller and reference and sensor (common)
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive)); % GUIで回すとき
agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき

agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1]},"HL"});
agent.controller = MPC_CONTROLLER_K(agent,Controller_MPC_Koopman(dt, model_file, agent)); %最適化手法：QP

%%
% run("ExpBase");
run("SimBase");

%% modeファイル内でプログラムを回す
phase = 'f'
for i = 1:te/dt
    % if i < 20 || rem(i, 10) == 0 end
    tic
    pre_est = agent.estimator.result;
    agent(1).sensor.do(time, phase);
    agent(1).estimator.do(time, phase);
    agent(1).reference.do(time, phase);
    agent(1).controller.do(time, phase);
    agent(1).plant.do(time, phase);
    logger.logging(time, phase, agent);
    time.t = time.t + time.dt;
    %pause(1)
    toc

    agent.controller.show(agent.controller.result.mpc.fval, agent.controller.result.mpc.exitflag);
    est = agent(1).estimator.result.state.p;
    if est(3) < 0 || est(3) > 2
        break
    end
end
%%
logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);
% logger.plot({1,"p","er"}, {1,"v","er"}, {1, "input",""},"xrange", [time.ts, time.t],"fig_num",1,"row_col",[2 2]);

experiment_figure_case_study;