tmp = matlab.desktop.editor.getActive;
dir = fileparts(tmp.Filename);
if ~contains(path,dir)
    cd(erase(dir,'\mode'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear ; clc;
userpath('clear');
end
%% 
close all
ts = 0; % initial time
dt = 0.025; % sampling period
te = 120; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
fExp = 0;
logger = LOGGER(1, size(ts:dt:te, 2), fExp, [],[]);

env=FLOOR_MAP(1,Env_FloorMapSquare); % for 2D lidar

clear initial_state
initial_state.p = [-1;-1;0];
initial_state.q = [0;0;0];
% % initial position in point cloud map
% initial_state.p = [-0.5;0;0];
% initial_state.q = [0;0;90];
% initial_state.v = [0; 0; 0];
% initial_state.w = [0; 0; 0];

agent = WHILL;
agent.parameter = VEHICLE_PARAM("VEHICLE3");
agent.plant = MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state,1));
%agent.sensor.lrf = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', env, 'theta_range', pi / 2, 'phi_range', -pi:0.01:pi,'noise',0.04)); % 2D lidar if theta range is scalar
agent.sensor = LiDAR_SIM(agent,Sensor_LiDAR(1,'angle_range', -pi: 0.0068:pi,'radius',40)); % 2D lidar : rplidar 0.0068, 40
agent.sensor.do(time, 'f',0,env,agent,1);
agent.estimator = NDT(agent,Estimator_NDT(agent,dt,MODEL_CLASS(agent,Model_Three_Vehicle(dt, initial_state,1))));
%agent.reference = PATH_REFERENCE(agent,Reference_PathCenter(agent.sensor.radius));
agent.reference = POINT_REFERENCE(agent,[2.0;-0.5;0],[0;0;0],[0;0;0]);
    agent(1).reference.do(time, 'f');
agent.controller = APID_CONTROLLER(agent,Controller_APID(dt));
agent(1).controller.do(time, 'f',0,0,agent,1);

run("ExpBase");

%%
if ~exist("app",'var')
clc
FH = figure;
for i = 1:time.te
    if i < 20 || rem(i, 10) == 0, i, end
    if i >=30
      i ;
    end
    agent(1).sensor.do(time, 'f',0,env,agent,1);   
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    agent(1).controller.do(time, 'f',0,0,agent,1);
    logger.logging(time, 'f', agent);
    PATH_REFERENCE.FHPlot('agent',agent,'Env',env,'FH',FH,'flag',0,'logger',logger,'param',struct('fLocal',false,'fField',true),'k',i);
    agent(1).plant.do(time, 'f');
    time.t = time.t + time.dt;
    pause(0.01)
end
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