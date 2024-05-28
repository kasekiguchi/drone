%=====================
%ペイロードの分割モデル
%=====================
clc; clear; close all
N = 6;%機体数
ts = 0; 
dt = 0.025;
te = 20;
tn = length(ts:dt:te);
time = TIME(ts, dt, te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1:N+1, size(ts:dt:te, 2), 0, [], []);%分割前1,分割後N個


% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = "zup"; % "eul":euler angle, "":euler parameter%元の論文がzdown
% x = [p0 Q0 v0 O0 qi wi Qi Oi]

agent(1) = DRONE;
agent(1).id = 1;%元のシステム
%Payload_Initial_State
initial_state(1).p = [0; 0; 0];%ペイロード
initial_state(1).v = [0; 0; 0];%ペイロード
initial_state(1).O = [0; 0; 0];%ペイロードの角速度
initial_state(1).wi = repmat([0; 0; 0], N, 1);%リンクの角速度
initial_state(1).Oi = repmat([0; 0; 0], N, 1);%ドローンの角速度

if contains(qtype, "zup")
    initial_state(1).qi = -1 * repmat([0; 0; 1], N, 1);%リンクの方向ベクトル
else
    initial_state(1).qi = 1 * repmat([0; 0; 1], N, 1);
end

if contains(qtype, "eul")
    initial_state(1).Q = [0; 0; 0];%ペイロードの姿勢
    %initial_state.Qi = repmat([0; pi / 180; 0], N, 1);
    initial_state(1).Qi = repmat([0;0;0],N,1);%ドローンの姿勢
else
    initial_state(1).Q = [1; 0; 0; 0];
    initial_state(1).Qi = repmat([1; 0; 0; 0], N, 1);
    %initial_state.Qi = repmat(Eul2Quat([pi/180;0;0]),N,1);
end

%=PAYLOAD=====================================================================================
% parameter     : DRONE_PARAM_COOPERATIVE_LOAD
% plant         : MODEL_CLASS / Model_Suspended_Cooperative_Load
% sensor        : DIRECT_SENSOR
% estimator     : DIRECT_ESTIMATOR
% reference     : TIME_VARYING_REFERENCE_SPLIT / gen_ref_sample_cooperative_load Cooperative
% controller    : CSLC / Controller_Cooperative_Load
%=============================================================================================
agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent(1).plant = MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype));
agent(1).sensor = DIRECT_SENSOR(agent(1),0.0); % sensor to capture plant position : second arg is noise
agent(1).estimator = DIRECT_ESTIMATOR(agent(1), struct("model", MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype)))); % estimator.result.state = sensor.result.state
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",120,"orig",ref_orig,"size",1*[4,4,0]},"Take_off",N},agent(1));
agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",15,"orig",[0;0;1],"size",1*[1,1,0.5]},"Cooperative",N},agent(1));
agent(1).controller = CSLC(agent(1), Controller_Cooperative_Load(dt, N));

for i = 2:N+1
    %=DRONE=====================================================================================
    % parameter     : DRONE_PARAM_SUSPENDED_LOAD
    % plant         : MODEL_CLASS / Model_Suspended_Load
    % sensor        : DIRECT_SENSOR
    % estimator     : EKF
    % reference     : TIME_VARYING_REFERENCE_SPLIT / Case_study_trajectory
    % controller    : HLC / Controller_HL: take off and landing, CSLC / Controller_Cooperative_Load : fright
    %=============================================================================================
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
%Generate instance
    agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
    agent(i).plant = MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i),1,agent(i)));%id,dt,type,initial,varargin
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i), 1,agent(i))), ["p", "q"],"B",blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]),"Q",blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8)));
    agent(i).sensor = DIRECT_SENSOR(agent(i),0.0); % sensor to capture plant position : second arg is noise
    agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[]},"Split2",N},agent(1));
%     agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[0;0;2]},"Split",N},agent(1));
    agent(i).controller.hlc = HLC(agent(i),Controller_HL(dt));
    agent(i).controller.load = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.do = @controller_do;
    agent(i).controller.result.input = [(agent(i).parameter.loadmass+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
end
% run("ExpBase");

clc
% for j = 1:te
for j = 1:tn
    % if j < 20 || rem(j, 5) == 0, disp(time.t), clc, end
        for i = 1:N+1
            if i >= 2
                load = agent(1).estimator.result.state;
                %分割前ペイロード
                p_load = load.p;
                R_load = RodriguesQuaternion(load.Q);%回転行列
                dR_load = R_load*Skew(load.O);%回転行列の微分
                wi_load = load.wi(3*(i-1)-2:3*(i-1),1);%分割前のagent(i)の紐の角速度ベクトル
                %分割後ペイロード
                pL_agent = p_load + R_load * rho(:,i-1);%分割後の質量重心位置
                vL_agent = load.v + dR_load * rho(:,i-1);%分割後の質量重心速度
                pT_agent = load.qi(3*(i-1)-2:3*(i-1),1);%分割後の紐の方向ベクトル
                dpT_agent = Skew(wi_load)*pT_agent;%分割後の紐の速度ベクトル
                %ドローン
                p_agent = p_load + R_load * rho(:,i-1) - agent(1).parameter.li(i-1)*pT_agent;
                v_agent = load.v + dR_load * rho(:,i-1)- agent(1).parameter.li(i-1)*dpT_agent;
                q_agent = Quat2Eul(load.Qi(4*(i-1)-3:4*(i-1),1));
                w_agent = load.Oi(3*(i-1)-2:3*(i-1),1);

                %agent(i).estimator.result.state.set_stateを使った方が正しい？
                agent(i).estimator.result.state.set_state("pL",pL_agent,"vL",vL_agent);
                agent(i).estimator.result.state.set_state("pT",pT_agent,"wL",wi_load);
                agent(i).estimator.result.state.set_state("p",p_agent,"v",v_agent);
                agent(i).estimator.result.state.set_state("q",q_agent,"w",w_agent);
            else
                agent(1).sensor.do(time, 'f');
                agent(1).estimator.do(time, 'f');
            end
            agent(i).reference.do(time, 'f',agent(1));
            agent(i).controller.do(time, 'f',0,0,agent(i),i);

        end
        input = zeros(4*N,1);
        for i = 2:N+1
            input(4*(i-1)-3:4*(i-1),1) = agent(i).controller.result.input;
        end

        agent(1).controller.result.input = input;
%         agent(2).reference.result.m+agent(3).reference.result.m+agent(4).reference.result.m+agent(5).reference.result.m+agent(6).reference.result.m+agent(7).reference.result.m
        agent(1).plant.do(time, 'f');
        logger.logging(time, 'f', agent);
        disp(time.t)
        time.t = time.t + time.dt;
    %pause(1)
end
clc
disp(time.t)
%%
close all
DataA= logger.data(1,"plant.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
% DataA = logger.data(2,"reference.result.state.p","p");
DataA1 = logger.data(2,"estimator.result.state.pL","p");
DataA2 = logger.data(3,"estimator.result.state.pL","p");
DataA3 = logger.data(4,"estimator.result.state.pL","p");
DataA4 = logger.data(5,"estimator.result.state.pL","p");
DataA5 = logger.data(6,"estimator.result.state.pL","p");
DataA6 = logger.data(7,"estimator.result.state.pL","p");
DataR1 = logger.data(2,"reference.result.state.p","p");
DataR2 = logger.data(3,"reference.result.state.p","p");
DataR3 = logger.data(4,"reference.result.state.p","p");
DataR4 = logger.data(5,"reference.result.state.p","p");
DataR5 = logger.data(6,"reference.result.state.p","p");
DataR6 = logger.data(7,"reference.result.state.p","p");
% DataA = logger.data(2,"reference.result.state.p","p");%リンクの向きはqi,ドローンの姿勢がQi,ペイロードの姿勢がQ
DataB = logger.data(5,"reference.result.m","p");
DataC = logger.data(7,"reference.result.Mui","p");
DataD = logger.data(5,"reference.result.state.xd","p");
DataE = logger.data(1,"controller.result.mui","p");
DataF = logger.data(1,"reference.result.a","p");
%mui-z
reData_muiz=reshape(DataE,6,[]);
reData_muiz1=reData_muiz(6,:);
reData_muiz2=reshape(reData_muiz1,6,[]);
DataE_mui_z=sum(reData_muiz2);
%mui-z
reData_muidz=reshape(DataE,6,[]);
reData_muidz1=reData_muidz(3,:);
reData_muidz2=reshape(reData_muidz1,6,[]);
DataE_muid_z=sum(reData_muidz2);
t=logger.data(0,'t',[]);


DataR = logger.data(1,"reference.result.state.p","p");
Data1 = logger.data(2,"reference.result.m","p");
Data2 = logger.data(3,"reference.result.m","p");
Data3 = logger.data(4,"reference.result.m","p");
Data4 = logger.data(5,"reference.result.m","p");
Data5 = logger.data(6,"reference.result.m","p");
Data6 = logger.data(7,"reference.result.m","p");
DataM = Data1+Data2+Data3+Data4+Data5+Data6;
mg = DataM*9.81;
ma = DataM.*DataD(:,3);
muid_ma =DataE_muid_z' - ma;
mui_ma = DataE_mui_z' - ma;

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
close all
figure(1)
hold on
plot(t,DataA1(:,1),'DisplayName','Agent1')
plot(t,DataA2(:,1),'DisplayName','Agent2')
plot(t,DataA3(:,1),'DisplayName','Agent3')
plot(t,DataA4(:,1),'DisplayName','Agent4')
plot(t,DataA5(:,1),'DisplayName','Agent5')
plot(t,DataA6(:,1),'DisplayName','Agent6')
plot(t,DataR1(:,1),'DisplayName','Agent1')
plot(t,DataR2(:,1),'DisplayName','Agent2')
plot(t,DataR3(:,1),'DisplayName','Agent3')
plot(t,DataR4(:,1),'DisplayName','Agent4')
plot(t,DataR5(:,1),'DisplayName','Agent5')
plot(t,DataR6(:,1),'DisplayName','Agent6')
% plot(t,Log2(:,1),'DisplayName','Roll')
% plot(t,Log2(:,2),'DisplayName','Pitch')
% plot(t,Log2(:,3),'DisplayName','Yaw')
% plot(t,Log2(:,4))
% xlim([-1.5 1.5])
% ylim([0 1.5])
xlabel("t [s]")
% ylabel("Position [m]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 14;
lgd = legend;
hold off

figure(2)
hold on
plot(t,DataA1(:,3),'DisplayName','Agent1')
plot(t,DataA2(:,3),'DisplayName','Agent2')
plot(t,DataA3(:,3),'DisplayName','Agent3')
plot(t,DataA4(:,3),'DisplayName','Agent4')
plot(t,DataA5(:,3),'DisplayName','Agent5')
plot(t,DataA6(:,3),'DisplayName','Agent6')
plot(t,DataR1(:,3),'DisplayName','Reference Agent1')
plot(t,DataR2(:,3),'DisplayName','Reference Agent2')
plot(t,DataR3(:,3),'DisplayName','Reference Agent3')
plot(t,DataR4(:,3),'DisplayName','Reference Agent4')
plot(t,DataR5(:,3),'DisplayName','Reference Agent5')
plot(t,DataR6(:,3),'DisplayName','Reference Agent6')
% plot(t,Log5(:,1),'DisplayName','Roll')
% plot(t,Log5(:,2),'DisplayName','Pitch')
% plot(t,Log5(:,3),'DisplayName','Yaw')
% plot(t,Log2(:,4))
% xlim([-1.5 1.5])
% ylim([0 1.5])
xlabel("t [s]")
ylabel("Position [m]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 14;
lgd = legend;
hold off

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
% plot(t,DataA(:,1),'DisplayName','X')
% plot(t,DataA(:,2),'DisplayName','Y')
plot(t,DataA(:,3),'DisplayName','Estimator')
% plot(t,DataR(:,1),'DisplayName','Ref X')
% plot(t,DataR(:,2),'DisplayName','Ref Y')
plot(t,DataR(:,3),'DisplayName','Reference')
% xlim([-1.5 1.5])
% ylim([0 1.5])
xlabel("t [s]")
ylabel("Load Position [m]")
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
plot(t,DataF(:,3))
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("acceleration [m/s^2]")
legend("ref","平均加速")
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
% plot(t,Data1(:,1),'LineWidth',1,'DisplayName','agent1')
% plot(t,Data2(:,1),'LineWidth',1,'DisplayName','agent2')
% plot(t,Data3(:,1),'LineWidth',1,'DisplayName','agent3')
% plot(t,Data4(:,1),'LineWidth',1,'DisplayName','agent4')
% plot(t,Data5(:,1),'LineWidth',1,'DisplayName','agent5')
% plot(t,Data6(:,1),'LineWidth',1,'DisplayName','agent6')
plot(t,DataM(:,1))

% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
xlabel("t [s]")
ylabel("Mass [kg]")
% legend("Payload","UAV")
ax = gca;
ax.FontSize = 14;
lgd = legend;
hold off

figure(107)
hold on
plot(t,DataC(:,3))
plot(t,DataD(:,3))
xlabel("t [s]")
legend("Mu","acceleration")
ax = gca;
ax.FontSize = 22;
hold off

figure(108)
hold on
plot(t,DataD(:,3))
plot(t,ma)
plot(t,DataE_muid_z)
plot(t,DataE_mui_z)
xlabel("t [s]")
legend("accel","ma","muid","mui")
ax = gca;
ax.FontSize = 22;
hold off

figure(109)
hold on
plot(t,mg)
plot(t,mui_ma)
plot(t,muid_ma)
xlabel("t [s]")
legend("mg","mui_ma","muid_ma")
ax = gca;
ax.FontSize = 22;
hold off

%%
% logger.plot({1,"p","rp"}, {1,"v","rp"},{1, "plant.result.state.Q", "pe"}, {1, "plant.result.state.qi", "p"},{1, "plant.result.state.wi", "p"}, {1, "plant.result.state.Qi", "p"})
% %%
% logger.plot({1, "plant.result.state.Qi", "p"})
% %%
close all
mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
mov.animation(logger, 'target', 1:N, "gif",true,"lims",[-3 3;-3 3;0 4],"ntimes",5);
% 
% %%
% logger.plot({1,"plant.result.state.qi","p"},{1,"p","er"},{1, "v", "p"},{1, "input", "p"},{1, "plant.result.state.Qi","p"})
%%
function result = controller_do(varargin)
    controller = varargin{5}.controller;
    if strcmp(varargin{2},'f')
        result = controller.load.do(varargin{5});
    else
        result = controller.hlc.do(varargin{5});
    end
    % result = merge_result(result,controller.load.do(varargin{5}));
    varargin{5}.controller.result = result;
end

function dfunc(app)
app.logger.plot({1, "p", "er"}, "ax", app.UIAxes, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "q", "e"}, "ax", app.UIAxes2, "xrange", [app.time.ts, app.time.t]);
appb.logger.plot({1, "input", ""}, "ax", app.UIAxes3, "xrange", [app.time.ts, app.time.t]);
end
