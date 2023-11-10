clc
% mega rover
ts = 0; % initial time
dt = 0.025; % sampling period
te = 200; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);   
post_func = @(app) post(app);

env=FLOOR_MAP(1,Env_FloorMapSquare);

motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
fExp = 0;
logger = LOGGER(1, size(ts:dt:te, 2), fExp, [],[]);

initial_state.p = [0;-1.5;0];
initial_state.q = [0;0;0];

agent = WHILL;
agent.parameter = VEHICLE_PARAM("VEHICLE3");
agent.plant = MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state,1));
%agent.estimator = EKF(agent,Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state, 1)),["p", "q"],"B",1,"Q",[1;1;0;0;0;1]));
agent.estimator = EKF(agent,Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state, 1)),["p", "q"],"B",1,"Q",[1;1;0;0;0;1]));
agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive));
%agent.sensor.lrf = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', env, 'theta_range', pi / 2, 'phi_range', -pi:0.1:pi)); % 2D lidar
agent.sensor.lrf = LiDAR_SIM(agent,Sensor_LiDAR(1,'angle_range', -pi:0.1:pi)); % 2D lidar
% agent.sensor.lrf = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.sensor.do = @sensor_do; % synthesis of sensors
agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent.sensor.lrf.radius));
agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));

run("ExpBase");

%%
clc
FH = figure;
for i = 1:time.te
    if i < 20 || rem(i, 10) == 0, i, end
    motive.getData(agent);
    agent(1).sensor.do(time, 'f',0,env,agent,1);
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    agent(1).controller.do(time, 'f',0,0,agent,1);
    agent.reference.FHPlot(env,FH,0)
    logger.logging(time, 'f', agent);
    agent(1).plant.do(time, 'f');
    time.t = time.t + time.dt;
%    pause(1)
end


function result = sensor_do(varargin)
sensor = varargin{5}(varargin{6}).sensor;
result = sensor.motive.do(varargin);
result = merge_result(result,sensor.lrf.do(varargin));
varargin{5}(varargin{6}).sensor.result = result;
end

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
%app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end