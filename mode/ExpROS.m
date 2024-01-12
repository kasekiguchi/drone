% clc;
% clear all
% disp("clear node");

% mega rover
ts = 0; % initial time
dt = 0.25; % sampling period
te = 200; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]);

initial_state.p = [0;0;0];
initial_state.q = [0;0;0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = WHILL;
agent.plant = WHILL_EXP_MODEL(agent,Model_Whill_Exp(dt, initial_state, "ros2", 23));%agentでnodeを所持
agent.parameter = VEHICLE_PARAM("VEHICLE3");
agent.sensor = ROS2_SENSOR(agent, Sensor_ROS2(agent));
agent.estimator = KF_rover(agent,Estimator_KF_rover(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1))));
agent.reference = POINT_REFERENCE(agent,[0.3;0.;0],[0;0;0],[0;0;0]);
agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));
% agent.plant = WHILL_EXP_MODEL(agent,Model_Whill_Exp(dt, initial_state, "ros",25));
% agent.sensor = ROS(agent, Sensor_ROS(struct('DomainID',25)));
% agent.sensor = ROS2_LiDAR_PCD(agent, Sensor_LiDAR_ROS2(Expnode));
% agent.sensor = ROS2_SENSOR(agent, Sensor_Ros2_multi(agent));
% agent.estimator = UKF2DSLAM(agent, Estimator_UKF2DSLAM_Vehicle(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1)), ["p", "q"]));
% agent.estimator = EKF(agent,Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1))));
% agent.estimator = NDT(agent,Estimator_NDT(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1)),'experimentroom_map4'));
% agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent.sensor.lrf.radius));
% agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0;0;0]}});
% agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));

run("ExpBase");

%%
clc
% for i = 1:time.te
% %    if i < 20 || rem(i, 10) == 0, i, end
    % agent(1).sensor.do(time, 'f');
%     agent(1).estimator.do(time, 'f');
%     agent(1).reference.do(time, 'f');
%     agent(1).controller.do(time, 'f',0,0,agent,1);
%     agent(1).plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     %pause(1)
% end
% for i = 1:time.te
%    % if i < 20 || rem(i, 10) == 0, i, end
%     agent.sensor.do(time);
%     agent.estimator.do(time);
%     agent.reference.do(time,'f');
%     agent.controller.do(time,'f');
%     agent.plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     % disp(agent.estimator.result.state.p);
%     % pause(1)
% end
%%
% 
% for j = 1:100
%     px(j) = logger.Data.agent.estimator.result{1,j}.state.p(1,1);
%     py(j) = logger.Data.agent.estimator.result{1,j}.state.p(2,1);
% end
% figure
% plot(px,py,"-*");
% clear px & py
%%

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end
