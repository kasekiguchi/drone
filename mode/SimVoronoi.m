ts = 0; % initial time
dt = 0.1; % sampling period
te = 10; % terminal time
time = TIME(ts,dt,te); % time class instance
in_prog_func = @(app) in_prog(app); % in progress procedure
post_func = @(app) post(app); % post procedure

N = 3; % number of agent

logger = LOGGER(1:N, size(ts:dt:te, 2), 0, [],[]); % logger class instance for logging
env = DENSITY_MAP(Env_2DCoverage); % Weighted 2D grid map
arranged_pos = arranged_position([0, 0], N, 1, 0); % initial position

for i = 1:N
  agent(i) = DRONE; % set drone agent
  agent(i).id = i; % set index
  initial_state(i).p = arranged_pos(:, i); % set initial position
  initial_state(i).v = [0; 0; 0]; % set initial velocity
  
  % Directly move to the voronoi varycenter at one step
  %[M,P]=Model_Discrete(dt,initial_state(i),1,"P");
  %agent(i).controller = DIRECT_CONTROLLER(agent(i),[]);% 
  
  % Move to the voronoi varycenter with point mass dynamics
  [M,P]=Model_Discrete(dt,initial_state(i),1,"PV");
  agent(i).controller = PID_CONTROLLER(agent(i),Controller_PID(dt)); 

  agent(i).plant = MODEL_CLASS(agent(i),M); % control target model
  agent(i).parameter = P; % set model parameter
  agent(i).sensor.direct = DIRECT_SENSOR(agent(i),0.0); % sensor to capture plant position : second arg is noise 
  agent(i).sensor.rpos = RANGE_POS_SIM(agent(i),Sensor_RangePos(i,'r',4)); % range sensor to capture neighbor's position : r : sensor radius
  agent(i).sensor.rdensity = RANGE_DENSITY_SIM(agent(i),Sensor_RangeD('r',2)); % range sensor to capture field importance : r : sensor radius
  agent(i).sensor.do = @sensor_do; % synthesis of sensors
  agent(i).estimator = DIRECT_ESTIMATOR(agent(i),struct("model",MODEL_CLASS(agent(i),M))); % estimator.result.state = sensor.result.state
  agent(i).reference = VORONOI_BARYCENTER(agent(i),Reference_2DCoverage(agent(i),env,'void',0)); % calculate Voronoi varycenter
end
%% local function
function result = sensor_do(varargin)
sensor = varargin{5}(varargin{6}).sensor;
result = sensor.direct.do(varargin);
result = merge_result(result,sensor.rpos.do(varargin));
result = merge_result(result,sensor.rdensity.do(varargin));
varargin{5}(varargin{6}).sensor.result = result;
end

function in_prog(app) % in progress procedure
app.env.show(app.UIAxes);
VORONOI_BARYCENTER.show_k(app.logger, app.env,"span",1:app.N,"ax",app.UIAxes,"clear",false);
end
function post(app) % post procedure
app.logger.plot({1, "p", "pr"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "p", "pr"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({3, "p", "pr"},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
%VORONOI_BARYCENTER.draw_movie(app.logger, app.env,1:app.N,app.UIAxes);
end
