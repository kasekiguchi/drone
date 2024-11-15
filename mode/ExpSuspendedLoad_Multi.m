%todo
% ==内の部分を修正
% 牽引のみでできるようにtakeoffの方法を変更する
%=推定方法を変える場合==========================================================================
%-拡張質量システム：
% Model_Suspended_Load(dt,initial,id,agent,isEstLoadMass):isEstLoadMass=1
% agent.controller = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dt,agent));
%=============================================================================================
ts = 0; % initial time　開始時間
dt = 0.025; % sampling period　サンプリング間隔
te = 10000; % termina time　終了時間
time = TIME(ts,dt,te); %上の3つの時間をまとめる．
in_prog_func = @(app) in_prog(app); %43行目にある
post_func = @(app) post(app); %35行目にある
% N = 2;

motive = Connector_Natnet('192.168.1.4'); % connect to Motive　実験室モーションキャプチャのIP
% motive = Connector_Natnet('192.168.120.4'); % connect to Motive　総研モーションキャプチャのIP
motive.getData([], []); % get data from Motive モーションキャプチャからのデータを入手する
N = motive.result.rigid_num/2;%機体と牽引物の組数
COMs = [5,12];%割り当てる順番に設定
refName = {
            {"My_Case_study_trajectory",{[1,1,1]},"HL"},...
            {"My_Case_study_trajectory",{[-1,-1,1]},"HL"}
            % {"gen_ref_saddle",{"freq",13,"orig",[2;2;1],"size",[1,1,0.2]},"HL"}
            };
refPointName= {
                 {struct("f",[1;1;1],"g",[0;1;1],"h",[-1;1;1],"j",[-1;0;1],"k",[-1;-1;1]),8},...
                 {struct("f",[-1;-1;1],"g",[0;-1;1],"h",[1;-1;1],"j",[1;0;1],"k",[1;1;1]),8}
                 };
logger = LOGGER(1:N, size(ts:dt:te, 2), 1, [],[]); %データをまとめている？

for i = 1:N
sstate = motive.result.rigid(i); %状態の取得？
initial_state.p = sstate.p; %初期位置の取得
initial_state.q = sstate.q; %初期角度の取得
eul = Quat2Eul(initial_state.q);
initial_state.v = [0; 0; 0]; %初期速度の取得
initial_state.w = [0; 0; 0]; %初期角加速度の取得

agent(i) = DRONE; %対象をドローンにしている？ DRONE.m
agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
agent(i).plant = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state, "serial", COMs(i))); %プロポ有線　プロポとの接続
agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state, i,agent(i))),  ["p", "q", "pL", "pT"]));

%sensor [2*-1,2*i]:機体1，牽引物1,機体2，牽引物2...の順番の場合,[i,i+N]：機体...,牽引物...
%各組ごとにmotiveから全ての剛体情報を持ってきているので重くなる原因になるかも?2組4剛体だったら問題ないと思う．各組毎に剛体情報更新するので精度はいいと思う
agent(i).sensor.motive = MOTIVE(agent(i), Sensor_Motive(2*i-1,eul(3), motive));%機体の情報のクラス，機体のidを入れる
agent(i).sensor.forload = FOR_LOAD(agent(i), Estimator_Suspended_Load(2*i));%牽引物の情報のクラス，牽引物のidを入れる
agent(i).sensor.do = @sensor_do;

agent(i).input_transform = THRUST2THROTTLE_DRONE(agent(i),InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換

% agent(i).reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",12,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
% agent(i).reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15d3'),5,1));
% agent(i).reference = MY_POINT_REFERENCE(agent(i),refPointName{i});%縦ベクトルで書く,
agent(i).reference = TIME_VARYING_REFERENCE(agent(i),refName{i});
% agent(i).reference = TIME_VARYING_REFERENCE_SUSPENDEDLOAD(agent(i),refName{i});
%=======================================================
%通常
agent(i).controller.hlc = HLC(agent(i),Controller_HL(dt));
agent(i).controller.load = HLC_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
agent(i).controller.do = @controller_do;
agent(i).controller.result.input = [(agent(i).parameter.loadmass*0+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
%質量推定
% agent(i).controller = HLC_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
%=======================================================
end
run("ExpBase");

function result = sensor_do(varargin)
    result_motive = varargin{5}.sensor.motive.do(varargin);
    result_forload = varargin{5}.sensor.forload.do(varargin);
    result_forload.state.p =  result_motive.state.p;
    result_forload.state.q =  result_motive.state.q;
    varargin{5}.sensor.result = result_forload;
    result=result_forload;
end
function result = controller_do(varargin)
    controller = varargin{5}.controller;
    result = controller.hlc.do(varargin);
    result = merge_result(result,controller.load.do(varargin));
    varargin{5}.controller.result = result;
end

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
% app.Label_2_2p.Text = ["estimator : " + app.agent(2).estimator.result.state.get()];
end