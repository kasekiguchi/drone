% Estimating load mass via EKF in offline
clc
simple_log = simple_log_EKF_load_model_mL;
t = simple_log.t;
dtr = 0.025;
dt = [0;diff(t)];
tn = length(t);
time = TIME(t(1),dtr,t(end));%timeを修正
p  = simple_log.plant.p ;
q  = simple_log.plant.q ;
v  = simple_log.plant.v ;
w  = simple_log.plant.w ;
pL = simple_log.plant.pL;
vL = simple_log.plant.vL;
pT = simple_log.plant.pT;
wL = simple_log.plant.wL;
input = simple_log.controller.input;

initial_state.p  = p(:,1);
initial_state.q  = q(:,1);
initial_state.v  = v(:,1);
initial_state.w  = w(:,1);
initial_state.pL = pL(:,1);
initial_state.vL = vL(:,1);
initial_state.pT = pT(:,1);
initial_state.wL = wL(:,1);
logger = LOGGER(1, tn, 0, [],[]);

agent = DRONE;
agent.parameter  = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");%エイシンように変更する必要
agent.plant      = MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state,1,agent));%id,dt,type,initial,varargin
agent.estimator  = EKF(agent, Estimator_EKF(agent,dtr,MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state, 1,agent,1)), ["p", "q", "pL", "pT"]));%expの流用
agent.sensor     = DIRECT_SENSOR(agent, 0);
agent.controller = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dtr,agent));
agent.controller.result.input = input(:,1);

for i = 2:tn
    agent.sensor.do(time, 'f');
    agent.estimator.do(time, 'f');
    agent.controller.result.input = input(:,i);
    agent.plant.set_state([p(:,i);q(:,i);v(:,i);w(:,i);pL(:,i);vL(:,i);pT(:,i);wL(:,i)]);
    logger.logging(time, 'f', agent);
    disp(t(i))
    time.t = t(i);
    time.dt = dt(i);
    % time.t = time.t + time.dt;
end
disp(time.t)
%reference軌道など描画必要な変数は後でloggerに代入する．