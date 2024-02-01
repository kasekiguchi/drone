ts = 0;
dt = 0.01;
te = 30;
time = TIME(ts,dt,te);
% in_prog_func = @(app) in_prog(app);
% post_func = @(app) post(app);
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);
motive = Connector_Natnet_sim(1, dt, 1);              % 3rd arg is a flag for noise (1 : active )
%%
%env = stlread('3F.stl');
  a = 1;
  b = 40;
  c = 30;
  Points = [10 0 0]+[-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c]; 
  Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  env = triangulation(Tri,Points);
  a2 = 1000000;
  b2 = 1;
  c2 = 1000000;
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
initial_state.ps = [0.1;0.1;0.1];
initial_state.qs = [0; 0;1];
% initial_state.l = [1;1;1;1];

% 野崎設定
wall_param = [0,1,0,-9];

%%
% default
agent = DRONE;
% agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
% 通常推定時
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"],"B",eye(12),"R",diag([1e-5*ones(1,3), 1e-3*ones(1,3)]),"Q",diag([1e-4*ones(1,3),1e-2*ones(1,6),1e-0*ones(1,3)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"],"B",eye(12),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6)])));

% パラメータ既知
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),@(x,p) JacobH_12_kiti(x,wall_param,psb,qs,p),"output_func",@(x,p) H_12_kiti(x,wall_param,psb,qs,p),"R",diag([1e-6*ones(1,3), 1e-7*ones(1,3),1e-3*ones(1,1)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),@(x,p) JacobH_12_2(x,wall_param,[0.01;0.01;0.01],[0;0;pi/2],p),"output_func",@(x,p) H_12_2(x,wall_param,[0.01;0.01;0.01],[0;0;pi/2],p),"B",eye(12),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-8*ones(1,2)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),@(x,p) JacobH_12_1(x,wall_param,[0.01;0.01;0.01],[0;0;pi/2],p),"output_func",@(x,p) H_12_1(x,wall_param,[0.01;0.01;0.01],[0;0;pi/2],p),"B",eye(12),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-9*ones(1,1)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6)])));

% オフセット類を状態として追加
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18(x,wall_param,p),"output_func",@(x,p) H_18(x,wall_param,p),"B",[eye(6)*dt^2;eye(6)*dt;zeros(6,6)],"P",diag([ones(1,12),10*ones(1,6)]),"R",diag([1e-8*ones(1,3), 1e-8*ones(1,3),1e-6*ones(1,1)]),"Q",diag([10*ones(1,3),100*ones(1,3)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18_2(x,wall_param,p),"output_func",@(x,p) H_18_2(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),100*ones(1,6)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-8*ones(1,2)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.00001*ones(1,6)])));
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18_2(x,wall_param,p),"output_func",@(x,p) H_18_2(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),1*ones(1,6)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-8*ones(1,2)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.00001*ones(1,6)])));

%AMC＆修論  これ！！！！！！！！！！
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18(x,wall_param,p),"output_func",@(x,p) H_18(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),1000*ones(1,3),1000*ones(1,3)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),5*1e-8*ones(1,1)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.00002*ones(1,3),0.00002*ones(1,3)])));

% オフセットと壁面パラを状態として追加
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_22(dt, initial_state, 1)),@(x,p) JacobH_22_2(x,p),"output_func",@(x,p) H_22_2(x,p),"B",eye(22),"P",diag([ones(1,12),10*ones(1,6),100*ones(1,4)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-6*ones(1,2)]),"Q",diag([0.001*ones(1,6),0.001*ones(1,6),0.0001*ones(1,6),0.001*ones(1,4)])));
% AMC fail用
% agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18_2(x,wall_param,p),"output_func",@(x,p) H_18_2(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),1*ones(1,3),100*ones(1,3)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-8*ones(1,2)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.0005*ones(1,3),0.001*ones(1,3)])));

%PDAF
% agent.estimator = PDAF(agent, Estimator_PDAF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18_2(x,wall_param,p),"output_func",@(x,p) H_18_2(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),10*ones(1,3),200*ones(1,3)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),1e-8*ones(1,2)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.0001ones(1,3),0.0005*ones(1,3)])));
% agent.estimator = PDAF(agent, Estimator_PDAF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"],"B",eye(12),"R",diag([1e-6*ones(1,3), 1e-6*ones(1,3)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6)])));
%SEKF
% agent.estimator = SEKF(agent, Estimator_SEKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_18(dt, initial_state, 1)),@(x,p) JacobH_18(x,wall_param,p),"output_func",@(x,p) H_18(x,wall_param,p),"B",eye(18),"P",diag([ones(1,12),1000*ones(1,3),1000*ones(1,3)]),"R",diag([1e-3*ones(1,3), 1e-3*ones(1,3),5*1e-8*ones(1,1)]),"Q",diag([0.01*ones(1,6),0.01*ones(1,6),0.00002*ones(1,3),0.00002*ones(1,3)])));


agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', combinedEnv, 'R0', Rodrigues([0,0,1],pi/2),'p0',[0.01;0.01;0.01],'theta_range', pi/2, 'phi_range', 0:pi/180:10*pi/180, 'noise',0.000001, 'seed', 0));
agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor.do = @sensor_do;
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",20,"orig",[0;0;1.5],"size",[1,1,1,0.]}});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",20,"orig",[0;0;1.5],"size",[0.5,0.5,0.5,0.]}});

%AMC ref
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1],"size",[0.5,0.5,0.5,0.4]}});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1.5],"size",[1,1,1,0.35]}});

% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",10,"orig",[0;0;1.5],"size",[2,2,2,0.35]}});

%AMCref
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",5,"orig",[0;0;1],"size",[1.5,1.5,1.5,0.45]}});
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle_yaw",{"freq",20,"orig",[0;0;1.5],"size",[0,0.,0.,0.]}});
% 
% コントローラー
% agent.controller = HLC(agent,Controller_HL(dt));

% コントローラー補正
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.controller.correct = CORRECT_OBSERVABILITY(agent,Controller_CORRECT_OBSERVABILITY(dt,1.0E-9,0.1,"F_RPY18","G_RPY18","On3_1_new"));
agent.controller.do = @controller_do;

%% Direct model
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

% ただノイズを入れた場合の入力補正


function result = sensor_do(varargin)
    sensor = varargin{5}.sensor;
    result = sensor.lidar.do(varargin);
    result = merge_result(result,sensor.motive.do(varargin));
    varargin{5}.sensor.result = result;
end



% ノイズを入れた場合の入力補正
% function result = controller_do(varargin)
%     controller = varargin{5}.controller;
%     result.hlc = controller.hlc.do(varargin);
%     varargin{5}.controller.result.input = result.hlc.input + 0.4 * randn(4,1);
% end


% 可観測性に基づく入力補正用
function result = controller_do(varargin)
    controller = varargin{5}.controller;
    result.hlc = controller.hlc.do(varargin);
    result.correct = controller.correct.do(varargin);
%     varargin{5}.controller.result.input = result.hlc.input + result.correct.input;
    [correct,parallel]= vector_decomposition(result.hlc.input,result.correct.input);
    varargin{5}.controller.result.input = result.hlc.input + correct;
end


% ベクトルの分解
function [vertical,parallel] = vector_decomposition(A,B)
    parallel = dot(A,B)/norm(A)^2 * A;
    vertical = B - parallel; 
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