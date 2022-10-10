%% Drone 班用共通プログラム : Motiveを使った複数機体実験用
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%% general setting
%N = 1; % number of agents
dt = 0.025; % sampling time
ts = 0;
te = 1000;

%% set connector (global instance)
rigid_ids = [1];
motive = Connector_Natnet('ClientIP', '192.168.1.9'); % Motive
COMs = "COM21";
%[COMs,rigid_ids,motive,initial_yaw_angles] = build_MASystem_with_motive('192.168.1.9'); % set ClientIP
N = length(COMs);
initial_yaw_angles = [0];
motive.getData([],[]);

%% initialize
disp("Initialize state");
initial(N) = struct;
param = struct('sensor', struct, 'estimator', struct, 'reference', struct);

motive.getData([], []);

for i = 1:N
    sstate = motive.result.rigid(rigid_ids(i));
    initial(i).p = sstate.p;
    initial(i).q = sstate.q;
    initial(i).v = [0; 0; 0];
    initial(i).w = [0; 0; 0];
end
%COMs = [25,3];%25,3
if length(COMs)~=N
    error("ACSL : All drones should assigned COM port.");
end
for i = 1:N
    %% generate Drone instance
    % Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
    agent(i) = Drone(Model_Drone_Exp(dt, 'plant', initial(i), "serial", COMs(i))); % for exp % 機体番号（ArduinoのCOM番号）
    agent(i).input = [0; 0; 0; 0];

    %% model
    % set control model
    agent(i).set_model(Model_EulerAngle(dt, 'model', initial(i),i)); % オイラー角モデル
    %    agent(i).set_model(Model_Suspended_Load_Euler(i,dt,'model',initial(i))); % unit quaternionのプラントモデル : for sim

    %% set input_transform property
    agent(i).input_transform = [];
    agent(i).set_property("input_transform", InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換

    %% set sensors property
    agent(i).sensor = [];
    agent(i).set_property("sensor", Sensor_Motive(rigid_ids(i),initial_yaw_angles(i),motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
    %% set estimator property
    agent(i).estimator = [];
    agent(i).set_property("estimator", Estimator_EKF(agent(i), ["p", "q"], [1e-3, 1e-5])); % （剛体ベース）EKF
    %agent(i).set_property("estimator",Estimator_Suspended_Load([i,i+N])); %
    %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q","pL","pT"],[1e-5,1e-5,1e-5,1e-7])); % （剛体ベース）EKF

    %% set reference property
    agent(i).reference = [];
    %agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env)); % Voronoi重心
    %agent(i).set_property("reference",Reference_TIME_Varying("gen_ref_saddle",{5,[0;0;1.5],[2,2,1]})); % 時変な目標状態
    %agent(i).set_property("reference",Reference_TIME_Varying("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    %    agent(i).set_property("reference",Reference_agreement(N)); % Voronoi重心

    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    %agent(i).set_property("reference",Reference_TIME_Varying_Suspended_Load("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    agent(i).set_property("reference", Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller = [];
    agent(i).set_property("controller", Controller_HL(dt)); % 階層型線形化
    HLControlSetting=Controller_HL(dt);
    HLParam = HLControlSetting.param;
    %agent(i).set_property("controller",Controller_HL_Suspended_Load(dt)); % 階層型線形化

end
param.sensor.list = cell(1, length(agent(1).sensor.name));
%param.reference.list = cell(1, length(agent(i).reference.name));

%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [% agentのメンバー関係以外のデータ
    ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
    %"model.state.p"
    "controller.result"
    "inner_input"
    "input_transform"
    ];

if isfield(agent(1).reference, 'covering')
    LogAgentData = [LogAgentData; 'reference.result.region'; "env.density.param.grid_density"]; % for coverage
end

logger = LOGGER(1:N, size(ts:dt:te, 2), 1, LogData, LogAgentData);
%%
time = TIME();
time.t = ts;
%%
% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．
mparam = []; % without occulusion
model_param.param = agent(1).model.param;% TODO : 機体ごとにパラメータが違うとき注意

%% main loop
%profile on
disp("while ============================")
close all;

pause(1);
disp('Press Enter key to start.');
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
w = waitforbuttonpress;
disp("Start");
try
    while round(time.t, 5) <= te
        %while 1 % for exp
        %% sensor
        tStart = tic;
        motive.getData(agent, mparam);
        param.sensor.list{1} = {motive};

        for i = 1:N
            agent(i).do_sensor(param.sensor.list);
        end

        %% estimator, reference generator, controller
        if exist("tEstimator","var")
            dte = toc(tEstimator);
            model_param.dt = dte;
            for i = 1:N
                agent(i).do_model(model_param);% EKF のために更新することが必要
            end            % agent(i).model.dt が変化していくことを確認する。
        else
            dte = 0;
        end
        tEstimator = tic;
        for i = 1:N
            agent(i).do_estimator({dte,dte});
        end

        %  Point referenceに対応したparameterはcell配列の最後に配置する。
        %param.reference.list{1} = {logger,N,time.t};
        %param.reference.list{1} = {time};
        param.reference.list{1} = {FH, [1; -1; 1], time.t};
        for i = 1:N
            agent(i).do_reference(param.reference.list);
        end
        HLParam.dt = dte;% あくまで推定結果を元に入力を算出するため
        for i = 1:N
            agent(i).do_controller({HLParam,[]});
        end
        if norm(agent(i).input) > 10
            error("ACSL : too large input! Check the algorithm")
        end
 
        %% update state
        % with FH
        figure(FH)
        drawnow

        model_param.FH = FH;
        for i = 1:N % 状態更新
            agent(i).do_plant(model_param);
        end

        %% logging
        calculation1 = toc(tStart);
        time.t = time.t + calculation1;

        logger.logging(time.t, FH,agent,[]);
        calculation2 = toc(tStart);
        time.t = time.t + calculation2 - calculation1;
    end
catch ME % for error
    % with FH

    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end

    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%%
%profile viewer
%%
close all
logger.plot({1,"p","ser"},{1,"q","e"},{1,'v','e'},{1,'w','e'}, ...
    {1,"input",""},{1,"inner_input",""});

%%
%logger.save();
