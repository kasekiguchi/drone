clc
ts = 0; % initial time
dt = 0.025; % sampling period
te = 10000; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]);

motive = Connector_Natnet('192.168.1.4'); % connect to Motive
motive.getData([], []); % get data from Motive
rigid_ids = [1]; % rigid-body number on Motive
sstate = motive.result.rigid(rigid_ids);
initial_state.p = sstate.p;
initial_state.q = sstate.q;
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
% agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "udp", [1, 253])); %プロポ無線
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial", "COM3")); %プロポ有線 
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)), ["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% masterではth_offset_tlに対応していない可能性
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone_Koopman()); % 推力からスロットルに変換
% 
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});

%% ##############################################################
% model_file = "EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat";
% model_file = 'EstimationResult_2024-05-13_Exp_Kiyama_code04_1.mat';
% model_file = '2024-07-14_Exp_Kiyama_code08_saddle.mat';
% model_file = "2024-08-06_Exp_KiyamaY20_code00_saddle.mat"; % y方向増加
% model_file = "2024-07-14_Exp_KiyamaX20_code00_saddle.mat"; % x方向増加
% model_file = "2024-08-08_Exp_KiyamaY20_Zdecreased20k_code00_saddle.mat"; %y方向増加＋z方向減少
% model_file = "2024-09-11_Exp_Kiyama_code10_saddle.mat";
% model_file = "2024-10-07_Exp_Kiyama_Error_correct_code00_saddle";

%% 2つのコントローラの設定---------------------------------------------------------------------------------------------------
agent.controller.mpc = MPC_CONTROLLER_KOOPMAN_quadprog_experiment(agent,Controller_MPC_Koopman(dt, model_file, agent)); %最適化手法：QP
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.controller.result.input = [0;0;0;0];
agent.controller.do = @controller_do;
%------------------------------------------------------------------------------------------------------------------------

disp(['Select model confirmation: ' + model_file]); % dispはダブルクォーテーションのみ対応
run("ExpBase");

%% function
function result = controller_do(varargin)
tic
    controller = varargin{5}.controller;
    if varargin{2} == 'a'
        result = controller.mpc.do(varargin); % arming: KMPC
    elseif varargin{2} == 't'
        result.mpc = controller.mpc.do(varargin); % 空で回るだけ．takeoffを実際にするのはHL
        result.hlc = controller.hlc.do(varargin); % takeoff: HLとKMPCをどちらも回す
        result = result.hlc; % resultに入れる値がhlcだからHLで入力がはいる
    elseif varargin{2} == 'f'
        result.mpc = controller.mpc.do(varargin); % flight: KMPC
        result.hlc = controller.hlc.do(varargin);
        result = result.mpc;
    elseif varargin{2} == 'l'
        result = controller.hlc.do(varargin); % landing: HL
   end
    varargin{5}.controller.result = result;
    toc
end

function post(app)
close all;
% app.logger.plot({1, "p1-p2-p3", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "w", "e"},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);

% 計算時間の描画
figure(100);
logt = app.logger.Data.t(1:find(app.logger.Data.t(2:end)==0, 1, 'first'));
plot(logt(1:end-1), diff(app.logger.Data.t(1:length(logt))), 'LineWidth', 1.5); hold on;
yline(0.025, 'Color', 'red', 'LineWidth', 1.5); hold off;
Square_coloring(app.logger.Data.t([find(app.logger.Data.phase == 116, 1), find(app.logger.Data.phase == 116, 1, 'last')]),[],[],[],gca); % take off phase
Square_coloring(app.logger.Data.t([find(app.logger.Data.phase == 102, 1), find(app.logger.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca); % flight phase
Square_coloring(app.logger.Data.t([find(app.logger.Data.phase == 108, 1), find(app.logger.Data.phase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],gca); % landing phase
xlabel("Time [s]"); ylabel("Calculation time [s]"); xlim([app.time.ts logt(end-1)])

% animation
% app.agent(1).animation(app.logger,"target",1,"opt_plot",[]); 

% Graphplot(app)
flg.figtype = 0; % 0:subplot
flg.savefig = 0;
flg.animation_save = 0;
flg.animation = 0;
flg.timerange = 1;
flg.plotmode = 1; % 1:inner_input, 2:xy, 3:xyz
filename = string(datetime('now'), 'yyyy-MM-dd');
% fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[]));
% struct('logger',log,'fExp',0),struct('flg',flg,'phase',phase,'filename',filename,'time_idx',time_idx,'yrange',yrange)
% fig.main_figure();
% fig.make_mpc_plot();
% fig.main_animation();
% fig.main_mpc('Koopman', [-1 1; -2 2; 0 1.1]);


%% controller calculation time
% figure(101);
% logt = app.logger.Data.t(find(app.logger.Data.phase(2:end)==97,1,'first'):find(app.logger.Data.phase(2:end)==97, 1, 'last'));
% % controller_time = arrayfun(@(x) app.logger.Data.aegnt.controller.result
% controller_time = cell2mat(arrayfun(@(N) app.logger.Data.agent.controller.result{N}.mpc.calt,...
%                             find(app.logger.Data.phase(2:end)==97,1,'first')+1:find(app.logger.Data.phase(2:end)==97, 1, 'last')+1,'UniformOutput',false));
% plot(logt, controller_time);

%% other parts
disp(['P  ',num2str(diag(app.agent.controller.mpc.weight(1:3,1:3))')])
disp(['Q  ',num2str(diag(app.agent.controller.mpc.weight(4:6,4:6))')])
disp(['V  ',num2str(diag(app.agent.controller.mpc.weight(7:9,7:9))')])
disp(['W  ',num2str(diag(app.agent.controller.mpc.weight(10:12,10:12))')])
disp(['R  ',num2str(diag(app.agent.controller.mpc.weightR)')])
end

% GUI上に現在位置（推定値）を表示する
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end