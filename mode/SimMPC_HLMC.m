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
%%
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
% initial_state.q = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor = DIRECT_SENSOR(agent, 0.0); % modeファイル内で回すとき
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0;0;0.4]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0;1],"g",[1;0.5;1]),2}); 百瀬ref
% agent.controller = MPC_CONTROLLER_HLMC(agent, Controller_MPC_HLMC(agent));
% agent.controller = MPC_CONTROLLER_HLMC_HL(agent, Controller_MPC_HLMC_fromN(dt));
agent.controller = MPC_CONTROLLER_HLMC_akanuma(agent, Controller_MPC_HLMC_fromN(dt));
run("SimBase");
%%
for i = 1:te/dt
    if i < 20 || rem(i, 10) == 0; end
    tic
    agent(1).sensor.do(time, 'f');
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    agent(1).controller.do(time, 'f');
    agent(1).plant.do(time, 'f');
    logger.logging(time, 'f', agent);
    time.t = time.t + time.dt;
    %pause(1)
    all = toc;
    % disp([num2str(time.t)])
    agent.controller.show;
end
%%
logger.plot({1, "p", "er"}, {1, "v", "er"}, {1, "q", "e"}, {1, "input", ""},...
    "xrange",[time.ts,time.t],"fig_num",1,"row_col",[2 2]);
% 仮想入力の描画
imgu = cell2mat(arrayfun(@(N) logger.Data.agent.controller.result{N}.input_v, 1:te/dt, 'UniformOutput', false));
figure(10); plot([1:te/dt] .* dt, imgu); legend('z', 'x', 'y', 'yaw');

% eval = cell2mat(arrayfun(@(N) logger.Data.agent.controller.result{N}.Evaluationtra(logger.Data.controller.result{N}.bestcost(1), 1:te/dt, 'UniformOutput', false));
% figure(10); plot([1:te/dt] .* dt, eval); legend('z', 'x', 'y', 'yaw');
%%
function dfunc(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% figtype = 2; % 1:それぞれ, 2:subplot
% savefigure;
flg.figtype = 0; % 0:subplot
flg.savefig = 0;
flg.animation_save = 0;
flg.animation = 0;
flg.timerange = 1;
flg.plotmode = 1; % 1:inner_input, 2:xy, 3:xyz
filename = string(datetime('now'), 'yyyy-MM-dd');
fig = FIGURE_EXP(app,struct('flg',flg,'phase',1,'filename',filename,'time_idx',[],'yrange',[],'fignum',[2, 3]), struct('model', filename));
% struct('logger',log,'fExp',0),struct('flg',flg,'phase',phase,'filename',filename,'time_idx',time_idx,'yrange',yrange)
fig.main_figure();
end