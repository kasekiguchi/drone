clc
clear
N = 6;
ts = 0; %機体数
dt = 0.025;
te = 2000;
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

% Q1 = [0.9987; 0.0027; -0.0034; -0.0002];
% Q2 = [0.9987; -0.0001;  -0.0051; -0.0002];
% Q3 = [0.9987; -0.0031;  -0.0015; -0.0003];
% Q4 = [0.9986; -0.0030;  0.0053; -0.0003];
% Q5 = [0.9987; 0.0027;  0.0019; -0.0003];
% Q6 = [0.9987; 0.0021;  -0.0003; -0.0003];
% initial_state(1).Qi = [Q1;Q2;Q3;Q4;Q5;Q6];


% Qrho = cell2mat(arrayfun(@(i) quat_times_vec(Q',obj.rho(:,i))',1:length(obj.target),'UniformOutput',false));
% q = repmat(p,1,length(obj.target))+Qrho; % ケーブル付け根位置（牽引物側）
% rho = reshape(q,size(q,1),size(q,2)/length(obj.target),length(obj.target)); % attachment point 
% initial_state(1).pi = rho - qi.*reshape(repmat(obj.li,3,1),1,[],length(obj.target));
ref_orig = [4;0;0]; %目標軌道原点

agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent(1).plant = MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype));
agent(1).sensor = DIRECT_SENSOR(agent(1),0.0); % sensor to capture plant position : second arg is noise
agent(1).estimator = DIRECT_ESTIMATOR(agent(1), struct("model", MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype)))); % estimator.result.state = sensor.result.state
% agent(1).reference = TIME_VARYING_REFERENCE_COOPERATIVE(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",[1;1;1],"size",1*[4,4,0]},"Cooperative"});
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",100,"orig",ref_orig,"size",1*[4,4,0]},"Cooperative",N},agent(1));
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",120,"orig",ref_orig,"size",1*[4,4,0]},"Take_off",N},agent(1));
agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",50,"orig",[1;0;0],"size",1*[1,1,0]},"Cooperative",N},agent(1));

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
    initial_state(i).pL = initial_state(1).p + R_load*rho(:,i-1);
    agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
    agent(i).plant = MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i),1,agent(i)));%id,dt,type,initial,varargin
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i), 1,agent(i))), ["p", "q"],"B",blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]),"Q",blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8)));
    agent(i).sensor = DIRECT_SENSOR(agent(i),0.0); % sensor to capture plant position : second arg is noise
    agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[]},"Split2",N},agent(1));
%     agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[0;0;2]},"Split",N},agent(1));
    agent(i).controller.hlc = HLC(agent(i),Controller_HL(dt));
%     agent(i).controller.load = HLC_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.load = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.do = @controller_do;
    agent(i).controller.result.input = [(agent(i).parameter.loadmass+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
end
% run("ExpBase");

clc
for j = 1:te
    if j < 20 || rem(j, 5) == 0, j, end
        for i = 1:N+1
            
            if i >= 2
                load = agent(1).estimator.result.state;
                p_load = load.p;
                R_load = RodriguesQuaternion(load.Q);
                dR_load = R_load*Skew(load.O);
                wi_load = load.wi(3*(i-1)-2:3*(i-1),1);
                pL_agent = p_load + R_load * rho(:,i-1);
                vL_agent = load.v + dR_load * rho(:,i-1);
                pT_agent = load.qi(3*(i-1)-2:3*(i-1),1);
                dpT_agent = Skew(wi_load)*pT_agent;
                p_agent = p_load + R_load * rho(:,i-1) - agent(1).parameter.li(i-1)*pT_agent;
                v_agent = load.v + dR_load * rho(:,i-1)- agent(1).parameter.li(i-1)*dpT_agent;
                q_agent = Quat2Eul(load.Qi(4*(i-1)-3:4*(i-1),1));
                w_agent = load.Oi(3*(i-1)-2:3*(i-1),1);

                %agent(i).estimator.result.state.set_stateを使った方が正しい？
                agent(i).estimator.result.state.set_state("pL",pL_agent,"vL",vL_agent);
                agent(i).estimator.result.state.set_state("pT",pT_agent,"wL",wi_load);
                agent(i).estimator.result.state.set_state("p",p_agent,"v",v_agent);
                agent(i).estimator.result.state.set_state("q",q_agent,"w",w_agent);
%                 agent(i).estimator.result.state.pL = pL_agent;
%                 agent(i).estimator.result.state.vL = vL_agent;
%                 agent(i).estimator.result.state.wL = wi_load;
%                 agent(i).estimator.result.state.pT = pT_agent;
                
%                 agent(i).estimator.result.state.p = p_agent;
%                 agent(i).estimator.result.state.v = v_agent;
%                 agent(i).estimator.result.state.q = q_agent;
%                 agent(i).estimator.result.state.w = w_agent;
            else
                agent(1).sensor.do(time, 'f');
                agent(1).estimator.do(time, 'f');
            end
%             agent(i).estimator.state_set =;
            agent(i).reference.do(time, 'f',agent(1));
%             agent(i).controller.do(time, 'f',0,0,agent,i); 
            agent(i).controller.do(time, 'f',0,0,agent(i),i);
%             if i >= 2
%             agent(i).controller.result.input = [(agent(i).parameter.loadmass+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
%             end

        end
        input = zeros(4*N,1);
        for i = 2:N+1
            input(4*(i-1)-3:4*(i-1),1) = agent(i).controller.result.input;
        end
%         [(agent(i).parameter.loadmass+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];

        agent(1).controller.result.input = input;
%         agent(2).reference.result.m+agent(3).reference.result.m+agent(4).reference.result.m+agent(5).reference.result.m+agent(6).reference.result.m+agent(7).reference.result.m
        agent(1).plant.do(time, 'f');
        logger.logging(time, 'f', agent);
        time.t = time.t + time.dt;
    %pause(1)
end

%%
close all
% DataA = logger.data(1,"plant.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
DataA = logger.data(2,"plant.result.state.pL","p")
% DataA = logger.data(2,"reference.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
DataB = logger.data(5,"reference.result.m","p");
DataC = logger.data(7,"reference.result.Muid","p");
DataD = logger.data(5,"reference.result.state.xd","p");
t=logger.data(0,'t',[]);
%%

DataR = logger.data(1,"reference.result.state.p","p");
Data1 = logger.data(2,"reference.result.m","p");
Data2 = logger.data(3,"reference.result.m","p");
Data3 = logger.data(4,"reference.result.m","p");
Data4 = logger.data(5,"reference.result.m","p");
Data5 = logger.data(6,"reference.result.m","p");
Data6 = logger.data(7,"reference.result.m","p");
DataM = Data1+Data2+Data3+Data4+Data5+Data6;
ij=2;
if ij <1
    DataI = reshape(logger.data(ij,"controller.result.input","p"),[4,length(logger.data(ij,"controller.result.input","p"))/4])';
else
    Data_cooperative1 = reshape(logger.data(2,"controller.result.input","p"),[4,length(logger.data(2,"controller.result.input","p"))/4])';
%     DataI1 = Data_cooperative(1:6:end,1);
    Data_cooperative2 = reshape(logger.data(3,"controller.result.input","p"),[4,length(logger.data(3,"controller.result.input","p"))/4])';
    Data_cooperative3 = reshape(logger.data(4,"controller.result.input","p"),[4,length(logger.data(4,"controller.result.input","p"))/4])';
    Data_cooperative4 = reshape(logger.data(5,"controller.result.input","p"),[4,length(logger.data(5,"controller.result.input","p"))/4])';
    Data_cooperative5 = reshape(logger.data(6,"controller.result.input","p"),[4,length(logger.data(6,"controller.result.input","p"))/4])';
    Data_cooperative6 = reshape(logger.data(7,"controller.result.input","p"),[4,length(logger.data(7,"controller.result.input","p"))/4])';

end
t=logger.data(0,'t',[]);
%%
figure(101)
hold on
plot(DataA(:,1),DataA(:,2),'DisplayName','Estimator')
plot(DataR(:,1),DataR(:,2),'DisplayName','Reference')
xlim([-1 3])
ylim([-2 2])
xlabel("X [m]")
ylabel("Y [m]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 22;
lgd = legend;
hold off


figure(102)
hold on
plot(t,DataA(:,1),'DisplayName','X')
plot(t,DataA(:,2),'DisplayName','Y')
plot(t,DataA(:,3),'DisplayName','Z')
% plot(t,DataR(:,1),'DisplayName','Ref X')
% plot(t,DataR(:,2),'DisplayName','Ref Y')
% plot(t,DataR(:,3),'DisplayName','Ref Z')
% xlim([-1.5 1.5])
% ylim([0 1.5])
xlabel("t [s]")
ylabel("Position [m]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 14;
lgd = legend;
hold off


figure(103)
hold on
plot(t,DataC(:,3))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("Mu [N]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 22;
hold off


figure(104)
hold on
plot(t,DataD(:,3))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("acceleration [m/s^2]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 22;
hold off

k=1;
figure(105) 
hold on
plot(t,Data_cooperative1(:,k),'LineWidth',1,'DisplayName','agent1')
plot(t,Data_cooperative2(:,k),'LineWidth',1,'DisplayName','agent2')
plot(t,Data_cooperative3(:,k),'LineWidth',1,'DisplayName','agent3')
plot(t,Data_cooperative4(:,k),'LineWidth',1,'DisplayName','agent4')
plot(t,Data_cooperative5(:,k),'LineWidth',1,'DisplayName','agent5')
plot(t,Data_cooperative6(:,k),'LineWidth',1,'DisplayName','agent6')



% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
% ylabel("Yaw Torque [Nm]")
ylabel("thrust [Nm]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 22;
lgd = legend;
hold off

figure(106) 
hold on
plot(t,Data1(:,1),'LineWidth',1,'DisplayName','agent1')
plot(t,Data2(:,1),'LineWidth',1,'DisplayName','agent2')
plot(t,Data3(:,1),'LineWidth',1,'DisplayName','agent3')
plot(t,Data4(:,1),'LineWidth',1,'DisplayName','agent4')
plot(t,Data5(:,1),'LineWidth',1,'DisplayName','agent5')
plot(t,Data6(:,1),'LineWidth',1,'DisplayName','agent6')

% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("Mass [kg]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 22;
lgd = legend;
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
close all
mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
mov.animation(logger, 'target', 1:N, "gif",true,"lims",[-2 10;-6 6;-1 4],"ntimes",5);
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
