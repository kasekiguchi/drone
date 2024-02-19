str="mainGUI";
if exist('app')==7;clc;clear;close all;str="mode file only";end
disp("run mode:"+str)
ts = 0; % initial time
dt = 0.5; % sampling period
te = 180; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]);

% motive = Connector_Natnet('192.168.1.2'); % connect to Motive
% motive.getData([], []); % get data from Motive

% initial position in point cloud map
initial_state.p = [0;0;0];
initial_state.q = [0;0;0];
% initial_state.v = [0; 0; 0];
% initial_state.w = [0; 0; 0];

agent = WHILL;
agent.plant = WHILL_EXP_MODEL(agent,Model_Whill_Exp(dt, initial_state, "ros2", 87));%agentでnodeを所持 
agent.parameter = VEHICLE_PARAM("VEHICLE3");
% agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.sensor.ros = ROS2_SENSOR(agent, Sensor_Ros2_multi(agent));
% agent.sensor.do = @sensor_do; % synthesis of sensors
% agent.sensor.do([],[],[],[],agent,1);
agent.sensor = ROS2_SENSOR(agent,Sensor_Ros2_bos_rover(agent));%ROS2_SENSOR単体の時
agent.sensor.do();%ROS2_SENSOR単体の時
% agent.estimator = UKF2DSLAM(agent, Estimator_UKF2DSLAM_Vehicle(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1)), ["p", "q"]));
% agent.estimator = NDT(agent,Estimator_NDT(agent,dt,MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1))));%, ["p", "q"]));
agent.estimator = NDT(agent,Estimator_NDT(agent,dt,MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state,1))));
% agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent.sensor.lrf.radius));
% agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(40));agent.reference.do(time, 'f');
% agent.reference = POINT_REFERENCE(agent,[2.0;0;0],[0;0;0],[0;0;0]);
agent.reference = POINT_REFERENCE(agent,Reference_Point(agent,2));
agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));
run("ExpBase");
%% main loop of running modefile only
if str == "mode file only"
% i=1;
while (time.t < time.te)
    tStart = tic;
    agent.sensor.do(time,'f',0,0,agent,1);
    % motive.getData(agent);
    agent.estimator.do(time);
    agent.reference.do(time,'f');
    agent.controller.do(time,'f');
    agent.plant.do(time, 'f');
    logger.logging(time, 'f', agent);    
    time.k = logger.k;

    % x(i) = agent.estimator.result.state.p(1);
    % y(i) = agent.estimator.result.state.p(2);
    % plot(agent.reference.param.ax,x,y,"o");

    % i=i+1;
    pause(time.dt - toc(tStart));
    time.t = time.t + time.dt;
    disp(time.t)
end
agent.plant.do(time, 's');
end
%% functions for main_GUI
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
%% CLASS result merge
function result = sensor_do(varargin)
sensor = varargin{5}(varargin{6}).sensor;
result = sensor.motive.do(varargin);
result = merge_result(result,sensor.ros.do(varargin));
varargin{5}(varargin{6}).sensor.result = result;
end