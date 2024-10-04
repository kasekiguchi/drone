ts = 0; % initial time　開始時間
dt = 0.025; % sampling period　サンプリング間隔
te = 10000; % termina time　終了時間
time = TIME(ts,dt,te); %上の3つの時間をまとめる．
in_prog_func = @(app) in_prog(app); %43行目にある
post_func = @(app) post(app); %35行目にある
N = 2;
logger = LOGGER(1:N, size(ts:dt:te, 2), 1, [],[]); %データをまとめている？

% motive = Connector_Natnet('192.168.1.4'); % connect to Motive　モーションキャプチャのIP
% motive.getData([], []); % get data from Motive モーションキャプチャからのデータを入手する
% rigid_ids = [1]; % rigid-body number on Motive　モーションキャプチャの剛体番号
% sstate = motive.result.rigid(rigid_ids); %状態の取得？
% initial_state.p = sstate.p; %初期位置の取得
% initial_state.q = sstate.q; %初期角度の取得
% initial_state.v = [0; 0; 0]; %初期速度の取得
% initial_state.w = [0; 0; 0]; %初期角加速度の取得
for i = 1:N
motive(i) = Connector_Natnet('192.168.1.4'); % connect to Motive　モーションキャプチャのIP
motive(i).getData([], []); % get data from Motive モーションキャプチャからのデータを入手する
rigid_ids(i) = [i]; % rigid-body number on Motive　モーションキャプチャの剛体番号
sstate(i) = motive.result.rigid(rigid_ids(i)); %状態の取得？
initial_state(i).p = sstate(i).p; %初期位置の取得
initial_state(i).q = sstate(i).q; %初期角度の取得
initial_state(i).v = [0; 0; 0]; %初期速度の取得
initial_state(i).w = [0; 0; 0]; %初期角加速度の取得

agent(i) = DRONE; %対象をドローンにしている？ DRONE.m
if i == 1
% agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "udp", [1, 253]));
agent(i).plant = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state(i), "serial", "5")); %プロポ有線　プロポとの接続
else
agent(i).plant = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state(i), "serial", "8"));
end
agent(i).parameter = DRONE_PARAM("DIATONE");
agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_EulerAngle(dt, initial_state(i), i)), ["p", "q"]));
agent(i).sensor = MOTIVE(agent(i), Sensor_Motive(i,0, motive));
agent(i).input_transform = THRUST2THROTTLE_DRONE(agent(i),InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換

% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",12,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[1;1;1],"g",[0.8;0.7;1],"h",[0.2;0.2;1],"j",[-0.5;0;1],"k",[0.1;-0.2;1],"m",[0.3;-0.4;1]),6});%縦ベクトルで書く,
% agent.reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15d3'),5,1));
if i == 0
 agent(i).reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[0,0,1]},"HL"});
else
 agent(i).reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory_2p",{[0,0,1]},"HL"});
end
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",0,"orig",[0;0;1],"size",[0,0,0]},"HL"});
 agent(i).controller = HLC(agent(i),Controller_HL(dt));
end
run("ExpBase");

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "p", "er"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end