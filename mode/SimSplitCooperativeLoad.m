clc
clear
N = 6;
ts = 0; %機体数
dt = 0.025;
te = 100;
time = TIME(ts, dt, te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1:N+1, size(ts:dt:te, 2), 0, [], []);


% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = "zup"; % "eul":euler angle, "":euler parameter
% x = [p0 Q0 v0 O0 qi wi Qi Oi]

agent(1) = DRONE;
agent(1).id = 1;
%Payload_Initial_State
initial_state(1).p = [0; 0; 0];
initial_state(1).v = [0; 0; 0];
initial_state(1).O = [0; 0; 0];
initial_state(1).wi = repmat([0; 0; 0], N, 1);
initial_state(1).Oi = repmat([0; 0; 0], N, 1);

if contains(qtype, "zup")
    initial_state(1).qi = -1 * repmat([0; 0; 1], N, 1);
else
    initial_state(1).qi = 1 * repmat([0; 0; 1], N, 1);
end

if contains(qtype, "eul")
    initial_state(1).Q = [0; 0; 0];
    %initial_state.Qi = repmat([0; pi / 180; 0], N, 1);
    initial_state(1).Qi = repmat([0;0;0],N,1);
else
    initial_state(1).Q = [1; 0; 0; 0];
    initial_state(1).Qi = repmat([1; 0; 0; 0], N, 1);
    %initial_state.Qi = repmat(Eul2Quat([pi/180;0;0]),N,1);
end

% Qrho = cell2mat(arrayfun(@(i) quat_times_vec(Q',obj.rho(:,i))',1:length(obj.target),'UniformOutput',false));
% q = repmat(p,1,length(obj.target))+Qrho; % ケーブル付け根位置（牽引物側）
% rho = reshape(q,size(q,1),size(q,2)/length(obj.target),length(obj.target)); % attachment point 
% initial_state(1).pi = rho - qi.*reshape(repmat(obj.li,3,1),1,[],length(obj.target));
ref_orig = [0;0;0]; %目標軌道原点

agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent(1).plant = MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype));
agent(1).sensor = DIRECT_SENSOR(agent(1),0.0); % sensor to capture plant position : second arg is noise
agent(1).estimator = DIRECT_ESTIMATOR(agent(1), struct("model", MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype)))); % estimator.result.state = sensor.result.state
% agent(1).reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",[1;1;1],"size",1*[4,4,0]},"Cooperative"});
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",ref_orig,"size",1*[4,4,0]},"Cooperative",N},agent(1));
agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",ref_orig,"size",1*[4,4,0]},"Take_off",N},agent(1));
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",ref_orig,"size",1*[4,4,0]},"Cooperative",N},agent(1));

agent(1).controller = CSLC(agent(1), Controller_Cooperative_Load(dt, N));
% agent(1).controller.cslc = CSLC(agent(1), Controller_Cooperative_Load(dt, N));
% agent(1).controller.do = @controller_do;


for i = 2:N+1
    agent(i) = DRONE;
    agent(i).id = i;
    %Drone_Initial_State
    rho = agent(1).parameter.rho; %loadstate_rho
    R_load = RodriguesQuaternion(initial_state(1).Q);
    initial_state(i).p = arranged_position([0, 0], 1, 1, 0);
    initial_state(i).q = [0; 0; 0];
    initial_state(i).v = [0; 0; 0];
    initial_state(i).w = [0; 0; 0];
    initial_state(i).vL = [0; 0; 0];
    initial_state(i).pT = [0; 0; -1];
    initial_state(i).wL = [0; 0; 0];
%     initial_state(i).p = [1;0;1.46];
    initial_state(i).p = initial_state(1).p + R_load*rho(:,i-1) - agent(1).parameter.li(i-1) * initial_state(i).pT;
    initial_state(i).pL = initial_state(1).p+R_load*rho(:,i-1);
    agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
    agent(i).plant = MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i),1,agent(i)));%id,dt,type,initial,varargin
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i), 1,agent(i))), ["p", "q"],"B",blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]),"Q",blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8)));
    agent(i).sensor = DIRECT_SENSOR(agent(i),0.0); % sensor to capture plant position : second arg is noise
    agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[]},"Split2",N},agent(1));
%     agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[0;0;2]},"Split",N},agent(1));
    agent(i).controller.hlc = HLC(agent(i),Controller_HL(dt));
    agent(i).controller.load = HLC_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.do = @controller_do;
    agent(i).controller.result.input = [(agent(i).parameter.loadmass+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
end
% run("ExpBase");

clc
for j = 1:te
    if j < 20 || rem(j, 10) == 0, j, end
        for i = 1:N+1
            agent(i).sensor.do(time, 'f');
            agent(i).estimator.do(time, 'f');
            agent(i).reference.do(time, 'f');
%             agent(i).controller.do(time, 'f',0,0,agent,i); 
            agent(i).controller.do(time, 'f',0,0,agent(i),i);
            agent(i).plant.do(time, 'f');            
        end
        logger.logging(time, 'f', agent);
        time.t = time.t + time.dt;
    %pause(1)
end

%%
close all
% DataA= logger.data(1,"plant.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
DataA = logger.data(2,"reference.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
DataB = logger.data(2,"reference.result.m","p");
DataC = logger.data(2,"reference.result.Muid","p");
DataD = logger.data(2,"reference.result.state.xd","p");
t=logger.data(0,'t',[]);
%%
figure(101)
hold on
plot(t,DataA(:,3))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("X [m]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 13;
hold off

%%
figure(102)
hold on
plot(t,DataB(:,1))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("m [kg]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 13;
hold off

%%
figure(103)
hold on
plot(t,DataC(:,3))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("Mu [N]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 13;
hold off

%%
figure(104)
hold on
plot(t,DataD(:,9))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("acceleration [m/s^2]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 13;
hold off
%%
% close all
% DataA= logger.data(2,"plant.result.state.pL","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
% Data2= logger.data(2,"reference.result.state.p","p");
% Data3= logger.data(3,"reference.result.state.p","p");
% Data4= logger.data(4,"reference.result.state.p","p");
% Data5= logger.data(5,"reference.result.state.p","p");
% Data6= logger.data(6,"reference.result.state.p","p");
% Data7= logger.data(7,"reference.result.state.p","p");
% t=logger.data(0,'t',[]);
% 
% figure(101)
% hold on
% plot(Data2(:,1),Data2(:,2))
% plot(Data3(:,1),Data3(:,2))
% plot(Data4(:,1),Data4(:,2))
% plot(Data5(:,1),Data5(:,2))
% plot(Data6(:,1),Data6(:,2))
% plot(Data7(:,1),Data7(:,2))
% % plot(cccc(:,1),cccc(:,2))
% % xlim([-1.5 1.5])
% % ylim([-1.5 1.5])
% % xlabel("X [m]")
% ylabel("Y [m]")
% % legend("Payload","UAV")
% ax = gca;
% ax.FontSize = 13;
% hold off

% figure(102)
% hold on
% plot(DataB(:,1),DataB(:,2))
% % plot(cccc(:,1),cccc(:,2))
% % xlim([-1.5 1.5])
% % ylim([-1.5 1.5])
% % xlabel("X [m]")
% ylabel("Y [m]")
% % legend("Payload","UAV")
% ax = gca;
% ax.FontSize = 13;
% hold off
% 
% figure(103)
% hold on
% plot(DataC(:,1),DataC(:,2))
% % plot(cccc(:,1),cccc(:,2))
% % xlim([-1.5 1.5])
% % ylim([-1.5 1.5])
% % xlabel("X [m]")
% ylabel("Y [m]")
% % legend("Payload","UAV")
% ax = gca;
% ax.FontSize = 13;
% hold off

%%
% logger.plot({1,"p","rp"}, {1,"v","rp"},{1, "plant.result.state.Q", "pe"}, {1, "plant.result.state.qi", "p"},{1, "plant.result.state.wi", "p"}, {1, "plant.result.state.Qi", "p"})
% %%
% logger.plot({1, "plant.result.state.Qi", "p"})
% %%
% %close all
% mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
% mov.animation(logger, 'target', 1:N, "gif",true,"lims",[-10 10;-10 10;-10 10],"ntimes",10);
% 
% %%
% logger.plot({1,"plant.result.state.qi","p"},{1,"p","er"},{1, "v", "p"},{1, "input", "p"},{1, "plant.result.state.Qi","p"})
%%
function result = controller_do(varargin)
controller = varargin{5}.controller;
result = controller.hlc.do(varargin{5});
result = merge_result(result,controller.load.do(varargin{5}));
varargin{5}.controller.result = result;
end

function dfunc(app)
app.logger.plot({1, "p", "er"}, "ax", app.UIAxes, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "q", "e"}, "ax", app.UIAxes2, "xrange", [app.time.ts, app.time.t]);
appb.logger.plot({1, "input", ""}, "ax", app.UIAxes3, "xrange", [app.time.ts, app.time.t]);
end
