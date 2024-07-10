clc
clear
ts = 0;
dt = 0.1;
te = 25;
tn = length(ts:dt:te);
time = TIME(ts, dt, te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1, size(ts:dt:te, 2), 0, [], []);

N = 6;
% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = "zup"; % "eul":euler angle, "":euler parameter
% x = [p0 Q0 v0 O0 qi wi Qi Oi]


initial_state.p = [0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.O = [0; 0; 0];
initial_state.wi = repmat([0; 0; 0], N, 1);
initial_state.Oi = repmat([0; 0; 0], N, 1);
initial_state.a = [0;0;0];%ペイロード加速度
initial_state.dO = [0;0;0];%ペイロード角加速度

% initial_state.p = [1; 4.8; 1.5];
% initial_state.v = [0; 0; 0];
% initial_state.O = [0; 0; -1.0996];
% initial_state.wi = repmat([0; 0; 0], N, 1);
% initial_state.Oi = repmat([0; 0; 0], N, 1);

if contains(qtype, "zup")
    initial_state.qi = -1 * repmat([0; 0; 1], N, 1);
else
    initial_state.qi = 1 * repmat([0; 0; 1], N, 1);
end

if contains(qtype, "eul")
    initial_state.Q = [0; 0; 0];
    %initial_state.Qi = repmat([0; pi / 180; 0], N, 1);
    initial_state.Qi = repmat([0;0;0],N,1);
else
    initial_state.Q = [1; 0; 0; 0];
    initial_state.Qi = repmat([1; 0; 0; 0], N, 1);
    %initial_state.Qi = repmat(Eul2Quat([pi/180;0;0]),N,1);
end

agent = DRONE;

agent.plant = MODEL_CLASS(agent, Model_Suspended_Cooperative_Load(dt, initial_state, 1, N, qtype));
agent.parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent.estimator = DIRECT_ESTIMATOR(agent, struct("model", MODEL_CLASS(agent, Model_Suspended_Cooperative_Load(dt, initial_state, 1, N, qtype)))); % estimator.result.state = sensor.result.state
%agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_Suspended_Cooperative_Load(dt, initial_state, 1,N)),["p","Q","v","O","qi","wi","Qi","Oi"]));

agent.sensor = DIRECT_SENSOR(agent, 0.0); % sensor to capture plant position : second arg is noise
agent.reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent,{"gen_ref_sample_cooperative_load",{"freq",50,"orig",[0;0;0],"size",1*[1,1,0]},"Cooperative"});
% agent.reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent,{"gen_ref_sample_cooperative_load",{"freq",70,"orig",[2;0.5;1],"size",1*[4,4,0]},"Cooperative"});
% agent.controller = GEOMETRIC_CONTROLLER(agent,Controller_Cooperative_Load(dt,N));
agent.controller = NEW_GEOMETRIC_CONTROLLER(agent,Controller_Cooperative_Load(dt,N));
% agent.controller = GEOMETRIC_CONTROLLER_with_3_Drones(agent,Controller_Cooperative_Load(dt));
run("ExpBase");


clc
% for i = 1:5000
%     if i < 20 || rem(i, 10) == 0, i, end
for j = 1:tn
    disp(time.t)
    agent(1).sensor.do(time, 'f');
    agent(1).estimator.do(time, 'f');
    agent(1).reference.do(time, 'f');
    agent(1).controller.do(time, 'f');
    %agent(1).controller.result.input = repmat([1.01 + 0.0*cos(time.t*2*pi/3);0.001*[sin(time.t*(pi)/1);0*cos(time.t*(pi)/1);0]],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    %agent(1).controller.result.input = repmat([1;0;0;0],N,1)*sum(agent.parameter.get(["m0","mi"],"row"))*9.81/N;
    %agent(1).controller.result.input = agent(1).controller.result.input.*repmat([-1;1;-1;-1],N,1);
    %agent(1).controller.result.input(4:4:end) = 0;
    agent(1).plant.do(time, 'f');
    logger.logging(time, 'f', agent);
    time.t = time.t + time.dt;
    %pause(1)
end
disp(time.t)
%%
logger.plot({1,"p","rp"}, {1,"v","rp"},{1, "plant.result.state.Q", "pe"}, {1, "plant.result.state.qi", "p"},{1, "plant.result.state.wi", "p"}, {1, "plant.result.state.Qi", "p"})
%%
logger.plot({1, "plant.result.state.Qi", "p"})
%%
% clc
% aaaa= logger.data(1,"p","e");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
% t=logger.data(0,'t',[]);
% % Euldata=Quat2Eul(aaaa(:,1:4)');
% figure(101)
% plot(t,aaaa)
% legend("Roll","Pitch","Yaw")
%%
close all
aaaa= logger.data(1,"plant.result.state.Q","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
% bbbb= logger.data(1,"reference.result.state.Q","p");
t=logger.data(0,'t',[]);
% Euldata=Quat2Eul(aaaa(:,1:4)');
% Euldata2=Quat2Eul(bbbb(:,1:4)');
figure(101)
% plot(t,Euldata(3,:))
plot(t,aaaa(:,1))

% plot(t,aaaa(:,2))
% hold on
% plot(t,aaaa(:,3))
% plot(t,bbbb(:,1))
% plot(t,bbbb(:,2))
% plot(t,bbbb(:,3))
% legend("X","Y","Z","ref X","ref Y","ref Z")
ylim([-1.5,1.5]);
legend("Yaw")
% legend("Roll","Pitch","Yaw")
hold off
%%
%close all
% mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
% mov.animation(logger, 'target', 1:N, "gif",true,"lims",[-10 10;-10 10;-10 10],"ntimes",10);

%%
logger.plot({1,"plant.result.state.qi","p"},{1,"p","er"},{1, "v", "p"},{1, "input", "p"},{1, "plant.result.state.Qi","p"})
%%
function dfunc(app)
app.logger.plot({1, "p", "er"}, "ax", app.UIAxes, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "q", "e"}, "ax", app.UIAxes2, "xrange", [app.time.ts, app.time.t]);
appb.logger.plot({1, "input", ""}, "ax", app.UIAxes3, "xrange", [app.time.ts, app.time.t]);
end
