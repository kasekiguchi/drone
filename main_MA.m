%% Drone 班用共通プログラム : 害鳥追跡シミュレーション
%% Initialize settings
% set path
activefile = matlab.desktop.editor.getActive;
cd(fileparts(activefile.Filename));
[~, activefile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activefile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%% general setting
N = 4; % number of total units
Nb = 1; % number of birds
fExp = 0 % 実機フラグ
fMotive = 1 % Motiveを使うかどうか
dt = 0.025; % sampling time

sampling = dt;
ts = 0;

te = 15;
%% set connector (global instance)
if fMotive
    rigid_ids = 1:N;
    motive = Connector_Natnet_sim(N, dt, 0);
end

%% set initial state
disp("Inisialize state");
initial_state(N) = struct;
param(N) = struct('sensor', struct, 'estimator', struct, 'reference',struct);

for i = 1:N
    arranged_pos = arranged_position([1, 0], N, 1, 0);
    initial_state(i).p = arranged_pos(:, i);
    initial_state(i).q = [1; 0; 0; 0];
    initial_state(i).v = [0; 0; 0];
    initial_state(i).w = [0; 0; 0];
end

for i = 1:Nb
    arranged_pos = arranged_position([1, 1], N+Nb, 1, 0);
    initial_state(i).p = arranged_pos(:, i);
    initial_state(i).q = [1; 0; 0; 0];
    initial_state(i).v = [0; 0; 0];
    initial_state(i).w = [0; 0; 0];
end
%% generate environment
Env = Map3D_sim(Env_3DCoverage()); % 3次元重要度マップ設定

for i = 1:N
    %% generate Drone instance
    % DRONE classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
    %agent(i) = DRONE(Model_Quat13(dt,initial_state(i),i),DRONE_PARAM("DIATONE")); % unit quaternionのプラントモデル : for sim
    agent(i) = DRONE(Model_EulerAngle(dt,initial_state(i), i),DRONE_PARAM("DIATONE"));                % euler angleのプラントモデル : for sim
    %agent(i) = DRONE(Model_Suspended_Load(dt,'plant',initial_state(i),i)); % 牽引物込みのプラントモデル : for sim
    %agent(i) = DRONE(Model_Discrete0(dt,initial_state(i),i),DRONE_PARAM("DIATONE")); % 離散時間質点モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定
    %[M,P]=Model_Discrete(dt,initial_state(i),i);
    %agent(i) = DRONE(M,P); % 離散時間質点モデル : PD controller などを想定
    %agent(i) = WHILL(Model_Three_Vehicle(dt,initial_state(i),i),NULL_PARAM()); % for exp % 機体番号（ESPrのIP）

    %% model
    % set control model
    if i <= N-Nb
    agent(i).set_model(Model_EulerAngle(dt,initial_state(i), i)); % オイラー角モデル
    %agent(i).set_model(Model_Quat13(dt,initial_state(i),i)); % オイラーパラメータ（unit quaternion）モデル
    %agent(i).set_model(Model_Suspended_Load(dt,'model',initial_state(i),i)); %牽引物込みモデル
    %agent(i).set_model(Model_Discrete0(dt,initial_state(i),i)) % 離散時間モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
    %agent(i).set_model(Model_Discrete(dt,initial_state(i),i)) % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
    %agent(i).set_model(Model_Three_Vehicle(dt,initial_state(i),i)); % for exp % 機体番号（ESPrのIP）
    else
    agent(i).set_model(Model_Bird(dt,initial_state(i),i)) % 鳥のモデル（離散時間モデル）
    end
    close all
    %% set sensors property
    agent(i).sensor = [];
    if fMotive
        if ~exist('initial_yaw_angles')
            initial_yaw_angles = zeros(1, N);
        end
        agent(i).set_property("sensor", Sensor_Motive(rigid_ids(i), initial_yaw_angles(i), motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
    end

    %agent(i).set_property("sensor", Sensor_ROS(struct('ROSHostIP', '192.168.50.21')));
%     agent(i).set_property("sensor",Sensor_Direct(0.0)); % 状態真値(plant.state)　：simのみ % 入力はノイズの大きさ
    agent(i).set_property("sensor",Sensor_RangePos(i,'r',20)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
%     agent(i).set_property("sensor",Sensor_RangeD('r',3)); %  半径r (第二引数) 内の重要度を計測 : sim のみ
    agent(i).set_property("sensor",Sensor_Map_3D('d',10)); % 測定距離d（第二引数宇）内の重要度を計測 : sim のみ 
%     agent(i).set_property("sensor",Sensor_Bounding('d',2)); % boxの大きさ指定（d : 一辺の半分の長さ）
    %agent(i).set_property("sensor",Sensor_LiDAR(i));
    %% set estimator property
    agent(i).estimator = [];
    %agent(i).set_property("estimator",Estimator_LPF(agent(i))); % lowpass filter
    %agent(i).set_property("estimator",Estimator_AD()); % 後退差分近似で速度，角速度を推定　シミュレーションこっち
    %agent(i).set_property("estimator",Estimator_feature_based_EKF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースEKF
    %agent(i).set_property("estimator",Estimator_PDAF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースPDAF
    agent(i).set_property("estimator",Estimator_EKF(agent(i), ["p", "q"])); % （剛体ベース）EKF
%     agent(i).set_property("estimator",Estimator_EKF(agent(i), ["p", "q"],"B",diag([dt^2,dt^2,0,0,0,dt]))); %
    %agent(i).set_property("estimator",Estimator_KF(agent(i), ["p","v","q"], "Q",1e-5,"R",1e-3)); % （質点）EKF
    %agent(i).set_property("estimator",Estimator_PF(agent(i), ["p", "q"])); % （剛体ベース）EKF
%     agent(i).set_property("estimator",Estimator_Direct()); % Directセンサーと組み合わせて真値を利用する　：sim のみ
    %agent(i).set_property("estimator",Estimator_Suspended_Load([i,i+N])); %
    %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q","pL","pT"],[1e-5,1e-5,1e-5,1e-7])); % （剛体ベース）EKF
    %agent(i).set_property("estimator",struct('type',"MAP_UPDATE",'name','map','param',Env)); % map 更新用 重要度などのmapを時間更新する
    %% set reference property
    agent(i).reference = [];
    if i <= N-Nb
    %agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env,'void',0.1)); % Voronoi重心
    agent(i).set_property("reference",Reference_3DCoverage(agent(i),Env)); % Voronoi重心(3D)
    %agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{5,[0;0;1],[2,2,0.5]})); % 時変な目標状態
    %agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{5,[0;0;0],[2,2,0]})); % 時変な目標状態
    %agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    %agent(i).set_property("reference",Reference_Time_Varying_Suspended_Load("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    %agent(i).set_property("reference",Reference_Wall_observation()); %
    %agent(i).set_property("reference",Reference_Agreement(N)); % Voronoi重心
    %agent(i).set_property("reference",struct("type","TWOD_TANBUG","name","tbug","param",[])); % ハート形[x;y;z]永久
    else
    agent(i).set_property("reference",Reference_Bird()); % Voronoi重心
    end
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference", Reference_Point_FH());                              % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller = [];
    %agent(i).set_property("controller",Controller_FT(dt)); % 有限時間整定制御
    agent(i).set_property("controller", Controller_HL(dt));                                % 階層型線形化
    %agent(i).set_property("controller", Controller_FHL(dt));                                % 階層型線形化
    %agent(i).set_property("controller", Controller_FHL_Servo(dt));                                % 階層型線形化

    %agent(i).set_property("controller",Controller_HL_Suspended_Load(dt)); % 階層型線形化
    %agent(i).set_property("controller",Controller_MEC()); % 実入力へのモデル誤差補償器
    %agent(i).set_property("controller",Controller_HL_MEC(dt);% 階層型線形化＋MEC
    %agent(i).set_property("controller",Controller_HL_ATMEC(dt));%階層型線形化+AT-MEC
    %agent(i).set_property("controller", struct("type","TSCF_VEHICLE","name","tscf","param",struct("F1",0.3,"F2",0.2)));
    %agent(i).set_property("controller",struct("type","MPC_controller","name","mpc","param",{agent(i)}));
    %agent(i).set_property("controller",struct("type","DirectController","name","direct","param",[]));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %agent(i).set_property("controller",struct("type","PDController","name","pd","param",struct("P",-0.9178*diag([1,1,3]),"D",-1.6364*diag([1,1,3]),"Q",-1)));
    %% 必要か？実験で確認 : TODO
    param(i).sensor.list = cell(1, length(agent(i).sensor.name));
    param(i).reference.list = cell(1, length(agent(i).reference.name));
end
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
    ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
    ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop
%% set timer
time = TIME();
time.t = ts;

% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

% % for simulation
% mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
% mparam.occlusion.target={[1],[1]};
% mparam.marker_num = 20;
mparam = [];    % without occulusion

%profile on
disp("while ============================")
close all;

if fExp && ~fMotive
    fprintf(2, "Warning : input will send to drone\n");
end

disp('Press Enter key to start.');
FH = figure('position', [0 0 eps eps], 'menubar', 'none');

w = waitforbuttonpress;

% try
    while round(time.t, 5) <= te
        %% sensor
        %    tic
        tStart = tic;
        if time.t == 9
            time.t;
        end

        if fMotive
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent, mparam);
        end

        for i = 1:N
            % sensor
            if fMotive; param(i).sensor.motive = {}; end
            param(i).sensor.rpos = {agent};
            param(i).sensor.imu = {[]};
            param(i).sensor.direct = {};
            param(i).sensor.bounding = {time};
            param(i).sensor.rcoverage_3D = {};
            param(i).sensor.rdensity = {Env};
            param(i).sensor.lrf = Env;
            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j} = param(i).sensor.(agent(i).sensor.name(j));
            end
            agent(i).do_sensor(param(i).sensor.list);
%             agent(i).sensor.bounding.show(agent(1))
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            % reference
            param(i).reference.covering = [];
            param(i).reference.covering_3D = [time];
            param(i).reference.birdmove = [time];
            param(i).reference.point = {FH, [2; 1; 1], time.t,dt};
            param(i).reference.timeVarying = {time,FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.tbug = {};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param(i).controller.hlc = {time.t};
            param(i).controller.pd = {};
            param(i).controller.tscf = {time.t};
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end

        %% update state
        figure(FH)
        drawnow

        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

                      agent(i).input = agent(i).input - [0.1;0.01;0;0]; % 定常外乱
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end

        % for exp
        if fExp
            %% logging
            logger.logging(time.t, FH, agent, []);
            calculation1 = toc(tStart);
            time.t = time.t + calculation1;

            %% logging
            %             calculation = toc;
            %             wait_time = 0.9999 * (sampling - calculation);
            %
            %             if wait_time < 0
            %                 wait_time
            %                 warning("ACSL : sampling time is too short.");
            %             end
            %            time.t = time.t + calculation;

            %            else
            %                pause(wait_time);  %　センサー情報取得から制御入力印加までを早く保ちつつ，周期をできるだけ一定に保つため
            % これをやるとpause中が不安定になる．どうしても一定時間にしたいならwhile でsamplingを越えるのを待つなどすればよいかも．
            % それよりは推定などで，calculationを意識した更新をしてあげた方がよい？
            %                time.t = time.t + sampling;
            %            end
        else
            logger.logging(time.t, FH, agent);
            time.t = time.t + dt
        end

    end

% catch ME % for error
%     % with FH
%     for i = 1:N
%         agent(i).do_plant(struct('FH', FH), "emergency");
%     end
% 
%     warning('ACSL : Emergency stop! Check the connection.');
%     rethrow(ME);
% end

%profile viewer
%%
close all
clc
% plot
%logger.plot({1,"p","per"},{1,"controller.result.z",""},{1,"input",""});
% logger.plot({1,"p","er"},{1,"q","e"},{1,"input",""},{2,"p","er"},{2,"q","e"},{2,"input",""},{3,"p","er"},{3,"q","e"},{3,"input",""},"row_col",[3 3]);
% agent(1).reference.timeVarying.show(logger)


%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
%agent(1).estimator.pf.animation(logger,"target",1,"FH",figure(),"state_char","p");
agent(1).animation(logger,"target",1:N,"Motive_ref",1,"gif",1);
% agent(1).sensor.bounding.movie(logger);
