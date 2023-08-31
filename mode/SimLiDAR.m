ts = 0;
dt = 0.01;
te = 100;
time = TIME(ts,dt,te);
% in_prog_func = @(app) in_prog(app);
% post_func = @(app) post(app);
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);
motive = Connector_Natnet_sim(1, dt, 0);              % 3rd arg is a flag for noise (1 : active )
%%
%env = stlread('3F.stl');
  a = 1;
  b = 40;
  c = 30;
  Points = [10 0 0]+[-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c]; 
  Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  env = triangulation(Tri,Points);
  a2 = 10000;
  b2 = 1;
  c2 = 10000;
  Points2 = [0 10 0]+[-a2 -b2 -c2;a2 -b2 -c2;a2 b2 -c2; -a2 b2 -c2;-a2 -b2 c2;a2 -b2 c2;a2 b2 c2; -a2 b2 c2]; 
  Tri2  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  env2 = triangulation(Tri2,Points2);
% 
% Points = [10 0 0; 12 0 0; 10 10 0; 12 10 0; 10 0 20; 12 0 20; 10 10 20; 12 10 20];
% Tri = [1 2 3; 2 3 4; 1 2 6; 1 5 6; 1 3 7; 1 5 7; 3 4 8; 3 7 8; 5 6 8; 5 7 8; 2 4 6; 4 6 8];
% 
% env = triangulation(Tri, Points);
%% 
combinedPoints = [env.Points; env2.Points];
combinedTri = [env.ConnectivityList; env2.ConnectivityList + size(env.Points, 1)];
% combinedEnv = triangulation(combinedTri, combinedPoints);
combinedEnv = env2;
%%
initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
% パラメータ推定時オン
% initial_state.l = [1; 1; 1; 1];
initial_state.ps = [1;1;1];
initial_state.qs = [1; 1;1];

% 野崎設定
wall_param = [0,1,0,-9];
psb = [0.1;0.1;0.1];
qs = [0;0;pi/2];
%%
% default
agent = DRONE;
% agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
% 通常推定時
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));

% パラメータ既知
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),@(x,p) JacobH_12_kiti(x,wall_param,psb,qs,p),"output_func",@(x,p) H_12_kiti(x,wall_param,psb,qs,p),"R",diag([1e-6*ones(1,3), 1e-7*ones(1,3),1e-3*ones(1,1)])));

% オフセット類を状態として追加
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18(x,wall_param,p),"output_func",@(x,p) H_18(x,wall_param,p),"B",[eye(6)*dt^2;eye(6)*dt;zeros(6,6)],"P",diag([ones(1,12),10*ones(1,6)]),"R",diag([1e-8*ones(1,3), 1e-8*ones(1,3),1e-6*ones(1,1)]),"Q",diag([10*ones(1,3),100*ones(1,3)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18_2(x,wall_param,p),"output_func",@(x,p) H_18_2(x,wall_param,p),"B",[eye(6)*dt^2;eye(6)*dt;zeros(6,6)],"P",diag([ones(1,12),10*ones(1,6)]),"R",diag([1e-8*ones(1,3), 1e-8*ones(1,3),1e-7*ones(1,2)]),"Q",diag([10*ones(1,3),100*ones(1,3)])));


agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', combinedEnv, 'R0', Rodrigues([0,0,1],pi/2),'p0',[0.1;0.1;0.1],'theta_range', pi/2, 'phi_range', 0:pi/180:10*pi/180, 'noise',0.000001, 'seed', 0));
% agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', combinedEnv, 'R0', Rodrigues([0,0,1],0),'p0',[0;0;0],'theta_range', pi/2, 'phi_range', 0:pi/180:10*pi/180, 'noise',0.0001, 'seed', 0)); % 2D lidar
agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor.do = @sensor_do;
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1],"size",[0.35,0.5,0.2,0.1]}});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1],"size",[0.5,0.5,0.5,60*pi/180]}});
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1],"size",[0.5,0.5,0.5,0.1]}});
% agent.reference = TIME_VARYING_REFERENCE_EDIT(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[0.2,0.2,0.1]}});
agent.controller = HLC(agent,Controller_HL(dt));


% edited nozaki
% agent = DRONE;
% [M,P]=Model_Discrete(dt,initial_state,1,"PVQ0");
% agent.plant = MODEL_CLASS(agent,M); % control target model
% agent.parameter = P; % set model parameter
% agent.controller = DIRECT_CONTROLLER(agent,dt); 
% % agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,M),["p","q"],"B",[eye(3),zeros(3,3);zeros(3,6);zeros(3,3),eye(3)]));
% % agent.controller = HLC(agent,Controller_HL(dt));
% agent.estimator = DIRECT_ESTIMATOR(agent,struct("model",MODEL_CLASS(agent,M))); % estimator.result.state = sensor.result.state
% % agent.estimator = DIRECT_ESTIMATOR_N(agent,struct("model",MODEL_CLASS(agent,M))); % estimator.result.state = sensor.result.state
% agent.sensor.direct = DIRECT_SENSOR(agent,0.0); % sensor to capture plant position : second arg is noise 
% % agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', env, 'R0', Rodrigues([0,1,0],pi/6),'p0',[0.1;0;0],'theta_range', pi/2, 'phi_range', 0, 'noise',0.005, 'seed', 0)); % 2D lidar
% % agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', env, 'R0', Rodrigues([0,0,1],pi/20),'p0',[0.1;0.05;0],'theta_range', pi/2, 'phi_range', 0:pi/180:10*pi/180, 'noise',0.01, 'seed', 0)); % 2D lidar
% agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', combinedEnv, 'R0', Rodrigues([0,0,1],pi/20),'p0',[0.1;0.05;0],'theta_range', pi/2, 'phi_range', 0:pi/180:10*pi/180, 'noise',0.0001, 'seed', 0)); % 2D lidar
% agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.sensor.do = @sensor_do; % synthesis of sensors
% % agent.reference = TIME_VARYING_REFERENCE_EDIT(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[3,3.5,2]}});
% agent.reference = TIME_VARYING_REFERENCE_EDIT(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[0.2,0.2,0.1]}});
% % agent.reference = TIME_VARYING_REFERENCE_EDIT(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;0],"size",[0,0,0]}});
% function sharedpq = initializepq()
%     sharedpq = 42;
% end

function result = sensor_do(varargin)
sensor = varargin{5}.sensor;
result = sensor.lidar.do(varargin);
result = merge_result(result,sensor.motive.do(varargin));
varargin{5}.sensor.result = result;
end

% function in_prog(app)
% app.agent.show(["sensor", "lidar"], "ax", app.UIAxes,"k",app.time.k,"logger",app.logger, "param",struct("fLocal", false,"fField",true));
% end
% function post(app)
% app.agent.animation(app.logger,"ax", app.UIAxes,"self",app.agent, "target", 1, "opt_plot", ["sensor", "lidar"], "param",struct("fLocal", false,"fField",true));
% end

function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end