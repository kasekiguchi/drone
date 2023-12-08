ts = 0; % initial time
dt = 0.025; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([0, 0], 1, 1, 1);% [x, y], 機数，1, z (初期位置)
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

%------Modelがroll_pitch_yaw_thrust_force_physical_parameter_modelか確認-------------------
agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));

% agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});
agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[1;1;1],"g",[0;0;1]),5});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0;1;1],"g",[0;-1;1],"h",[0;1;1],"j",[0;-1;1]),5});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[1,1,0.5]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",0,"orig",[0;0;1],"size",[0,0,0]},"HL"});
% agent.reference = MY_WAY_POINT_REFERENCE(agent,generate_spline_curve_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),1));%コマンドでシートを選びたいときは位置2を1にする
%スプラインカーブは5が良い

agent.controller = HLC(agent,Controller_HL(dt));

run("ExpBase");
%% mpcと同時

% agent.controller.hlc = HLC(agent,Controller_HL(dt));
% agent.controller.mpc = MPC_CONTROLLER_KOOPMAN_quadprog(agent,Controller_MPC_Koopman(agent)); %最適化手法：QP
% agent.controller.result.input = [0;0;0;0];
% agent.controller.do = @controller_do;
% run("ExpBase");
% 
% function result = controller_do(varargin)
%     controller = varargin{5}.controller;
%     result = controller.hlc.do(varargin{1});
%     result.mpc = controller.mpc.do(varargin{1});
%     varargin{5}.controller.result = result;
% end
% % 

function dfunc(app)
% app.logger.plot({1, "p1-p2", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "p1-p2-p3", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end