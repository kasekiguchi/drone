% 実機実験で使用するプログラム
ts = 0; % initial time %実機実験の初期時刻
dt = 0.025; % sampling period %サンプリング時間　制御周期のこと？
te = 10000; % termina time %最終時刻　これ以上プログラムは動かせない？
time = TIME(ts,dt,te); %上3つの関数をまとめている
in_prog_func = @(app) in_prog(app); %ExpHL下部でin_prog(app)が定義　緊急時に中央画面左上にテキストを表示
post_func = @(app) post(app); %ExpHL下部でpost(app)が定義　GUI画面に表示される結果の表示するものを定義している
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]); %LOGGER.mで定義　フライトデータの記録と保存　現在調査中

motive = Connector_Natnet('192.168.1.2'); % connect to Motive motiveのIPアドレス
motive.getData([], []); % get data from Motive　motiveからデータを持ってきている
rigid_ids = [1]; % rigid-body number on Motive　motiveで定義された機体の剛体番号
sstate = motive.result.rigid(rigid_ids); %剛体番号(rigid_ids)の状態
initial_state.p = sstate.p; %剛体の初期位置[m] motiveから情報を取ってきている
initial_state.q = sstate.q; %剛体の初期角度[rad]　motiveから情報を取ってきている
initial_state.v = [0; 0; 0]; %剛体の初期速度[m/s]　固定
initial_state.w = [0; 0; 0]; %剛体の初期角速度[rad/s] 固定

agent = DRONE; %DRONE.mで定義されている　制御対象を定義　複雑なので後で見る
% agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state,"udp", [1, 252])); udp（無線）の時に使用
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial", "COM16")); %有線の時に使用　
% DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial", "プロポのCOM番号(デバイスマネージャで確認"))　後で見る
agent.parameter = DRONE_PARAM("DIATONE"); %ドローンのパラメータ　後で見る
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)), ["p", "q"]));
% 拡張カルマンフィルタ　motiveの情報を加工する　後で見る
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive)); %motiveの取得した情報　後で見る
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
%後で見る

agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[1,1,0]},"HL"});
%目標軌道　後で見る　これはサドル軌道
agent.controller = HLC(agent,Controller_HL(dt));
%コントローラの定義　HL(階層型線形化)　後で見る

run("ExpBase");

function post(app) %4つのグラフに表示されるものを定義
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "出力するグラフ", "データの種類"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% 出力するグラフ p:位置[m] q:姿勢角[rad] v:速度[m/s] w:角速度[rad/s] p1-p2:x-yグラフ
% p1-p2-p3:x-y-zグラフ input:入力(4つのプロペラの合計推力，トルク(ロール，ピッチ，ヨー))[N]
% データの種類 s:sensor e:estimator r:reference p:plant(simulation時のみ)
end
function in_prog(app) %緊急時のテキスト表示を定義
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end