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
clc
ts = 0; % initial timefghj
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 0.6); % [x, y], 機数，1, z (初期位置)
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%% クープマンモデルの設定
% model_file = "EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat";
% model_file = 'EstimationResult_2024-05-13_Exp_Kiyama_code04_1.mat';
% model_file = '2024-07-14_Exp_Kiyama_code08_saddle.mat';
% model_file = '2024-09-11_Exp_Kiyama_code10_saddle.mat';
model_file = "2024-10-07_Exp_Kiyama_Error_correct_code00_saddle";
load(model_file,'est') %vzから算出したzで学習、総推力
try
    ssmodel = ss(est.A, est.B, est.C, zeros(size(est.C,1), size(est.B,2)), dt); % サンプリングタイムの変更
    args = d2d(ssmodel, Controller_param.dt);
    A = args.A;
    B = args.B;
    C = args.C;
catch
    A = est.A;
    B = est.B;
    C = est.C;
end
%% 位置を含まないモデルの場合，速度から算出する行列に変更
% なんか上手くいかない部分ができちゃったから封印
% if model_file == '2024-09-11_Exp_Kiyama_code10_saddle.mat'
% A_1 = [eye(3), zeros(3), eye(3)*dt, zeros(3, size(A,1)-6)];
% A_2 = [zeros(size(A,2), 3), A];
% A = [A_1; A_2];
% B = [zeros(3, 4); B];
% C = blkdiag(eye(3), C);
% end
%% 非線形モデルをプラントに設定する場合
agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% クープマンモデルをプラントに設定する場合
% model_discrete: クープマンモデルを使用するうえでA,B行列の設定をする、discrete_linear_modelの観測量
% agent = DRONE;
% agent.parameter = POINT_MASS_PARAM("rigid","row","A",A,"B",B,"C",C,"D",0);
% agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)); 
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

%% controller and reference and sensor (common)
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive)); % GUIで回すとき
% agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき

% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,1]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[1;0;1],"g",[-1.5;0;1],"h",[0;0;1],"j",[-1;0;1]),7});
% agent.reference = MY_REFERENCE_KOMA2(agent,{"",2,te}); % 1:from mat, 2:9-order polynomial

% agent.controller = MPC_KOOPMAN_CVXGEN(agent, Controller_MPC_Koopman(dt));
% agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog_simulation(agent,Controller_MPC_Koopman(dt, model_file)); %最適化手法：QP

%% 1コンのとき  100行目もコメントイン
% agent.controller = MPC_CONTROLLER_KOOPMAN_HL_simulation(agent,Controller_MPC_Koopman(dt, model_file,agent));
% conmode = 1;
%% 2つのコントローラの設定  101行目もコメントイン
agent.controller.mpc = MPC_CONTROLLER_KOOPMAN_HL_simulation(agent,Controller_MPC_Koopman(dt, model_file, agent));
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.controller.result.input = [0;0;0;0];
agent.controller.do = @controller_do;
conmode = 2;

%%
run("ExpBase");

%% modeファイル内でプログラムを回す
% for i = 1:te/dt
%     % if i < 20 || rem(i, 10) == 0 end
%     tic
%     pre_est = agent.estimator.result;
%     agent(1).sensor.do(time, 'f');
%     agent(1).estimator.do(time, 'f');
%     agent(1).reference.do(time, 'f');
%     if conmode == 1; agent(1).controller.do(time, 'f', agent, pre_est);
%     else; agent(1).controller.do(time, 'f', agent);
%     end
%     agent(1).plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     %pause(1)
%     all = toc;
% end
%%
% logger.plot({1, "p", "er"}, {1, "p1-p2", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);
% logger.plot({1,"p","er"}, {1,"v","er"}, {1, "input",""},"xrange", [time.ts, time.t],"fig_num",1,"row_col",[2 2]);
% logger.save("sim_KMPC_test_1014");
% log = logger;
% save(strcat('Data\KMPC_sim_test_1008_sigmoid', '.mat'), 'log');
%%
% app.logger = logger;
% result_plot(app);

%% function 2コンとき
function result = controller_do(varargin)
    controller = varargin{5}.controller; % GUI : varargin{5}
    result.mpc = controller.mpc.do(varargin);
    result.hlc = controller.hlc.do(varargin);
    result = result.mpc;
    varargin{5}.controller.result = result;
end

%%
function dfunc(app)
close all
% app.logger.plot({1, "p1-p2", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "p1-p2-p3", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "w", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "p", "er"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% Graphplot(app)
% app.agent(1).animation(app.logger,"target",1,"opt_plot",[]);

flg.figtype = 0; % 0:subplot
flg.savefig = 0;
flg.animation_save = 0;
flg.animation = 0;
flg.timerange = 1;
flg.plotmode = 2; % 1:inner_input, 2:xy, 3:xyz
filename = string(datetime('now'), 'yyyy-MM-dd');
fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[],'fignum',[2, 3]));
fig.main_figure();
% app = app.logger, app.fExp の構造体を作ればよい
end

function result_plot(app)
    app.fExp = 1;
    flg.figtype = 0; % 0:subplot
    flg.savefig = 0;
    flg.animation_save = 0;
    flg.animation = 0;
    flg.timerange = 0;
    flg.plotmode = 1; % 1:inner_input, 2:xy, 3:xyz
    filename = string(datetime('now'), 'yyyy-MM-dd');
    fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[],'fignum',[2, 3]));
    fig.main_figure();
end