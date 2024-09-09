%=====================
%ペイロードの分割モデル
%=====================
clc; clear; close all
N = 6;%機体数
ts = 0; 
dt = 0.025;
te = 3;
tn = length(ts:dt:te);
time = TIME(ts, dt, te);
in_prog_func = @(app) dfunc(app);
post_func = @(app) dfunc(app);
motive = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger = LOGGER(1:N+1, size(ts:dt:te, 2), 0, [], []);%分割前1,分割後N個

%=TODO=====================================================================================
% 複数機体のモデルを使わないでできるようにする．
% 単機牽引モデルの状態を用いて全て計算
%=============================================================================================

%=PAYLOAD=====================================================================================
% parameter     : DRONE_PARAM_COOPERATIVE_LOAD
% plant         : MODEL_CLASS / Model_Suspended_Cooperative_Load
% sensor        : DIRECT_SENSOR
% estimator     : DIRECT_ESTIMATOR
% reference     : TIME_VARYING_REFERENCE_SPLIT / gen_ref_sample_cooperative_load Cooperative
% controller    : CSLC / Controller_Cooperative_Load
%=============================================================================================
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
agent(1) = DRONE;
agent(1).id = 1;%元のシステム
%Payload_Initial_State
initial_state(1).p = [0; 0; 0];%ペイロード
initial_state(1).v = [0; 0; 0];%ペイロード
initial_state(1).O = [0; 0; 0];%ペイロードの角速度
initial_state(1).wi = repmat([0; 0; 0], N, 1);%ドローンの角速度
initial_state(1).Oi = repmat([0; 0; 0], N, 1);%ドローンの角速度
initial_state(1).a = [0;0;0];%ペイロード加速度
initial_state(1).dO = [0;0;0];%ペイロード角加速度

% qtype = "eul"; % "eul" : euler angle, "" : euler parameter
qtype = "zup"; % "eul":euler angle, "":euler parameter%元の論文がzdown
if contains(qtype, "zup")
    initial_state(1).qi = -1 * repmat([0;0;1], N, 1);%リンクの方向ベクトル
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

agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);
agent(1).plant = MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype));%ドローンによって質量を変えられるようにする
agent(1).sensor = DIRECT_SENSOR(agent(1),0.0); % sensor to capture plant position : second arg is noise
agent(1).estimator = DIRECT_ESTIMATOR(agent(1), struct("model", MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype)))); % estimator.result.state = sensor.result.state
% agent(1).reference = MY_WAY_POINT_REFERENCE(agent(1),generate_spline_curve_ref(readmatrix("waypoint.xlsx",'Sheet','takeOff_0to1m'),7,1));
agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",10,"orig",[0;0;1],"size",[1,1,0.5]},"Cooperative",N},agent(1));
% agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"dammy",[],"TakeOff",N},agent(1));
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
%Drone_Initial_Stat
    rho = agent(1).parameter.rho; %loadstate_rho
    R_load = RodriguesQuaternion(initial_state(1).Q);
    % initial_state(i).p = arranged_position([0, 0], 1, 1, 0);
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
    agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");%ペイロードの重さを機体数で分割するようにする!!!!!!!!!
    agent(i).plant = MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i),1,agent(i)));%id,dt,type,initial,varargin
    agent(i).sensor = DIRECT_SENSOR(agent(i),0.0); % sensor to capture plant position : second arg is noise
    %牽引ドローンの推定は完成していないので改良が必要（miyake from masterから持ってくるといいかも）
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i), 1,agent(i))), ["p", "q", "pL", "pT"],"B",blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[0.5*dt^2*eye(3);dt*eye(3)]),"Q",blkdiag(eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-4,eye(3)*1E-5)));%expの流用
    %     agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"Case_study_trajectory",{[0;0;2]},"Split",N},agent(1));
    agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"dammy",[],"Split",N},agent(1));%軌道は使われない
    agent(i).controller.hlc = HLC(agent(i),Controller_HL(dt));
    agent(i).controller.load = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.do = @controller_do;
    agent(i).controller.result.input = [(agent(i).parameter.loadmass + agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
end
% run("ExpBase");

clc
% for j = 1:te
for j = 1:tn
    % if j < 20 || rem(j, 5) == 0, disp(time.t), clc, end
        for i = 1:N+1
            if i >= 2
                load = agent(1).estimator.result.state;%推定をしていない
                %分割前ペイロード
                p_load = load.p;
                R_load = RodriguesQuaternion(load.Q);%回転行列
                dR_load = R_load*Skew(load.O);%回転行列の微分
                wi_load = load.wi(3*i-5:3*i-3,1);%分割前のagent(i)の紐の角速度ベクトル
                %分割後ペイロード
                pL_agent = p_load + R_load * rho(:,i-1);%分割後の質量重心位置
                vL_agent = load.v + dR_load * rho(:,i-1);%分割後の質量重心速度
                pT_agent = load.qi(3*i-5:3*i-3,1);%分割後の紐の方向ベクトル
                dpT_agent = Skew(wi_load)*pT_agent;%分割後の紐の速度ベクトル
                %ドローン
                p_agent = p_load + R_load * rho(:,i-1) - agent(1).parameter.li(i-1)*pT_agent;
                v_agent = load.v + dR_load * rho(:,i-1)- agent(1).parameter.li(i-1)*dpT_agent;
                q_agent = Quat2Eul(load.Qi(4*i-7:4*i-4,1));
                w_agent = load.Oi(3*i-5:3*i-3,1);

                sensor1 = agent(1).sensor.result.state;%複数機モデルから機体と接続点の位置を計測
                %分割前ペイロード
                sp = sensor1.p;
                sR = RodriguesQuaternion(sensor1.Q);%回転行列
                %分割後ペイロード
                spL = sp + sR * rho(:,i-1);%分割後の質量重心位置
                spT = sensor1.qi(3*i-5:3*i-3,1);%分割後の紐の方向ベクトル
                %ドローン
                spDrone = sp + sR * rho(:,i-1) - agent(1).parameter.li(i-1)*spT;
                sqDrone = Quat2Eul(sensor1.Qi(4*i-7:4*i-4,1));

                %agent(i).estimator.result.state.set_stateを使った方が正しい？
                %単機牽引のモデルで推定する
                agent(i).sensor.do(time, 'f');
                agent(i).sensor.result.state.set_state("p",spDrone,"q",sqDrone,"pL",spL,"pT",spT);
                agent(i).estimator.do(time, 'f');
                %複数牽引モデルの状態をそのまま単機牽引モデルに入れる
                % agent(i).estimator.result.state.set_state("pL",pL_agent,"vL",vL_agent);
                % agent(i).estimator.result.state.set_state("pT",pT_agent,"wL",wi_load);
                % agent(i).estimator.result.state.set_state("p",p_agent,"v",v_agent);
                % agent(i).estimator.result.state.set_state("q",q_agent,"w",w_agent);
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
        
        %複数牽引モデルの状態をそのまま単機牽引モデルに入れる場合
        agent(1).plant.do(time, 'f');
        %単機牽引のモデルで推定する
        % for i = 2:N
        %     agent(i).plant.do(time, 'f');
        % end
        logger.logging(time, 'f', agent);
        disp(time.t)
        time.t = time.t + time.dt;
    %pause(1)
end
clc
disp(time.t)
%%
% close all
run("DataPlot.m")
%%
%理想的な張力の方向を描画できるようにする!!!!!!!!!!!!!!!!!
% close all
% mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
% mov.animation(logger, 'target', 1:N, "gif",true,"lims",[-3 3;-3 3;0 4],"ntimes",5);
mov = DRAW_COOPERATIVE_DRONES(log_T8, "self", agent_T8, "target", 1:6);
mov.animation(log_T8, 'target', 1:6, "gif",true,"lims",[-3 3;-3 3;0 4],"ntimes",5);

% 
% %%
logger.plot({1,"plant.result.state.qi","p"},{1,"p","er"},{1, "v", "p"},{1, "input", "p"},{1, "plant.result.state.Qi","p"})
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
