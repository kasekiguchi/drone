ts = 0; % initial time
dt = 0.025; % sampling period
te = 45; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
N = 2;
motive = Connector_Natnet_sim(N, dt, 0); % imitation of Motive camera (motion capture system)

logger = LOGGER(1:N, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
%env = DENSITY_MAP(Env_2DCoverage);
% arranged_pos(1) = arranged_position([0, 0], 1, 1, 0); %arranged_position.mで関数定義
% arranged_pos(2) = arranged_position([3, 3], 2, 1, 0); %arranged_position.mで関数定義
for i = 1:N
    %initial_state(i).p = arranged_pos(:, i); % set initial position
    %初期位置は完成　しっかりそれぞれの初期位置を変更できた
    if i == 1
        initial_state(i).p = arranged_position([0, 0], 1, 1, 0);
    else
        initial_state(i).p = arranged_position([2, 2], 1, 1, 0);
    end
    %
    initial_state(i).q = [1; 0; 0; 0];
    initial_state(i).v = [0; 0; 0];
    initial_state(i).w = [0; 0; 0];
    %[M,P] = Model_Discrete(dt,initial_state(i),1,"PV") %これ居るかわからん
    agent(i) = DRONE; %ドローンの描画に関するもの？DRONE.mで関数定義
    agent(i).id = i;
    agent(i).parameter = DRONE_PARAM("DIATONE"); %ドローンの物理パラメータ DRONE_PARAM.mで関数定義
    agent(i).plant = MODEL_CLASS(agent(i),Model_Quat13(dt, initial_state(i), i)); %ドローンの状態を更新している MODEL_CLASS.mで定義
%外乱を与える==========
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
% agent.input_transform = ADDING_DISTURBANCE(agent,InputTransform_Disturbance_drone(time)); % 外乱付与
%=====================
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_EulerAngle(dt, initial_state(i), i)),["p", "q"]));
    agent(i).sensor = MOTIVE(agent(i), Sensor_Motive(i,0, motive));
    % agent(i).reference = TIME_VARYING_REFERENCE(agent(i),{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
    % agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",0,"orig",[0;0;1],"size",[0,0,0]},"HL"});
    if i == 1
    agent(i).reference = TIME_VARYING_REFERENCE(agent(i),{"My_Case_study_trajectory",{[1,1,1]},"HL"});
    % agent(i).reference = TIME_VARYING_REFERENCE(agent(i),{"Case_study_trajectory",{[1,1,1]},"HL"});
    % agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.2;0.2;1.2],"g",[-0.2;0.2;0.8],"h",[-0.2;-0.2;1.2],"j",[0.2;-0.2;0.8],"k",[0;0;1],"m",[-2;2;3]),0});%縦ベクトルで書く,
    else
    agent(i).reference = TIME_VARYING_REFERENCE(agent(i),{"My_Case_study_trajectory_2p",{[1,1,1]},"HL"});
    end
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