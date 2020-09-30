%% Drone 班用共通プログラム
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
%% general setting
N = 1; % number of agents
fExp = 1;
if fExp
    
    dt = 0.025; % sampling time
else
    dt = 0.1; % sampling time
end
sampling = dt;
ts=0;
if fExp
    te=1000;
else
    te=10;
end


%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
if fExp
    typical_Model_Lizard_exp(N,dt,'plant',24); % Lizard : for exp % 機体番号（ESPrの番号）
else
    %typical_Model_EulerAngle(N,dt,'plant',struct('noise',7.058E-5))sa
    typical_Model_Quat13(N,dt,'plant'); % unit quaternionのプラントモデル : for sim
    %typical_Model_Discrete0(N,dt,'plant') % 離散時間質点モデル : Direct controller を想定
    %typical_Model_Discrete(N,dt,'plant') % 離散時間質点モデル : PD controller などを想定
end
% set control model
typical_Model_EulerAngle(N,dt,'model'); % オイラー角モデル
%typical_Model_Quat13(N,dt,'model') % オイラーパラメータ（unit quaternion）モデル
%typical_Model_Discrete0(N,dt,'model') % 離散時間モデル：位置＝入力 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
%typical_Model_Discrete(N,dt,'model') % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする

%% set input_transform property
for i = 1:N
    if fExp%isa(agent(i).plant,"Lizard_exp")
        typical_InputTransform_Thrust2Throttle_drone(agent(i)); % 推力からスロットルに変換
    end
end
%agent.plant.espr.sendData(Pw(1,1:16));
% for quat-model plant with discrete control model
%typical_InputTransform_REFtoHL_drone(agent); % 位置指令から４つの推力に変換
%typical_InputTransform_toHL_drone(agent); % modelを使った１ステップ予測値を目標値として４つの推力に変換
% １ステップ予測値を目標とするのでゲインをあり得ないほど大きくしないとめちゃめちゃスピードが遅い結果になる．
%% set environment property
Env = [];
%typical_Env_2DCoverage(agent); % 重要度マップ設定
%% set sensors property
for i = 1:N; agent(i).sensor=[]; end
%typical_Sensor_LSM9DS1(agent); % IMU sensor
typical_Sensor_Motive(agent); % motive情報 : sim exp 共通
%typical_Sensor_Direct(agent); % 状態真値(plant.state)　：simのみ
%typical_Sensor_RangePos(agent,10); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
%typical_Sensor_RangeD(agent,2); %  半径r (第二引数) 内の重要度を計測 : sim のみ
% for i = 1:N % simのみ
%     sensor.type= "LiDAR_sim";
%     sensor.name="lrf";sensor.param=[];agent(i).set_sensor(sensor);
% end
%% set estimator property
for i = 1:N; agent(i).estimator=[]; end
%typical_Estimator_LPF(agent); % lowpass filter
typical_Estimator_AD(agent); % 後退差分近似で速度，角速度を推定
%typical_Estimator_feature_based_EKF(agent); % 特徴点ベースEKF
%typical_Estimator_PDAF(agent); % 特徴点ベースPDAF
%typical_Estimator_EKF(agent); % （剛体ベース）EKF
%typical_Estimator_Direct(agent); % Directセンサーと組み合わせて真値を利用する　：sim のみ
%for i = 1:N;agent(i).set_property("estimator",struct('type',"Map_Update",'name','map','param',[]));end % map 更新用 重要度などのmapを時間更新する
%% set reference property
for i = 1:N; agent(i).reference=[]; end
%typical_Reference_2DCoverage(agent,Env); % Voronoi重心
%typical_Reference_Time_Varying(agent,"gen_ref_saddle",{5,[0;0;1.5],[2,2,1]}); % 時変な目標状態

% 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
typical_Reference_Point_FH(agent); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
for i = 1:N; agent(i).controller=[]; end
typical_Controller_HL(agent); % 階層型線形化
%typical_Controller_MEC(agent); % Model Error Compensator  :  未実装
%for i = 1:N;  Controller.type="MPC_controller";Controller.name = "mpc";Controller.param={agent(i)}; agent(i).set_controller(Controller);end
%for i = 1:N;  Controller.type="DirectController"; Controller.name="direct";Controller.param=[];agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
%for i = 1:N;  Controller.type="PDController"; Controller.name="pd";Controller.param=struct("P",-1*diag([1,1,3]),"D",-1*diag([1,1,3]));agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする

%% set connector (global instance)
if fExp
    typical_Connector_Natnet(struct('ClientIP','192.168.1.5')); % Motive
else
    typical_Connector_Natnet_sim(N,dt,0); % 3rd arg is a flag for noise (1 : active )
end

%% initialize
if ~fExp
    % for sim : 整列した初期値
    base_pos=[0 0]; % 基準位置
    kpos=ceil(sqrt(N));
    cpos=floor(N/kpos);
    rempos=mod(N,kpos);
    [xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
    gap=1; % エージェントの間隔
    xpos=gap*xpos;
    ypos=gap*ypos;
    arranged_initial_pos=base_pos-[gap gap]+[reshape(xpos,[N-rempos,1]),reshape(ypos,[N-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];
end

if exist('motive')==1; motive.getData({agent,[]});end
disp("Initialize state");
for i = 1:N
    if fExp
        % for exp with motive : initialize by motive info
        agent(i).sensor.motive.do({motive});
        sstate = agent(i).sensor.motive.result.state;
        model.initial = struct('p',sstate.p,'q',sstate.q,'v',[0;0;0],'w',[0;0;0]);
        agent(i).model.set_state(model.initial);
%        agent(i).estimator.result.state.set_state(model.initial);
    else
        % for sim
        plant.initial = struct('p',[arranged_initial_pos(i,:),0]','q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0]);
        agent(i).state.set_state(plant.initial);
        agent(i).model.set_state(plant.initial);
        for j = 1:length(agent(i).estimator.name)
            if isfield(agent(i).estimator.(agent(i).estimator.name(j)),'result')
                agent(i).estimator.(agent(i).estimator.name(j)).result.state.set_state(plant.initial);
            end
        end
    end
end

LogData=[
    "reference.result.state.p",
    "estimator.result.state.p",
    "estimator.result.state.q",
    "estimator.result.state.v",
    "estimator.result.state.w",
    "sensor.result.state.p",
    "sensor.result.state.q",
    "sensor.result.state.v",
    "sensor.result.state.w",
    %    "reference.result.state.xd",
%     "input_transform.t2t.flight_phase",
    "inner_input",
    "input"
    ];
if ~isempty(agent(1).plant.state)
    LogData=["plant.state.p";LogData]; % 実制御対象の位置
    if isprop(agent(1).plant.state,'q')
        LogData=["plant.state.q";LogData]; % 実制御対象の姿勢
    end
end
if exist('motive')==1 % motiveを利用している場合
    LogData=[LogData;    "sensor.result.dt"]; % センサー内周期
end
if isfield(agent(1).reference,'covering')
    LogData=[LogData;    "reference.result.region";"env.density.param.grid_density"]; % for coverage
end
logger=Logger(agent,size(ts:dt:te,2),LogData);
time =  Time();
time.t = ts;
%%  各種do methodの引数設定
% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

% for simulation
mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
mparam.occlusion.target={[1],[1]};
mparam.marker_num = 20;
mparam=[]; % without occulusion
%% main loop
%profile on
disp("while ============================")
close all;
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');

w = waitforbuttonpress;

try
    while round(time.t,5)<=te
        %while 1 % for exp
        %% sensor
        tic
        if exist('motive')==1; motive.getData({agent,mparam});end
        if exist('motive')==1; Smotive={motive};end
        Srpos={agent};
        Simu={[]};
        Sdirect={};
        Srdensity={Env};
        Slrf=Env;
        for i = 1:N
            param(i).sensor=arrayfun(@(k) evalin('base',strcat("S",agent(i).sensor.name(k))),1:length(agent(i).sensor.name),'UniformOutput',false);
            agent(i).do_sensor(param(i).sensor);
        end
        
        %% estimator, reference generator, controller
        for i = 1:N
            agent(i).do_estimator(cell(1,10));
            
            Rcovering={};%{Env};
            %Rpoint={FH,[0;0;0.5]};
            Rpoint={FH,[agent.state.p+[0;0;0];agent.state.q(3)]};%+pi/2
            
            RtimeVarying={time};
            param(i).reference=arrayfun(@(k) evalin('base',strcat("R",agent(i).reference.name(k))),1:length(agent(i).reference.name),'UniformOutput',false);
            agent(i).do_reference(param(i).reference);
            
            agent(i).do_controller(cell(1,10));
        end
        %% logging
        calculation=toc;
        if fExp
            time.t = time.t+ calculation; % for exp
        else
            time.t = time.t + dt % for sim
        end
        logger.logging(time.t);
        %% update state
        % with FH
        figure(FH)
        drawnow
        for i = 1:N % 状態更新
            model_param.param=agent(i).model.param;
            model_param.FH = FH;
            if isempty(agent(i).input_transform)        % input_transform上でmodelの更新をするのでinput_transformをする場合はdo_modelしない
                agent(i).do_model(model_param);
            end
            
            model_param.param=agent(i).plant.param;
            agent(i).do_plant(model_param);
        end
        % for exp
        if fExp
            wait_time =  0.9999*(sampling-calculation);
           if wait_time <0
               wait_time
               warning("ACSL : sampling time is too short.");
           end
            time.t = time.t + wait_time;
%            time.t = time.t + calculation;
            %pause(wait_time);  %　センサー情報取得から制御入力印加までを早く保ちつつ，周期をできるだけ一定に保つため
        end
    end
catch ME    % for error 
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH',FH),"emergency");
    end
    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%profile viewer
%%
%% plot
%%
if isfield(agent(1).reference,'covering')
    rp=strcmp(logger.items,'reference.result.state.p');
    ep=strcmp(logger.items,'estimator.result.state.p');
    %sp=strcmp(logger.items,'sensor.result.state.p');
    sp=strcmp(logger.items,'plant.state.p');
    regionp=strcmp(logger.items,'reference.result.region');
    gridp=strcmp(logger.items,'env.density.param.grid_density');
    tmpref=@(k,span) arrayfun(@(i)logger.Data.agent{k,rp,i}(1:3),span,'UniformOutput',false);
    tmpest=@(k,span) arrayfun(@(i)logger.Data.agent{k,ep,i}(1:3),span,'UniformOutput',false);
    tmpsen=@(k,span) arrayfun(@(i)logger.Data.agent{k,sp,i}(1:3),span,'UniformOutput',false);
    %make_gif(1:1:ke,1:N,@(k,span) draw_voronoi(arrayfun(@(i)  logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmppos(k,span),tmpref(k,span)],Vertices),@() Env.draw,fig_param);
    make_animation(1:10:logger.i-1,1:N,@(k,span) draw_voronoi(arrayfun(@(i) logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmpsen(k,span),tmpref(k,span),tmpest(k,span)],Env.param.Vertices),@() Env.show);
    %%
    %    make_animation(1:10:logger.i-1,1,@(k,span) contourf(Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,span}),@() Env.show_setting());
    make_animation(1:10:logger.i-1,1,@(k,span) arrayfun(@(i) contourf( Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,i}),span,'UniformOutput',false), @() Env.show_setting());
end
%%
close all
logger.plot(1,["inner_input"],struct('transpose',1));
%logger.plot(1,["p","q","v","input","plant.state.p"]);
%logger.plot(1,["sensor.result.state.p","estimator.result.state.p","reference.result.state.p","sensor.result.state.q","estimator.result.state.q","input"]);
logger.plot(1,["estimator.result.state.p","estimator.result.state.w","reference.result.state.p","estimator.result.state.v","u","inner_input"]);
%logger.plot(1,["p","q","v","w","u"],struct('time',170));
%logger.plot(1,["sensor.imu.result.state.q","sensor.imu.result.state.w","sensor.imu.result.state.a"]);
%%
%logger.plot(1,["reference.result.state.xd","reference.result.state.p"],struct('time',10));

%%
logger.save();
