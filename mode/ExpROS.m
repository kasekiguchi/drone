clc
% mega rover
ts = 0; % initial time
dt = 0.025; % sampling period
te = 100; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);   
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]);

initial_state.p = [0;0;0];
initial_state.q = [0;0;0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = WHILL;
agent.id = 25;
agent.node = ros2node("/matnode",agent.id);
agent.plant = WHILL_EXP_MODEL(agent,Model_Whill_Exp(dt, initial_state, "ros", 25));
agent.parameter = VEHICLE_PARAM("VEHICLE3");
% agent.sensor = ROS(agent, Sensor_ROS(struct('DomainID',25)));
agent.sensor = ROS2_LiDAR_PCD(agent, Sensor_LiDAR_ROS2(["ros" agent.id]));
%agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.estimator = UKF2DSLAM(agent, Estimator_UKF2DSLAM_Vehicle(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1)), ["p", "q"]));
agent.estimator = NDT(agent,Estimator_NDT(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1)),'floor_map'));
% agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent.sensor.lrf.radius));
% agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent));
% agent.reference = STRAIGHT(agent,Reference_PathCenter(agent));
agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));

run("ExpBase");

%%
clc
% for i = 1:time.te
% %    if i < 20 || rem(i, 10) == 0, i, end
%     agent(1).sensor.do(time, 'f');
%     agent(1).estimator.do(time, 'f');
%     agent(1).reference.do(time, 'f');
%     agent(1).controller.do(time, 'f',0,0,agent,1);
%     agent(1).plant.do(time, 'f');
%     logger.logging(time, 'f', agent);
%     time.t = time.t + time.dt;
%     %pause(1)
% end
for i = 1:time.te
%    if i < 20 || rem(i, 10) == 0, i, end
    agent.sensor.do(time);
    agent.estimator.do(time);
    % agent.reference.do(time);
    % agent.controller.do(time,0,0,agent,1);
    agent.plant.do(time, 'f');
    logger.logging(time, 'f', agent);
    time.t = time.t + time.dt;
    %pause(1)
end



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