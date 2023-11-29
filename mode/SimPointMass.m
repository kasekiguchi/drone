clc
close all
ts = 0; % initial time
dt = 0.05; % sampling period
te = 100; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);   
post_func = @(app) post(app);

%%
fExp = 0;
logger = LOGGER(1, size(ts:dt:te, 2), fExp, [],[]);

clear initial_state
initial_state.p = [-1];
initial_state.v = [0];

agent = DRONE;
agent.parameter = POINT_MASS_PARAM("rigid","row","A",[0,1;0 0],"B",[0;1],"C",[1 0],"D",0);
agent.plant = MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent));
%agent.parameter.set("mass",struct("mass",0.5))
agent.estimator = KF(agent, Estimator_KF(agent,dt,MODEL_CLASS(agent,Model_Discrete(dt,initial_state,1,"FREE",agent)),["p"],"Q",1e-3*eye(2),"R",1e-2,"P",eye(2),"B",1));
agent.sensor = DIRECT_SENSOR(agent, 1e-4);
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",1,"orig",[2;0;0],"size",[0,0,0]}});
agent.controller = PID_CONTROLLER(agent,Controller_PID(dt,"Kc",5,"Tc",1,"type","PID"));

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
    agent(1).plant.do(time, 'f');
    time.t = time.t + time.dt;
    pause(0.01)
end
end
%%


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