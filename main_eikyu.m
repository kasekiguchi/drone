%% Drone 班用共通プログラム test
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
N = 3; % number of agents
fExp = 0 %1：実機　それ以外：シミュレーション
fMotive = 0;% Motiveを使うかどうか
fROS = 0;
fOffline = 0; % offline verification with experiment data
if fExp
    dt = 0.025; % sampling time
else
%     dt = 0.1; % sampling time
%     dt = 0.005;
    dt = 0.025;
%     dt = 0.010;
%     dt = 0.001;
end
sampling = dt;
ts=0;
if fExp
    te=1000;
else
    te=5;
end
%% set connector (global instance)
if fExp
    if fMotive
        rigid_ids = [1];
        Connector_Natnet(struct('ClientIP','192.168.1.5','rigid_list',rigid_ids)); % Motive
    end
else
    if fMotive
        Connector_Natnet_sim(N,dt,0); % 3rd arg is a flag for noise (1 : active )
        %Connector_Natnet_sim(2*N,dt,0); % for suspended load
    end
end
%% initialize
disp("Initialize state");
initial(N) = struct;
param(N) = struct('sensor',struct,'estimator',struct,'reference',struct);
if fExp
    if exist('motive','var')==1; motive.getData([],[]);end
    for i = 1:N
        % for exp with motive : initialize by motive info
        if exist('motive','var')==1
            sstate = motive.result.rigid(rigid_ids(i));
            initial(i).p = sstate.p;
            initial(i).q = sstate.q;
            initial(i).v = [0;0;0];
            initial(i).w = [0;0;0];
        else % とりあえず用
            arranged_pos = arranged_position([0,0],N,1,0);
            initial(i).p = arranged_pos(:,i);
            initial(i).q = [1;0;0;0];
            initial(i).v = [0;0;0];
            initial(i).w  =  [0;0;0];
        end
    end
else
    
    if (fOffline)
        %%
        expdata=DATA_EMULATOR("isobe_HLonly_Log(18-Dec-2020_12_17_35)"); % 空の場合最新のデータ
    end
    %% for sim
    for i = 1:N
        if (fOffline)
            initial(i).p = expdata.Data{1}.agent{1,expdata.si,i}.state.p;
            initial(i).q = expdata.Data{1}.agent{1,expdata.si,i}.state.q;
            initial(i).v = [0;0;0];
            initial(i).w = [0;0;0];
        else
            arranged_pos = arranged_position([0,0],N,1,0);
            initial(i).p = arranged_pos(:,i);
            initial(i).q = [1;0;0;0];
            initial(i).v = [0;0;0];
            initial(i).w  =  [0;0;0];
        end
    end
end
for i = 1:N
    %% generate Drone instance
    % Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
    if fExp
        agent(i) = Drone(Model_Lizard_exp(dt,'plant',initial(i),"udp",[i+24])); % Lizard : for exp % 機体番号（ESPrのIP）
        %agent(i) = Drone(Model_Lizard_exp(dt,'plant',initial(i),"serial",[5])); % Lizard : for exp % 機体番号（ESPrのCOM番号）
        %agent(i) = Whill(Model_Whill_exp(dt,'plant',initial(i),"ros",[21])); % Lizard : for exp % 機体番号（ESPrのIP）
        agent(i).input = [0;0;0;0];
    else
        agent(i) = Drone(Model_Quat13(i,dt,'plant',initial(i))); % unit quaternionのプラントモデル : for sim
        %agent(i) = Drone(Model_EulerAngle(i,dt,'plant',initial(i))); % euler angleのプラントモデル : for sim
        %agent(i) = Drone(Model_Suspended_Load(i,dt,'plant',initial(i))); % 牽引物込みのプラントモデル : for sim
        %agent(i) = Drone(Model_Discrete0(i,dt,'plant',initial(i))); % 離散時間質点モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定
        %agent(i) = Drone(Model_Discrete(i,dt,'plant',initial(i))); % 離散時間質点モデル : PD controller などを想定
    end
    %% model
    % set control model
    %agent(i).set_model(Model_EulerAngle(i,dt,'model',initial(i))); % オイラー角モデル
    %agent(i).set_model(Model_Quat13(i,dt,'model',initial(i))); % オイラーパラメータ（unit quaternion）モデル
    %agent(i).set_model(Model_Suspended_Load_Euler(i,dt,'model',initial(i))); % unit quaternionのプラントモデル : for sim
    %agent(i).set_model(Model_Suspended_Load(i,dt,'model',initial(i))); % unit quaternionのプラントモデル : for sim
    agent(i).set_model(Model_Discrete0(i,dt,'model',initial(i))) % 離散時間モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
    %agent(i).set_model(Model_Discrete(i,dt,'model',initial(i))) % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
    close all
    %% set input_transform property
    if fExp%isa(agent(i).plant,"Lizard_exp")
        agent(i).input_transform=[];
        agent(i).set_property("input_transform",InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
    end
    %agent.plant.espr.sendData(Pw(1,1:16));
    % for quat-model plant with discrete control model
    agent(i).set_property("input_transform",InputTransform_REFtoHL_drone(dt)); % 位置指令から４つの推力に変換 : Direct controller（入力＝目標位置） を想定
    %agent(i).set_property("input_transform",InputTransform_toHL_drone(dt)); % modelを使った１ステップ予測値を目標値として４つの推力に変換
    % １ステップ予測値を目標とするのでゲインをあり得ないほど大きくしないとめちゃめちゃスピードが遅い結果になる．
    %agent(i).set_property("input_transform",struct("type","Thrust2ForceTorque","name","toft","param",1)); % 1: 各モータ推力を[合計推力，トルク入力]へ変換，　2: 1の逆
    %% set environment property
    Env = [];
    agent(i).set_property("env",Env_2DCoverage(i)); % 重要度マップ設定
    %% set sensors property
    agent(i).sensor=[];
    %agent(i).set_property("sensor",Sensor_LSM9DS1()); % IMU sensor
    if fMotive
        agent(i).set_property("sensor",Sensor_Motive(i)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
    end
    if fROS
        agent(i).set_property("sensor",Sensor_ROS(struct('ROSHostIP','192.168.50.21')));
    end
    
    agent(i).set_property("sensor",Sensor_Direct()); % 状態真値(plant.state)　：simのみ
    agent(i).set_property("sensor",Sensor_RangePos(i,10)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
    agent(i).set_property("sensor",Sensor_RangeD(2)); %  半径r (第二引数) 内の重要度を計測 : sim のみ
    %agent(i).set_property("sensor",struct("type","LiDAR_sim","name","lrf","param",[]));
    %% set estimator property
    agent(i).estimator=[];
    %agent(i).set_property("estimator",Estimator_Suspended_Load([i,i+N])); %
    %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q","pL","pT"],[1e-5,1e-5,1e-5,1e-7])); % （剛体ベース）EKF
    %agent(i).set_property("estimator",Estimator_LPF(agent(i))); % lowpass filter
    %agent(i).set_property("estimator",Estimator_AD()); % 後退差分近似で速度，角速度を推定　シミュレーションこっち
%     agent(i).set_property("estimator",Estimator_feature_based_EKF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースEKF
%     agent(i).set_property("estimator",Estimator_PDAF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースPDAF
    %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q"],[1e-5,1e-8])); % （剛体ベース）EKF
    agent(i).set_property("estimator",Estimator_Direct()); % Directセンサーと組み合わせて真値を利用する　：sim のみ
    agent(i).set_property("estimator",struct('type',"Map_Update",'name','map','param',[])); % map 更新用 重要度などのmapを時間更新する
    %% set reference property
    agent(i).reference=[];
    agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env)); % Voronoi重心
%     agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{5,[0;0;1.5],[2,2,1]})); % 時変な目標状態
    % agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{7,[0;0;1],[1,0.5,0]})); % 時変な目標状態
    %agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{10,[0;0;1.5],[1,1,0.]}));
%     agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    %agent(i).set_property("reference",Reference_Time_Varying_Suspended_Load("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
%     if fExp == 1
%         if i ==1
%             agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[-1;0;1])); % ハート形[x;y;z]永久
%         else
%             agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0.5;0;1])); % ハート形[x;y;z]永久
%         end
%     else
%          if i ==1
%             agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0;0;0])); % ハート形[x;y;z]永久
%         else
%             agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0.5;0;1])); % ハート形[x;y;z]永久
%         end
%     end
%     agent(i).set_property("reference",Reference_Wall_observation()); % ハート形[x;y;z]永久
    
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller=[];
    %agent(i).set_property("controller",Controller_FT(dt)); % 階層型線形化
%     agent(i).set_property("controller",Controller_HL(dt)); % 階層型線形化
    %agent(i).set_property("controller",Controller_HL_Suspended_Load(dt)); % 階層型線形化
    %agent(i).set_property("controller",Controller_MEC()); % 実入力へのモデル誤差補償器
    % agent(i).set_property("controller",Controller_HL_MEC(dt);% 階層型線形化＋MEC
    %agent(i).set_property("controller",Controller_HL_ATMEC(dt));%階層型線形化+AT-MEC
    %agent(i).set_property("controller",struct("type","MPC_controller","name","mpc","param",{agent(i)}));
    agent(i).set_property("controller",struct("type","DirectController","name","direct","param",[]));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %agent(i).set_property("controller",struct("type","PDController","name","pd","param",struct("P",-1*diag([1,1,3]),"D",-1*diag([1,1,3]))));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %%
    param(i).sensor.list = cell(1,length(agent(i).sensor.name));
    param(i).reference.list = cell(1,length(agent(i).reference.name));
end
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData=[
    "model.state.p"
    "controller.result"
    ];
if isfield(agent(1).reference,'covering')
    LogData=[LogData;     'reference.result.region';  "env.density.param.grid_density"]; % for coverage
end
logger=Logger(agent,size(ts:dt:te,2),LogData);
%%
time =  Time();
time.t = ts;
%%
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
if fExp && ~fMotive
    fprintf(2,"Warning : input will send to drone\n");
end
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');

w = waitforbuttonpress;

try
    if (fOffline)
        expdata.overwrite("model",time.t,agent,i);
        te = expdata.te;
        offline_time = 1;
    end
    while round(time.t,5)<=te
        %while 1 % for exp
        %% sensor
        tic
        if (fOffline)
            expdata.overwrite("plant",time.t,agent,i);
            FH.CurrentCharacter = char(expdata.Data{1}.phase(offline_time));
            time.t = expdata.Data{1}.t(offline_time);
            offline_time = offline_time + 1;
        end
        if fMotive
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent,mparam);
        end
        for i = 1:N
            if fMotive;param(i).sensor.motive={motive};end
            param(i).sensor.rpos={agent};
            param(i).sensor.imu={[]};
            param(i).sensor.direct={};
            param(i).sensor.rdensity={Env};
            param(i).sensor.lrf=Env;
            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j}=param(i).sensor.(agent(i).sensor.name(j));
            end
            agent(i).do_sensor(param(i).sensor.list);
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end
        
        %% estimator, reference generator, controller
        for i = 1:N
            agent(i).do_estimator(cell(1,10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            param(i).reference.covering={};%{Env};
            param(i).reference.point={FH,[2;1;0.5],time.t};
            param(i).reference.timeVarying={time};
            param(i).reference.tvLoad={time};
            param(i).reference.wall={1};
            
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j}=param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end
            
            agent(i).do_controller({time.t,cell(1,9)});
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
        %           agent(1).reference.wall.show(); % 機体の移動を毎時刻表示する
        
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
            % これをやるとpause中が不安定になる．どうしても一定時間にしたいならwhile でsamplingを越えるのを待つなどすればよいかも．
            % それよりは推定などで，calculationを意識した更新をしてあげた方がよい？
            %                time.t = time.t + sampling;
            %            end
        else
            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim
            end
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
agent(1).reference.covering.draw_movie(logger,N,Env)
% agent(1).reference.timeVarying.show(logger)
%logger.plot(1,["pL","p","q","w","v","input"],["er","er","e","e","e",""],struct('time',[]));
%logger.plot(1,["pL","p","q","v","u","inner_input"],["p","ser","se","e","",""]);
%logger.plot(1,["p","pL","pT","q","v","w"],["se","serp","ep","sep","e","e"]);
% logger.plot(1,["p","q","v","w","u","inner_input"],["e","e","e","e","",""]);

% logger.plot(1,["p1:3","v","w","q","input"],["ser","e","e","s",""]);
%logger.plot(1,["p","input","q1:2:4"],["se","","e"],struct('time',10));
%  logger.plot(1,["p1-p2-p3","pL1-pL2"],["sep","p"],struct('fig_num',2,'row_col',[1 2]));
% logger.plot(1,["p1-p2-p3"],["sep"],struct('fig_num',2,'row_col',[1 2]));
%logger.plot(1,["sensor.imu.result.state.q","sensor.imu.result.state.w","sensor.imu.result.state.a"]);
%logger.plot(1,["xd1:3","p"],["r","r"],struct('time',12));
%logger.plot(1,["p","q"],["er","er"]);

%%
%logger.save();
