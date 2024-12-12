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
rigid_num = motive.result.rigid_num;%けん引物もある場合は工夫する必要あり

%各pcが担当する単機牽引の数と使用する剛体のrigidIdの計算
numberOFpc = 2;%pcの総数
PCId = 1;%pcの番号
NdroneAndLoad = rigid_num;%round(rigid_num/2);%機体と分割後の牽引物の組数
s = NdroneAndLoad -1*mod(rigid_num,2);%牽引物の分を引く(複数牽引でなかったら引かない)
r = mod(s,numberOFpc);
sParPc = (s-r)/numberOFpc;%各PCでいくつの組を制御するか
Ns = ones(1,numberOFpc)*sParPc + [ones(1,r),zeros(1,numberOFpc-r)];%各PCで制御する組を決定
N = Ns(PCId)+1*mod(rigid_num,2);%(複数牽引でなかったら足さない)
addIds = zeros(1,length(Ns));%機体と分割後の牽引物分+牽引物分ずらしていく
for i = 1:length(Ns)-1
    addIds(i+1) = sum(Ns(1:i),2)+1*mod(rigid_num,2);
end
addId = addIds(PCId);%このpcで加算するrigidのid

COMs = string([6,10]);%割り当てる順番に設定
refName = {
            {"My_Case_study_trajectory",{[1,1,1]},"HL"},...
            {"My_Case_study_trajectory",{[-1,-1,1]},"HL"}
            % {"gen_ref_saddle",{"freq",13,"orig",[2;2;1],"size",[1,1,0.2]},"HL"}
            };
refPointName= {
                 {struct("f",[1.5;1.5;0.5],"g",[0;1.5;0.5],"h",[-1.5;1.5;0.5],"j",[-1.5;0;0.5],"k",[-1.5;-1.5;0.5]),8},...
                 {struct("f",[-1.5;1.5;0.5],"g",[-1.5;0;0.5],"h",[-1.5;-1.5;0.5],"j",[0;-1.5;0.5],"k",[1.5;-1.5;0.5]),8}
                 % {struct("f",[-1.5;-1.5;0.5],"g",[0;-1.5;0.5],"h",[1.5;-1.5;0.5],"j",[1.5;0;0.5],"k",[1.5;1.5;0.5]),8},...
                 % {struct("f",[1.5;-1.5;0.5],"g",[1.5;0;0.5],"h",[1.5;1.5;0.5],"j",[0;1.5;0.5],"k",[-1.5;1.5;0.5]),8}
                 };
logger = LOGGER(1:N, size(ts:dt:te, 2), 1, [],[]); %データをまとめている？

for i = 1:N
sstate = motive.result.rigid(i+addId); %状態の取得？
% sstate = motive.result.rigid(i); %状態の取得？
initial_state.p = sstate.p; %初期位置の取得
initial_state.q = sstate.q; %初期角度の取得
eul = Quat2Eul(initial_state.q);
initial_state.v = [0; 0; 0]; %初期速度の取得
initial_state.w = [0; 0; 0]; %初期角加速度の取得

agent(i) = DRONE; %対象をドローンにしている？ DRONE.m
agent(i).parameter = DRONE_PARAM("DIATONE");
agent(i).plant = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state, "serial", COMs(i))); %プロポ有線　プロポとの接続
agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_EulerAngle(dt, initial_state, i)), ["p", "q"]));
agent(i).sensor = MOTIVE(agent(i), Sensor_Motive(i+addId,eul(3)*0, motive));
% agent(i).sensor = MOTIVE(agent(i), Sensor_Motive(i,eul(3)*0, motive));
agent(i).input_transform = THRUST2THROTTLE_DRONE(agent(i),InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換

% agent(i).reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",12,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
% agent(i).reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15d3'),5,1));
agent(i).reference = MY_POINT_REFERENCE(agent(i),refPointName{i});%縦ベクトルで書く,
% agent(i).reference = TIME_VARYING_REFERENCE(agent(i),refName{i});
agent(i).controller = HLC(agent(i),Controller_HL(dt));
end
run("ExpBase");

function post(app)
app.logger.plot({1, "p", "ers"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "p", "ers"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
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