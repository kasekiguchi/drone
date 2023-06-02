%agent.plant = ["Model_Quat13"];
% agent.model = ["Model_EulerAngle"];
% agent.sensor = ["Sensor_Motive"];
% agent.estimator = ["Estimator_EKF"];
% agent.reference = ["Reference_Time_Varying"];
% agent.controller = ["Controller_HL"];
fExp = 0; % 1: experiment   0: numerical simulation
flag.fMotive = 0; % 1: active
flag.fOffline = 0; % 1: active : offline verification with saved data
flag.fDebug = 1; % 1: active : for debug function
ts = 0;
dt = 0.025;
te = 5;
time = TIME(ts,dt,te);
motive = Connector_Natnet_sim(1, dt, 0);              % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1, size(ts:dt:te, 2), fExp, [],[]);

initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE(Model_Quat13(dt, initial_state, 1), DRONE_PARAM("DIATONE"));
agent.set_model(Model_EulerAngle(dt, initial_state, 1), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % オイラー角モデル

agent.set_property("sensor", Sensor_Motive(1,0, motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
agent.set_property("estimator", Estimator_EKF(agent, ["p", "q"]));                                                                    % （剛体ベース）EKF
agent.set_property("reference",Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]})); % 時変な目標状態
%agent.set_property("reference", Reference_Point_FH());                                                                                   % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
agent.set_property("controller", Controller_HL(dt));                                                                                     % 階層型線形化

