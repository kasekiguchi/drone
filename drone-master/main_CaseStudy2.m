%% Drone 班　事例研究用共通プログラム
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
fExp = 0; % 1: experiment   0: numerical simulation
fMotive = 1; % 1: active
fOffline = 0; % 1: active : offline verification with saved data
fDebug = 0; % 1: active : for debug function
ts=0; % 初期値
if fExp
    dt = 0.025; % sampling time
    te=1000;
else
    dt = 0.1; % sampling time
    te=10;
end
sampling = dt;
%% set connector (global instance)
if fExp
        %rigid_ids = [1,2];
        %motive = Connector_Natnet('ClientIP', '192.168.1.9', 'rigid_list', rigid_ids); % Motive
        %[COMs,rigid_ids,motive] = build_MASystem_with_motive('192.168.1.6')
        %% set connector (global instance)
        rigid_ids = [1];
        motive = Connector_Natnet('ClientIP', '192.168.1.9'); % Motive 7 : hara
        COMs = "COM21";
        %[COMs,rigid_ids,motive,initial_state_yaw_angles] = build_MASystem_with_motive('192.168.1.6'); % set ClientIP
        N = length(COMs);
        motive.getData([], []);
    else
        rigid_ids = 1:N;
        motive = Connector_Natnet_sim(N, dt, 0);              % 3rd arg is a flag for noise (1 : active )
        %motive = Connector_Natnet_sim(2*N,dt,0); % for suspended load
    end
%% set initial state
disp("Initialize state");
param = struct('sensor',struct,'estimator',struct,'reference',struct);
if fExp
  initial_state(N) = struct;
  if exist('motive', 'var') == 1; motive.getData([], []); end

  for i = 1:N
    % for exp with motive : initial_stateize by motive info
    if exist('motive', 'var') == 1
      sstate = motive.result.rigid(rigid_ids(i));
      initial_state(i).p = sstate.p;
      initial_state(i).q = sstate.q;
      initial_state(i).v = [0; 0; 0];
      initial_state(i).w = [0; 0; 0];
    else % とりあえず用
      arranged_pos = arranged_position([0, 0], N, 1, 0);
      initial_state(i).p = arranged_pos(:, i);
      initial_state(i).q = [1; 0; 0; 0];
      initial_state(i).v = [0; 0; 0];
      initial_state(i).w = [0; 0; 0];
    end

  end

else

  %% for sim
  for i = 1:N

    if (fOffline)
      clear initial_state
      initial_state(i) = state_copy(logger.Data.agent(i).plant.result{1}.state);
    else
      arranged_pos = arranged_position([0, 0], N, 1, 0);
      initial_state(i).p = arranged_pos(:, i);
      initial_state(i).q = [1; 0; 0; 0];
      initial_state(i).v = [0; 0; 0];
      initial_state(i).w = [0; 0; 0];
    end

  end

end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
if fExp
    agent(i) = DRONE(Model_Drone_Exp(dt, initial_state(i), "udp", [50, 132]), DRONE_PARAM("DIATONE"));                                          % for exp % 機体番号（ESPrのIP）
    %agent(i) = DRONE(Model_Drone_Exp(dt,initial_state(i), "serial", COMs(i)),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
    %agent(i) = DRONE(Model_Drone_Exp(dt,initial_state(i), "serial", "COM31"),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
    %agent(i) = WHILL(Model_Whill_Exp(dt,initial_state(i),"ros",[21]),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ESPrのIP）
    agent(i).input = [0; 0; 0; 0];
  else
    agent(i) = DRONE(Model_Quat13(dt, initial_state(i), i), DRONE_PARAM("DIATONE")); % unit quaternionのプラントモデル : for sim
    %agent(i) = DRONE(Model_EulerAngle(dt, initial_state(i), i), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % euler angleのプラントモデル : for sim
    %agent(i) = DRONE(Model_Suspended_Load(dt,'plant',initial_state(i),i)); % 牽引物込みのプラントモデル : for sim
    %agent(i) = DRONE(Model_Discrete0(dt,initial_state(i),i),DRONE_PARAM("DIATONE")); % 離散時間質点モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定
    %[M,P]=Model_Discrete(dt,initial_state(i),i);
    %agent(i) = DRONE(M,P); % 離散時間質点モデル : PD controller などを想定
    %agent(i) = WHILL(Model_Three_Vehicle(dt,initial_state(i),i),NULL_PARAM()); % for exp % 機体番号（ESPrのIP）
    %          initial_state(i).p = [1;-1];%[92;1];%
    %          initial_state(i).q = 0;%pi/2-0.05;
    %          initial_state(i).v = 0;
    % agent(i) = WHILL(Model_Vehicle45(dt,initial_state(i),i),VEHICLE_PARAM("VEHICLE4","struct","additional",struct("K",diag([0.9,1]),"D",0.1)));                % euler angleのプラントモデル : for sim
  end
%% model
% set control model
agent(i).set_model(Model_EulerAngle(dt, initial_state(i), i), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % オイラー角モデル
%     agent.set_model(Model_Quat13(1,dt,'model',initial)); % オイラーパラメータ（unit quaternion）モデル
%% set input_transform property
if fExp
    agent.input_transform=[];
    agent.set_property("input_transform",InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
end
%% set sensors property
agent(i).sensor = [];
  %agent(i).set_property("sensor",Sensor_LSM9DS1()); % IMU sensor
  if fMotive

    if ~exist('initial_yaw_angles')
      initial_yaw_angles = zeros(1, N);
    end

    agent(i).set_property("sensor", Sensor_Motive(rigid_ids(i), initial_yaw_angles(i), motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
  end
%% set estimator property
 agent(i).set_property("estimator", Estimator_EKF(agent(i), ["p", "q"]));  % （剛体ベース）EKF
%% set reference property
rflag = 1;
ReferencePoints = [0,-1,1;2,1,1;1,2,1;0,1,1;-1,2,1;-2,1,1;0,-1,1]'; % PtoP制御
if fExp == 1
    agent.set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0;0;1]));
else
    agent.set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0;0;1]));
end

% 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
agent.set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
agent.set_property("controller",Controller_HL(dt)); % 階層型線形化
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
logger=Logger(agent,size(ts:dt:te,2),[]);
%% set timer
time =  Time();
time.t = ts;
%% main loop
disp("while ============================")
close all
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');
w = waitforbuttonpress;
try
    while round(time.t,5)<=te
        % sensor
        tic
        motive.getData(agent,[]);
        agent.do_sensor({{motive}});
        
        % estimator, reference generator, controller
        agent.do_estimator(cell(1,10));
        param.reference.timeVarying={time};
        [r,rflag]=Make_reference_points(ReferencePoints,agent,rflag);
        param.reference.point={FH,r,time.t};
        for j = 1:length(agent.reference.name)
            param.reference.list{j}=param.reference.(agent.reference.name(j));
        end
        agent.do_reference(param.reference.list);
        agent.do_controller({time.t,cell(1,9)});
        % update state
        figure(FH)
        drawnow
        model_param.param=agent.model.param;
        model_param.FH = FH;
        agent.do_model(model_param);
        
        model_param.param=agent.plant.param;
        agent.do_plant(model_param);
        
        % logging
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
        else
            time.t = time.t + dt % for sim
        end
    end
catch ME    % for error
    agent.do_plant(struct('FH',FH),"emergency");
    warning('ACSL : Emergency stop! Check the connection.');
%     rethrow(ME);
end
%%
close all
clc
logger.plot({1, "p", "pr"}, {1, "q", "p"}, {1, "v", "p"}, {1, "input", ""},{1,"p1-p2","pr"},{1,"p1-p2-p3","pr"}, "fig_num", 5, "row_col", [2, 3]);
% logger.plot(1,["p1-p2-p3","v","input"],["r","e",""],struct("fig_num",1));
% logger.plot(1,["q1","q2","q3"],["er","er","er"],struct("fig_num",2,"row_col",[3,1]));
% logger.plot(1,["p1-p2"],["r"],struct("fig_num",3));
% logger.plot(1,["p"],["r"],struct("fig_num",4));
%%
if fExp
    save('experiment.mat',"logger");
    logger.save();
    movefile experiment.mat Datafolder;
else
    save('simulation.mat',"logger");
    movefile simulation.mat Datafolder;
end
%%
if fExp
    load('experiment.mat');
%    load('Log(22-Sep-2021_11_57_20).mat');
else
    load('simulation.mat');
end