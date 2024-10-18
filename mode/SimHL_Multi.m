ts = 0; % initial time
dt = 0.025; % sampling period
te = 45; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
N = 2;
motive = Connector_Natnet_sim(N, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1:N, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
%初期値を各機体ごとに設定
initial_position = {[0,0,0],[2,2,0]};
%目標軌道を各機体ごとに設定（機体同士がぶつからないように中心などずらせるように入力引数を設定するとよい）
refName = {
            {"My_Case_study_trajectory",{[1,1,1]},"HL"},...
            {"gen_ref_saddle",{"freq",13,"orig",[2;2;1],"size",[1,1,0.2]},"HL"}
            };
for i = 1:N
    initial_state(i).p = arranged_position(initial_position{i}(1:2), 1, 1, initial_position{i}(3));
    initial_state(i).q = [1; 0; 0; 0];
    initial_state(i).v = [0; 0; 0];
    initial_state(i).w = [0; 0; 0];
    agent(i) = DRONE; %ドローンの描画に関するもの？DRONE.mで関数定義
    agent(i).id = i;
    agent(i).parameter = DRONE_PARAM("DIATONE"); %ドローンの物理パラメータ DRONE_PARAM.mで関数定義
    agent(i).plant = MODEL_CLASS(agent(i),Model_Quat13(dt, initial_state(i), i)); %ドローンの状態を更新している MODEL_CLASS.mで定義
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_EulerAngle(dt, initial_state(i), i)),["p", "q"]));
    agent(i).sensor = MOTIVE(agent(i), Sensor_Motive(i,0, motive));
    agent(i).reference = TIME_VARYING_REFERENCE(agent(i),refName{i});
    agent(i).controller = HLC(agent(i),Controller_HL(dt));
end
run("ExpBase");
% function dfunc(app)
% app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% end

% function dfunc(app)
% app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% % app.logger.plot({2, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
% end

function dfunc(app)
app.logger.plot({1, "p", "pr"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "p", "pr"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end

% function in_prog(app) % in progress procedure
% app.env.show(app.UIAxes);
% VORONOI_BARYCENTER.show_k(app.logger, app.env,"span",1:app.N,"ax",app.UIAxes,"clear",false);
% end
% function post(app) % post procedure
% app.logger.plot({1, "p", "pr"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({2, "p", "pr"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({3, "p", "pr"},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% %VORONOI_BARYCENTER.draw_movie(app.logger, app.env,1:app.N,app.UIAxes);
% end