%% modeファイルから実行時に必要 ====================
% clc
% tmp = matlab.desktop.editor.getActive;
% cd(strcat(fileparts(tmp.Filename), '../../'));
% [~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
% cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%% ==================================================

ts = 0; % initial time
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 1); % [x, y], 1, 1, z
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0;0;1]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0;1],"g",[1;0.5;1]),2}); % P2Pを複数回行う
agent.controller = MCMPC_controller(agent, Controller_MCMPC(agent));
run("ExpBase");

%% modeファイル内でプログラムを回す
% for i = 1:400
%     if i < 20 || rem(i, 10) == 0; end
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
%% 途中で止めた時もセクション実行でグラフ出せる
% logger.plot({1, "p", "er"}, {1, "q", "e"}, {1, "v", "er"}, {1, "input", ""},"xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);

%%
function dfunc(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
mojamoja(app); % もじゃもじゃプロット
end