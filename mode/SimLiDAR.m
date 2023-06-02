ts = 0;
dt = 0.025;
te = 10;
time = TIME(ts,dt,te);
debug_func = @(app) dfunc(app);
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);
motive = Connector_Natnet_sim(1, dt, 0);              % 3rd arg is a flag for noise (1 : active )

% env = stlread('3F.stl');
  a = 1;
  b = 2;
  c = 3;
  Points = [4 0 0]+[-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c]; 
  Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  env = triangulation(Tri,Points);

initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
agent = DRONE(Model_Quat13(dt, initial_state, 1), DRONE_PARAM("DIATONE"));
agent.set_model(Model_EulerAngle(dt, initial_state, 1), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % オイラー角モデル
agent.set_property("sensor", Sensor_LiDAR3D(1, 'env', env, 'theta_range', pi / 2, 'phi_range', -pi:0.1:pi, 'noise', 3.0E-2, 'seed', 3)); % 2D lidar
agent.set_property("sensor", Sensor_Motive(1,0, motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
agent.set_property("estimator", Estimator_EKF(agent, ["p", "q"]));                                                                    % （剛体ベース）EKF
agent.set_property("reference",Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]})); % 時変な目標状態
%agent.set_property("reference", Reference_Point_FH());                                                                                   % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
agent.set_property("controller", Controller_HL(dt));                                                                                     % 階層型線形化

function dfunc(app)
app.logger.plot({1, "p", "er"},"FH",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
end