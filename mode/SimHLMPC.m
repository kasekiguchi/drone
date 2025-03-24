clc;
for j = 4:100 %%%%%%%%%%%%  number of random references
    fprintf('Initializing... N:%d \n', j);
    clear logger
ts = 0; % initial time
dt = 0.025; % sampling period
te = 10 % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging
initial_state.p = arranged_position([1, 1], 1, 1, 1); % [x, y], 1, 1, z
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.sensor = DIRECT_SENSOR(agent, 0.0);
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
%agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory", {[0;0;0], te}, "HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"bezier_curve4",{[1;1;1]},"HL"});
agent.controller = HLMPC_CONTROLLER(agent, Controller_HLMPC(agent));
run("ExpBase");
for i = 1:400
    if i < 20 || rem(i, 10) == 0; end
    tic
    
    agent(1).sensor.do(time, 'f');
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
   % agent(1).stl.do(time,{'c','h','l'});
    agent(1).controller.do(time, 'f');
    agent(1).plant.do(time, 'f');
    logger.logging(time, 'f', agent);
     time.t = time.t + time.dt;
    time.k = round((time.t )/(time.dt));
    %pause(1)
    all = toc
end
   logger.save(strcat('HL_sim_', num2str(j)));
end
%logger.plot({1,"p","er"},{1, "q", "er"}, {1, "v", "er"},{1,"p1-p2-p3","p"},"xrange",[time.ts,time.t], "fig_num",1,"row_col",[2 2]);%by kyo