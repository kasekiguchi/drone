%% GUI or Sim
if exist('app') == 1
    modeType = 1;
else
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
    clear;
    modeType = 0;
    mov = 0;
end
%%
ts = 0; % initial time
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) in_prog(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 0.6); % [x, y], 1, 1, z
% initial_state.q = [1; 0; 0; 0];
initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%%
% model_file = '2024-12-23_Exp_Kiyama_code23_saddle_increased_weight10.mat';
% model_file = '2025-01-12_Exp_Kiyama_code00_saddle_increased.mat';
% model_file = '2025-02-12_Exp_Kato25_code00_saddle'; % kiyama+kato25 =
% 300data
% model_file = '2025-02-12_Exp_Kato15_code00_saddle'; % kato25=150data
% model_file = '2025-02-14_Exp_Kato15_code00_saddle_increased';
model_file = '2025-02-21_Exp_Kiyama_code00_saddle_1';

%%
agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

if modeType; agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive)); % guiから回すとき
else;         agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
end

agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0;0;0.6]},"HL"});
agent.controller = MPC_CONTROLLER_KMC(agent, Controller_MPC_KMC(dt, model_file, agent));
run("SimBase");
%%
if ~modeType
    phase = 'f'
    for i = 1:te/dt
        if i < 20 || rem(i, 10) == 0; end
        tic
        agent(1).sensor.do(time, phase);
        agent(1).estimator.do(time, phase);
        agent(1).reference.do(time, phase);
        agent(1).controller.do(time, phase);
        agent(1).plant.do(time, phase);
        logger.logging(time, phase, agent);
        time.t = time.t + time.dt;
        %pause(1)
        all = toc
        % disp([num2str(time.t)])
        agent.controller.show;
        if agent.estimator.result.state.p(3) < 0 || ...
                any(abs(agent.estimator.result.state.p) > 4)
            break;
        end
    end
    %% plot
    close all
    f = draw(logger, time, dt); pause(1);
    if mov == 1
        fprintf('Animation drawing starts\n');
        tic;
        gui.logger = logger;
        P = Controller_MPC_KMC(dt, model_file, agent);
        mojamoja(gui, P, 'xy')
        dcal = toc;
        fprintf('Animation drawing time : %f s \n', dcal);
    end
    
end

%%
function f = draw(logger, time, dt)
    f(1) = figure(1);
    m = 3; n=3;
    %% データ取得
    cost = cell2mat(arrayfun(@(N) logger.Data.agent.controller.result{N}.bestcost(1), 1:round(time.t/dt),'UniformOutput',false));
    tt = logger.data(0,"t",[]);
    pe = logger.data(1,"p","e")'; ve = logger.data(1,"v","e")';
    pr = logger.data(1,"p","r")'; vr = logger.data(1,"v","r")';
    qe = logger.data(1,"q","e")'; 
    we = logger.data(1,"w","e")';
    input = logger.data(1,"input",[])';

    %% 平均値算出(input)
    input_ave = mean(input,2);

    %% 状態
    subplot(m,n,1); plot(tt, pe, "-", tt, pr, "--"); xlabel('Time [s]', 'Fontsize', 15); ylabel('Position [m]', 'Fontsize', 15); grid on;
    subplot(m,n,3); plot(tt, ve, "-", tt, vr, "--"); xlabel('Time [s]', 'Fontsize', 15); ylabel('Velocity [m/s]', 'Fontsize', 15); grid on;
    subplot(m,n,2); plot(tt, qe, "-"); xlabel('Time [s]', 'Fontsize', 15); ylabel('Angle [rad]', 'Fontsize', 15); grid on;
    subplot(m,n,4); plot(tt, we, "-"); xlabel('Time [s]', 'Fontsize', 15); ylabel('Angular velocity [rad/s]', 'Fontsize', 15); grid on;
    %% 入力
    subplot(m,n,5); plot(tt, input(1,:), tt, repmat(input_ave(1),1,length(tt))); xlabel('Time [s]', 'Fontsize', 15); ylabel('Thrust [N]', 'Fontsize', 15); grid on;
    subplot(m,n,6); plot(tt, input(2:4,:), tt, repmat(input_ave(2:4),1,length(tt))); xlabel('Time [s]', 'Fontsize', 15); ylabel('Torque [N]', 'Fontsize', 15); grid on;
    %% 評価値
    subplot(m,n,7); plot(tt(1:length(cost)), cost); xlabel('Time [s]', 'Fontsize', 15); ylabel('Evaluation', 'Fontsize', 15); grid on;
end

%%
% function dfunc(app)
% app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% % figtype = 2; % 1:それぞれ, 2:subplot
% % savefigure;
% flg.figtype = 0; % 0:subplot
% flg.savefig = 0;
% flg.animation_save = 0;
% flg.animation = 0;
% flg.timerange = 1;
% flg.plotmode = 1; % 1:inner_input, 2:xy, 3:xyz
% filename = string(datetime('now'), 'yyyy-MM-dd');
% fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[],'fignum',[2, 3]), struct('model', filename));
% % struct('logger',log,'fExp',0),struct('flg',flg,'phase',phase,'filename',filename,'time_idx',time_idx,'yrange',yrange)
% fig.main_figure();
% 
% param = app.agent.controller.param;
% P = Controller_MPC_KMC(param.dt_drone, param.Kmodel, app.agent); mojamoja(app, P, 'xz');
% end
% 
% function in_prog(app)
% est = app.agent.estimator.result.state.get();
% ref = app.agent.reference.result.state.get();
% fprintf('est: %f, %f, %f \n', est(1), est(2), est(3));
% fprintf('ref: %f, %f, %f \n', ref(1), ref(2), ref(3));
% end