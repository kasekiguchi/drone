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

%% 20回まとめてシミュレーションする
clear; close all;
for j = 1:150
    fprintf('Simulation start...');
    ts = 0; % initial time
    dt = 0.025; % sampling period
    te = 40; % terminal time
    time = TIME(ts,dt,te); % instance of time class
    in_prog_func = @(app) dfunc(app); % in progress plot
    post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
    motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
    logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
    initial_state.p = arranged_position([0, 0], 1, 1, 1);
    initial_state.q = [1; 0; 0; 0];
    initial_state.v = [0; 0; 0];
    initial_state.w = [0; 0; 0];

    agent = DRONE;
    agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.58);
    agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)); % Model_Quat13
    agent.parameter.set("mass",struct("mass",0.5))
    agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
    agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき

    % agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
    % agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref(te,readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));%引数に指定しているシートを使うときは位置3を1にする
    % agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});

    % (te, reference保存したファイル名, スプライン補間の次元, ポイントを設定するか, 図を表示するか)
    % agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref_koma2(te,"exp_ref.mat",5,1,0,j));

    num = j;
    reference_file = strcat("Exp_2_4_", num2str(num));
    agent.reference = REFERENCE_FROM_MAT(agent,reference_file);
    agent.controller = HLC(agent,Controller_HL(dt));
    run("ExpBase");

    for i = 1:te/dt
        if i < 20 || rem(i, 10) == 0 end
        tic
        agent(1).sensor.do(time, 'f');
        agent(1).estimator.do(time, 'f');
        agent(1).reference.do(time, 'f');
        agent(1).controller.do(time, 'f');
        agent(1).plant.do(time, 'f');
        logger.logging(time, 'f', agent);
        time.t = time.t + time.dt;
        % disp(['N:', num2str(j), '___','t:', num2str(time.t)]);
        %pause(1)
        all = toc;
    end
    % logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);
    disp(['N: ', num2str(j)]);
    log = logger;
    save(strcat('Data\HLsim\HL_exp_', num2str(j), '.mat'), 'log');
end

%%
% ts = 0; % initial time
% dt = 0.025; % sampling period
% te = 30; % terminal time
% time = TIME(ts,dt,te); % instance of time class
% in_prog_func = @(app) dfunc(app); % in progress plot
% post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
% motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
% logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
% initial_state.p = arranged_position([0, 0], 1, 1, 1);
% initial_state.q = [1; 0; 0; 0];
% initial_state.v = [0; 0; 0];
% initial_state.w = [0; 0; 0];
% 
% agent = DRONE;
% agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.58);
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
% agent.parameter.set("mass",struct("mass",0.5))
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
% % agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% % agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
% % agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref(te,readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));%引数に指定しているシートを使うときは位置3を1にする
% % agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});
% 
% % (te, reference保存したファイル名, スプライン補間の次元, ポイントを設定するか, 図を表示するか)
% % agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref_koma2(te,"exp_ref.mat",5,1,0,j));
% 
% reference_file = "Exp_2_4_108";
% agent.reference = REFERENCE_FROM_MAT(agent,reference_file);
% 
% agent.controller = HLC(agent,Controller_HL(dt)); % HL
% % agent.controller = FUNCTIONAL_HLC(agent,Controller_FHL(dt)); %FHL
% run("ExpBase");
% 
% %%
% for i = 1:te/dt
%     if i < 20 || rem(i, 10) == 0 end
%     tic
%     agent(1).sensor.do(time, 'f');
%     agent(1).estimator.do(time, 'f');
%     agent(1).reference.do(time, 'f');
%     agent(1).controller.do(time, 'f');
%     agent(1).plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     %pause(1)
%     all = toc
% end
% 
% %%
% logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);


%%
% function dfunc(app)
% app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% 
% % figure(100);
% % logt = app.logger.Data.t(1:find(app.logger.Data.t(2:end)==0, 1, 'first'));
% % plot(logt(1:end-1), diff(app.logger.Data.t(1:length(logt))), 'LineWidth', 1.5);
% % xlabel("Time [s]"); ylabel("Calculation time [s]");
% 
% % animation
% % app.agent(1).animation(app.logger,"target",1,"opt_plot",[]); 
% end