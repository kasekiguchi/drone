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
fExp = 0;%1：実機　それ以外：シミュレーション
fOffline = 0; % offline verification with experiment data
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
    te=25;
end


%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
if fExp
    Model_Lizard_exp(N,dt,'plant',"udp",[24]); % Lizard : for exp % 機体番号（ESPrのIP）
    %Model_Lizard_exp(N,dt,'plant',"serial",[5]); % Lizard : for exp % 機体番号（ESPrのCOM番号）
else
    Model_Quat13(N,dt,'plant'); % unit quaternionのプラントモデル : for sim
    %Model_Suspended_Load(N,dt,'plant'); % unit quaternionのプラントモデル : for sim
    %Model_Discrete0(N,dt,'plant') % 離散時間質点モデル : Direct controller を想定
    %Model_Discrete(N,dt,'plant') % 離散時間質点モデル : PD controller などを想定
end
% set control model
%Model_EulerAngle(N,dt,'model'); % オイラー角モデル
Model_Quat13(N,dt,'model') % オイラーパラメータ（unit quaternion）モデル
%Model_Suspended_Load(N,dt,'model'); % unit quaternionのプラントモデル : for sim
%Model_Discrete0(N,dt,'model') % 離散時間モデル：位置＝入力 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
%Model_Discrete(N,dt,'model') % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
close all
%% set input_transform property
for i = 1:N
    if fExp%isa(agent(i).plant,"Lizard_exp")
        InputTransform_Thrust2Throttle_drone(agent(i)); % 推力からスロットルに変換
    end
end
%agent.plant.espr.sendData(Pw(1,1:16));
% for quat-model plant with discrete control model
%InputTransform_REFtoHL_drone(agent); % 位置指令から４つの推力に変換
%InputTransform_toHL_drone(agent); % modelを使った１ステップ予測値を目標値として４つの推力に変換
% １ステップ予測値を目標とするのでゲインをあり得ないほど大きくしないとめちゃめちゃスピードが遅い結果になる．
%% set environment property
Env = [];
%Env_2DCoverage(agent); % 重要度マップ設定
%% set sensors property
for i = 1:N; agent(i).sensor=[]; end
%Sensor_LSM9DS1(agent); % IMU sensor
Sensor_Motive(agent,{1,2,3}); % motive情報 : sim exp 共通
%Sensor_Direct(agent); % 状態真値(plant.state)　：simのみ
%Sensor_RangePos(agent,10); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
%Sensor_RangeD(agent,2); %  半径r (第二引数) 内の重要度を計測 : sim のみ
% for i = 1:N % simのみ
%     sensor.type= "LiDAR_sim";
%     sensor.name="lrf";sensor.param=[];agent(i).set_sensor(sensor);
% end
%% set estimator property
for i = 1:N; agent(i).estimator=[]; end
%Estimator_LPF(agent); % lowpass filter
% Estimator_AD(agent); % 後退差分近似で速度，角速度を推定　シミュレーションこっち
%Estimator_feature_based_EKF(agent); % 特徴点ベースEKF
%Estimator_PDAF(agent); % 特徴点ベースPDAF
Estimator_EKF(agent,["p","q"],[1e-5,1e-8]); % （剛体ベース）EKF
%Estimator_Direct(agent); % Directセンサーと組み合わせて真値を利用する　：sim のみ
%for i = 1:N;agent(i).set_property("estimator",struct('type',"Map_Update",'name','map','param',[]));end % map 更新用 重要度などのmapを時間更新する
%% set reference property
for i = 1:N; agent(i).reference=[]; end
%Reference_2DCoverage(agent,Env); % Voronoi重心
%Reference_Time_Varying([1],agent,"gen_ref_saddle",{5,[0;0;1.5],[2,2,1]}); % 時変な目標状態
% Reference_Time_Varying([1],agent,"gen_ref_saddle",{7,[0;0;1],[1,0.5,0]}); % 時変な目標状態
Reference_Time_Varying([1],agent,"Case_study_trajectory",[1;0;1]); % ハート形[x;y;z]永久
%Reference_Time_Varying_Suspended_Load([1],agent,"Case_study_trajectory",[1;0;1]); % ハート形[x;y;z]永久

% 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
Reference_Point_FH(agent); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
for i = 1:N; agent(i).controller=[]; end
%Controller_HL(agent); % 階層型線形化
Controller_FT(agent); % 階層型線形化
%Controller_HL_Suspended_Load(agent); % 階層型線形化
%Controller_MEC(agent); % Model Error Compensator  :  未実装
%for i = 1:N;  Controller.type="MPC_controller";Controller.name = "mpc";Controller.param={agent(i)}; agent(i).set_controller(Controller);end
%for i = 1:N;  Controller.type="DirectController"; Controller.name="direct";Controller.param=[];agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
%for i = 1:N;  Controller.type="PDController"; Controller.name="pd";Controller.param=struct("P",-1*diag([1,1,3]),"D",-1*diag([1,1,3]));agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする

%% set connector (global instance)
if fExp
    Connector_Natnet(struct('ClientIP','192.168.1.7','rigid_list',[1])); % Motive
else
    Connector_Natnet_sim(N,dt,0); % 3rd arg is a flag for noise (1 : active )
    %Connector_Natnet_sim(2*N,dt,0); % for suspended load
end
%% initialize
disp("Initialize state");
if fExp
    if exist('motive')==1; motive.getData({agent,[]});end
    for i = 1:N
        agent(i).input = [0;0;0;0];
        % for exp with motive : initialize by motive info
        if isfield(agent(i).sensor,'motive'); agent(i).sensor.motive.do({motive});end
        sstate = agent(i).sensor.motive.result.state;
        model.initial = struct('p',sstate.p,'q',sstate.q,'v',[0;0;0],'w',[0;0;0]);
        agent(i).model.set_state(model.initial);
        for j = 1:length(agent(i).estimator.name)
            if isprop(agent(i).estimator.(agent(i).estimator.name(j)),'result')
                agent(i).estimator.(agent(i).estimator.name(j)).result.state.set_state(model.initial);
            end
        end
        initp = sstate.p;
        initq = sstate.q;
    end
else
    
    %%
    if (fOffline)
        Data = load("Log(21-Oct-2020_18_22_35).mat").Data;
        expdata=DATA_EMULATOR(Data);
    end
    % for sim
    arranged_pos = arranged_position([0,0],N,1,0);
    for i = 1:N
        if (fOffline)
            expdata.overwrite("sensor",0,agent,i);
            plant.initial = struct('p',agent.sensor.result.state.p,'q',agent.sensor.result.state.q,'v',[0;0;0],'w',[0;0;0]);
        else
            plant.initial = struct('p',arranged_pos(:,i),'q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0]);
        end
        agent(i).state.set_state(plant.initial);
        agent(i).model.set_state(plant.initial);
        for j = 1:length(agent(i).estimator.name)
            if isprop(agent(i).estimator.(agent(i).estimator.name(j)),'result')
                agent(i).estimator.(agent(i).estimator.name(j)).result.state.set_state(plant.initial);
            end
        end
  %          agent(i).model.initialize(sload,plant.initial.p);    
    end
end
LogData=[
    "model.state.p",
    "reference.result.state.p",
    %"reference.result.state.q",
    "estimator.result.state.p",
    "estimator.result.state.q",
    "estimator.result.state.v",
    "estimator.result.state.w",
    %"estimator.result.Mhat",
    "sensor.result.state.p",
    "sensor.result.state.q",
    %"sensor.result.state.v",
    %"sensor.result.state.w",
    %    "reference.result.state.xd",
    %     "input_transform.t2t.flight_phase",
    %"inner_input",
    "input"
    ];
if ~isempty(agent(1).plant.state)
    LogData=["plant.state.p";LogData]; % 実制御対象の位置
    if isprop(agent(1).plant.state,'q')
        LogData=["plant.state.q";LogData]; % 実制御対象の姿勢
    end
end
if exist('motive')==1 && (fExp) % motiveを利用している場合
    LogData=[LogData;    "sensor.result.dt"]; % センサー内周期
end
if isfield(agent(1).reference,'covering')
    LogData=[LogData;    "reference.result.region";"env.density.param.grid_density"]; % for coverage
end
logger=Logger(agent,size(ts:dt:te,2),LogData);
%%
time =  Time();
time.t = ts;
%%  各種do methodの引数設定
% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

% % for simulation
% mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
% mparam.occlusion.target={[1],[1]};
% mparam.marker_num = 20;
mparam=[]; % without occulusion


%% main loop
%profile on
disp("while ============================")
close all;
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');

w = waitforbuttonpress;

try
    if (fOffline);    expdata.overwrite("model",time.t,agent,i);end
    while round(time.t,5)<=te
        %while 1 % for exp
        %% sensor
        tic
        if (fOffline);    expdata.overwrite("plant",time.t,agent,i);end
        if exist('motive')==1
            motive.getData({agent,mparam});
            Smotive={motive};
        end
        Srpos={agent};
        Simu={[]};
        Sdirect={};
        Srdensity={Env};
        Slrf=Env;
        for i = 1:N
            param(i).sensor=arrayfun(@(k) evalin('base',strcat("S",agent(i).sensor.name(k))),1:length(agent(i).sensor.name),'UniformOutput',false);
            agent(i).do_sensor(param(i).sensor);
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end
        
        %% estimator, reference generator, controller
        for i = 1:N
            agent(i).do_estimator(cell(1,10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            Rcovering={};%{Env};
            Rpoint={FH,[0;0;0.5],time.t};
            RtimeVarying={time};
            RtvLoad={time};
            param(i).reference=arrayfun(@(k) evalin('base',strcat("R",agent(i).reference.name(k))),1:length(agent(i).reference.name),'UniformOutput',false);
            agent(i).do_reference(param(i).reference);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end
            
            agent(i).do_controller(cell(1,10));
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end
        %% update state
        % with FH
        figure(FH)
        drawnow
        for i = 1:N % 状態更新
            model_param.param=agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param);
            
            model_param.param=agent(i).plant.param;
            agent(i).do_plant(model_param);
        end
        %% logging
        calculation=toc;
        
        logger.logging(time.t,FH);
        % for exp
        if fExp
            wait_time =  0.9999*(sampling-calculation);
            if wait_time <0
                wait_time
                warning("ACSL : sampling time is too short.");
            end
            time.t = time.t + calculation;
            %            else
            %                pause(wait_time);  %　センサー情報取得から制御入力印加までを早く保ちつつ，周期をできるだけ一定に保つため
            %                time.t = time.t + sampling;
            %            end
        else
            time.t = time.t + dt % for sim
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
close all
clc
%agent(1).reference.covering.draw_movie(logger,N,Env)
%agent(1).reference.timeVarying.show(logger)
% logger.plot(1,["inner_input"],struct('transpose',1));
%logger.plot(1,["reference.result.state.pL","p","q","w","v","input"],struct('time',[]));%,"inner_input"    ]);
% logger.plot(1,["sensor.result.state.p","estimator.result.state.p","reference.result.state.p","sensor.result.state.q","estimator.result.state.q","input"]);
% logger.plot(1,["estimator.result.state.p","estimator.result.state.w","reference.result.state.p","estimator.result.state.v","u","inner_input"]);
 logger.plot(1,["p","q","v","w"],struct('time',[]));
%logger.plot(1,["sensor.imu.result.state.q","sensor.imu.result.state.w","sensor.imu.result.state.a"]);
%logger.plot(1,["reference.result.state.xd","reference.result.state.p"],struct('time',10));
%logger.plot(1,["sensor.result.state.p","estimator.result.state.p","sensor.result.state.q","estimator.result.state.q"]);

%%
%logger.save();
