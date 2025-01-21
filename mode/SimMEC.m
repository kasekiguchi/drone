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
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 0.6); % [x, y], 機数，1, z (初期位置)
initial_state.q = [0; 0.01; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%% クープマンモデルの設定
model_file = "2024-11-18_Exp_Kiyama_Error_code00_saddle"; % 誤差拡張
load(model_file,'est'); % main
% [A,B,C] = AB_transfer(est.A, est.B, est.C, dt, 0.08);
A=est.A; B=est.B; C=est.C;
agent = DRONE;

%% 非線形モデルをプラントに設定する場合
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
% agent.parameter.mass = 0.5884;
% agent.parameter.mass = 0.730;
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% クープマンモデルをプラントに設定する場合
% % model_discrete: クープマンモデルを使用するうえでA,B行列の設定をする、discrete_linear_modelの観測量
% agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0);
% agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)); 
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% controller and reference and sensor (common)
agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1]},"HL"});
agent.controller = MEC_Koopman(agent,Controller_MEC_Koopman(dt, model_file, agent));

% run("ExpBase");
run("SimBase");

%% modeファイル内でプログラムを回す
phase = 'f'
for i = 1:te/dt
    % if i < 20 || rem(i, 10) == 0 end
    tic
    agent(1).sensor.do(time, phase, agent);
    agent(1).estimator.do(time, phase, agent);
    agent(1).reference.do(time, phase, agent);
    agent(1).controller.do(time, phase, agent);
    agent(1).plant.do(time, phase, agent);
    logger.logging(time, phase, agent);
    time.t = time.t + time.dt;
    toc
    est = agent(1).estimator.result.state.p;
    if est(3) < 0 || est(3) > 2
        break
    end
end
%%
app.logger = logger;
result_plot(app, model_file);
% logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);
% logger.plot({1,"p","er"}, {1,"v","er"}, {1, "input",""},"xrange", [time.ts, time.t],"fig_num",1,"row_col",[2 2]);
% logger.save("10_hokukai");

function result_plot(app, model)
    app.fExp = 0;
    flg.figtype = 0; % 0:subplot
    flg.savefig = 0;
    flg.animation_save = 0;
    flg.animation = 1;
    flg.timerange = 0;
    flg.plotmode = 1; % 1:inner_input, 2:xy, 3:xyz
    filename = string(datetime('now'), 'yyyy-MM-dd');
    fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[],'fignum',[2, 3]), struct('model', model));
    fig.main_figure();
    % fig.main_animation();
end

function dfunc(app)
    result_plot(app, '');
end