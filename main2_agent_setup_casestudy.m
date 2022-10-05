for i = 1:N
    %% generate Drone instance
    % DRONE classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
    if fExp
        %agent(i) = DRONE(Model_Drone_Exp(dt,initial(i),"udp",[25]),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ESPrのIP）
        agent(i) = DRONE(Model_Drone_Exp(dt,initial(i), "serial", COMs(i)),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
        %agent(i) = DRONE(Model_Drone_Exp(dt,initial(i), "serial", "COM31"),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
        %agent(i) = Whill(Model_Whill_Exp(dt,initial(i),"ros",[21]),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ESPrのIP）
        agent(i).input = [0; 0; 0; 0];
    else
%         agent(i) = DRONE(Model_Quat13(dt,initial(i),i),DRONE_PARAM("DIATONE")); % unit quaternionのプラントモデル : for sim
        agent(i) = DRONE(Model_EulerAngle(dt,initial(i), i),DRONE_PARAM("DIATONE"));                % euler angleのプラントモデル : for sim
        %agent(i) = DRONE(Model_Suspended_Load(dt,'plant',initial(i),i)); % 牽引物込みのプラントモデル : for sim
        %agent(i) = DRONE(Model_Discrete0(dt,initial(i),i),DRONE_PARAM("DIATONE")); % 離散時間質点モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定
        %agent(i) = DRONE(Model_Discrete(dt,initial(i),i),DRONE_PARAM("DIATONE")); % 離散時間質点モデル : PD controller などを想定
    end

    %% model
    % set control model
    agent(i).set_model(Model_EulerAngle(dt,initial(i), i)); % オイラー角モデル
    %agent(i).set_model(Model_Quat13(dt,initial(i),i)); % オイラーパラメータ（unit quaternion）モデル
    %agent(i).set_model(Model_Suspended_Load(dt,'model',initial(i),i)); %牽引物込みモデル
    %agent(i).set_model(Model_Discrete0(dt,initial(i),i)) % 離散時間モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
    %agent(i).set_model(Model_Discrete(dt,initial(i),i)) % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
    close all
    %% set input_transform property
    if fExp                                                                               % isa(agent(i).plant,"Lizard_exp")
        agent(i).input_transform = [];
        agent(i).set_property("input_transform", InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
    end

    %agent.plant.espr.sendData(Pw(1,1:16));
    % for quat-model plant with discrete control model
    %agent(i).set_property("input_transform",InputTransform_REFtoHL_drone(dt)); % 位置指令から４つの推力に変換 : Direct controller（入力＝目標位置） を想定
    %agent(i).set_property("input_transform",InputTransform_toHL_drone(dt)); % modelを使った１ステップ予測値を目標値として４つの推力に変換
    % １ステップ予測値を目標とするのでゲインをあり得ないほど大きくしないとめちゃめちゃスピードが遅い結果になる．
    %agent(i).set_property("input_transform",struct("type","Thrust2ForceTorque","name","toft","param",1)); % 1: 各モータ推力を[合計推力，トルク入力]へ変換，　2: 1の逆
    %% set sensors property
    agent(i).sensor = [];
    %agent(i).set_property("sensor",Sensor_LSM9DS1()); % IMU sensor
    if fMotive
        if ~exist('initial_yaw_angles')
            initial_yaw_angles = zeros(1, N);
        end
        agent(i).set_property("sensor", Sensor_Motive(rigid_ids(i), initial_yaw_angles(i), motive)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
    end

    %agent(i).set_property("sensor", Sensor_ROS(struct('ROSHostIP', '192.168.50.21')));
    %agent(i).set_property("sensor",Sensor_Direct()); % 状態真値(plant.state)　：simのみ
    %agent(i).set_property("sensor",Sensor_RangePos(i,'r',3)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
    %agent(i).set_property("sensor",Sensor_RangeD('r',3)); %  半径r (第二引数) 内の重要度を計測 : sim のみ
    %agent(i).set_property("sensor",struct("type","LiDAR_sim","name","lrf","param",[]));
    %% set estimator property
    agent(i).estimator = [];
    %agent(i).set_property("estimator",Estimator_LPF(agent(i))); % lowpass filter
    %agent(i).set_property("estimator",Estimator_AD()); % 後退差分近似で速度，角速度を推定　シミュレーションこっち
    %agent(i).set_property("estimator",Estimator_feature_based_EKF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースEKF
    %agent(i).set_property("estimator",Estimator_PDAF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースPDAF
    agent(i).set_estimator("estimator", Estimator_EKF(agent(i), ["p", "q"], [1e-5, 1e-8])); % （剛体ベース）EKF
    %agent(i).set_property("estimator",Estimator_Direct()); % Directセンサーと組み合わせて真値を利用する　：sim のみ
    %agent(i).set_property("estimator",Estimator_Suspended_Load([i,i+N])); %
    %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q","pL","pT"],[1e-5,1e-5,1e-5,1e-7])); % （剛体ベース）EKF
    %agent(i).set_property("estimator",struct('type',"MAP_UPDATE",'name','map','param',Env)); % map 更新用 重要度などのmapを時間更新する
    %% set reference property
    agent(i).reference = [];
    %agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env,'void',0.1)); % Voronoi重心
    %agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{5,[0;0;1.5],[2,2,1]})); % 時変な目標状態
%     agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
%     agent(i).set_property("reference",Reference_Time_Varying("Komatsu_study_trajectory",[1;0;1;10])); % 円旋回 離陸 コマツ
    %agent(i).set_property("reference",Reference_Time_Varying_Suspended_Load("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
    %agent(i).set_property("reference",Reference_Wall_observation()); %
    %agent(i).set_property("reference",Reference_Agreement(N)); % Voronoi重心
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference", Reference_Point_FH());                              % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller = [];
    %agent(i).set_property("controller",Controller_FT(dt)); % 有限時間整定制御
%     agent(i).set_property("controller", Controller_HL(1));                                % 階層型線形化
%     HLControlSetting = Controller_HL(1);
%     HLParam = HLControlSetting.param;

    %agent(i).set_property("controller",Controller_HL_Suspended_Load(dt)); % 階層型線形化
    %agent(i).set_property("controller",Controller_MEC()); % 実入力へのモデル誤差補償器
    % agent(i).set_property("controller",Controller_HL_MEC(dt);% 階層型線形化＋MEC
    %agent(i).set_property("controller",Controller_HL_ATMEC(dt));%階層型線形化+AT-MEC
    %agent(i).set_property("controller",struct("type","MPC_controller","name","mpc","param",{agent(i
    %-- sample 通さずに実行
%     agent(i).set_property("controller",struct("type","MCMPC_controller","name","mcmpc","param",{agent(i)}));
%     agent(i).set_property("controller",Controller_MCMPC(dt)); % sampleを通す方
    %agent(i).set_property("controller",struct("type","DirectController","name","direct","param",[]));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %agent(i).set_property("controller",struct("type","PDController","name","pd","param",struct("P",-1*diag([1,1,3]),"D",-1*diag([1,1,3]))));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %% 必要か？実験で確認 : TODO
    param(i).sensor.list = cell(1, length(agent(i).sensor.name));
    param(i).reference.list = cell(1, length(agent(i).reference.name));
end
