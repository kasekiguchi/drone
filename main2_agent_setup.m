%% set initial state
disp("Initialize state");
param(N) = struct('sensor', struct, 'estimator', struct, 'reference', struct);

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

%% generate environment
Env = DensityMap_sim(Env_2DCoverage); % Weighted 2D map : 重要度マップ設定
%Env = [];
%Env = FLOOR_MAP([], Env_FloorMapSquare); % 四角経路

for i = 1:N
  %% generate Drone instance
  % DRONE classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
  if fExp
    agent(i) = DRONE(Model_Drone_Exp(dt, initial_state(i), "udp", [50, 132]), DRONE_PARAM("DIATONE"));                                          % for exp % 機体番号（ESPrのIP）
    %agent(i) = DRONE(Model_Drone_Exp(dt,initial_state(i), "serial", COMs(i)),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
    %agent(i) = DRONE(Model_Drone_Exp(dt,initial_state(i), "serial", "COM31"),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ArduinoのCOM番号）
    %agent(i) = WHILL(Model_Whill_Exp(dt,initial_state(i),"ros",[21]),DRONE_PARAM("DIATONE")); % for exp % 機体番号（ESPrのIP）
    agent(i).input = [0; 0; 0; 0];
  else
    %agent(i) = DRONE(Model_Quat13(dt, initial_state(i), i), DRONE_PARAM("DIATONE")); % unit quaternionのプラントモデル : for sim
    %agent(i) = DRONE(Model_EulerAngle(dt, initial_state(i), i), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % euler angleのプラントモデル : for sim
    %agent(i) = DRONE(Model_Suspended_Load(dt,'plant',initial_state(i),i)); % 牽引物込みのプラントモデル : for sim
    
    %agent(i) = DRONE(Model_Discrete0(dt,initial_state(i),i),POINT_MASS_PARAM("point","A",dsys.A,"B",dsys.B,"C",dsys.C)); % Discrete-time point-mass model 離散時間質点モデル（次時刻位置＝入力）  Requirement : Direct controller（入力＝目標位置） 
    [M,P]=Model_Discrete(dt,initial_state(i),i,"PV");
    agent(i) = DRONE(M,P); % 離散時間質点モデル : PD controller などを想定
    %agent(i) = WHILL(Model_Three_Vehicle(dt,initial_state(i),i),NULL_PARAM()); % for exp % 機体番号（ESPrのIP）
    %          initial_state(i).p = [1;-1];%[92;1];%
    %          initial_state(i).q = 0;%pi/2-0.05;
    %          initial_state(i).v = 0;
    % agent(i) = WHILL(Model_Vehicle45(dt,initial_state(i),i),VEHICLE_PARAM("VEHICLE4","struct","additional",struct("K",diag([0.9,1]),"D",0.1)));                % euler angleのプラントモデル : for sim
  end

  %% model
  % set control model
  %agent(i).set_model(Model_EulerAngle(dt, initial_state(i), i), DRONE_PARAM("DIATONE", "additional", struct("B", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))); % オイラー角モデル
  %agent(i).set_model(Model_Quat13(dt,initial_state(i),i),DRONE_PARAM("DIATONE")); % オイラーパラメータ（unit quaternion）モデル
  %agent(i).set_model(Model_Suspended_Load(dt,'model',initial_state(i),i)); %牽引物込みモデル
  %agent(i).set_model(Model_Discrete0(dt,initial_state(i),i),POINT_MASS_PARAM("point","A",dsys.A,"B",dsys.B,"C",dsys.C)) % 離散時間モデル（次時刻位置＝入力） : Direct controller（入力＝目標位置） を想定 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
  %agent(i).set_model(Model_Discrete(dt,initial_state(i),i),POINT_MASS_PARAM("point","A",dsys.A,"B",dsys.B,"C",dsys.C)) % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
  agent(i).set_model(M,P) % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
  %agent(i).set_model(Model_Three_Vehicle(dt,initial_state(i),i)); % for exp % 機体番号（ESPrのIP）
  %agent(i).set_model(Model_Vehicle45(dt,initial_state(i),i),VEHICLE_PARAM("VEHICLE4","struct","additional",struct("K",diag([1,1]),"D",0.1)));
  close all
  %% set input_transform property
  if fExp                                                                             % isa(agent(i).plant,"Lizard_exp")
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
  agent(i).set_property("sensor",Sensor_Direct(0.0)); % 状態真値(plant.state)　：simのみ % 入力はノイズの大きさ
  agent(i).set_property("sensor",Sensor_RangePos(i,'r',2)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
  agent(i).set_property("sensor",Sensor_RangeD('r',1)); %  半径r (第二引数) 内の重要度を計測 : sim のみ
  %agent(i).set_property("sensor",Sensor_LiDAR(i));
  %agent(i).set_property("sensor",Sensor_LiDAR(i,'noise',1.0E-2 ,'seed',3));
  % env = stlread('3F.stl');
  % a = 1;
  % b = 2;
  % c = 3;
  % Points = [4 0 0]+[-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c]; 
  % Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  % env = triangulation(Tri,Points);
  %agent(i).set_property("sensor", Sensor_LigDAR3D(i, 'env', env, 'theta_range', pi / 2 + (-pi / 12:0.034:pi / 12), 'phi_range', -pi:0.007:pi, 'noise', 3.0E-2, 'seed', 3)); % VLP-16
  %agent(i).set_property("sensor", Sensor_LiDAR3D(i, 'env', env, 'theta_range', pi / 2, 'phi_range', -pi:0.1:pi, 'noise', 3.0E-2, 'seed', 3)); % 2D lidar
  %agent(i).set_property("sensor", Sensor_LiDAR3D(i, 'env', env, 'theta_range', pi / 2, 'phi_range', 0, 'noise', 0.0E-2, 'seed', 3)); % 2D lidar
  %agent(i).set_property("sensor", Sensor_LiDAR3D(i, 'env', env, 'theta_range', pi / 2 + (-15*pi/360:0.05:15*pi/360), 'phi_range', -15*pi/360:0.05:15*pi/360, 'noise', 3.0E-2, 'seed', 3)); % Teraranger 64px
  %% set estimator property
  agent(i).estimator = [];
  %agent(i).set_property("estimator",Estimator_LPF(agent(i))); % lowpass filter
  %agent(i).set_property("estimator",Estimator_AD()); % 後退差分近似で速度，角速度を推定　シミュレーションこっち
  %agent(i).set_property("estimator",Estimator_feature_based_EKF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースEKF
  %agent(i).set_property("estimator",Estimator_PDAF(agent(i),["p","q"],[1e-5,1e-8])); % 特徴点ベースPDAF
  %agent(i).set_property("estimator", Estimator_EKF(agent(i), ["p", "q"]));                                                                    % （剛体ベース）EKF
  %agent(i).set_property("estimator", Estimator_EKF(agent(i), ["p", "q"], "B", diag([dt^2, dt^2, 0, 0, 0, dt]))); % for vehicle model
  %agent(i).set_property("estimator",Estimator_KF(agent(i), ["p","v","q"], "Q",1e-5,"R",1e-3)); % （質点）EKF
  %agent(i).set_property("estimator",Estimator_PF(agent(i), ["p", "q"])); % （剛体ベース）EKF
  agent(i).set_property("estimator",Estimator_Direct()); % Directセンサーと組み合わせて真値を利用する　：sim のみ
  %agent(i).set_property("estimator",Estimator_Suspended_Load([i,i+N])); %
  %agent(i).set_property("estimator",Estimator_EKF(agent(i),["p","q","pL","pT"],[1e-5,1e-5,1e-5,1e-7])); % （剛体ベース）EKF
  %agent(i).set_property("estimator",struct('type',"MAP_UPDATE",'name','map','param',Env)); % map 更新用 重要度などのmapを時間更新する
  %agent(i).set_property("estimator",Estimator_UKF2DSLAM_Vehicle(agent(i)));%加速度次元入力モデルのukfslam車両も全方向も可
  %% set reference property
  agent(i).reference = [];
  agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env,'void',0)); % Voronoi重心
  %agent(i).set_property("reference",Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]})); % 時変な目標状態
  %agent(i).set_property("reference", Reference_Time_Varying("gen_ref_saddle", {"freq", 20, "orig", [0; 10; 0], "size", [10, 10, 0], "phase", -pi / 2})); % 時変な目標状態
  %agent(i).set_property("reference",Reference_Time_Varying("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
  %agent(i).set_property("reference",Reference_Time_Varying_Suspended_Load("Case_study_trajectory",[1;0;1])); % ハート形[x;y;z]永久
  %agent(i).set_property("reference",Reference_Wall_observation()); %
  %agent(i).set_property("reference",Reference_Agreement(N)); % Voronoi重心
  %agent(i).set_property("reference",struct("type","TWOD_TANBUG","name","tbug","param",[])); % ハート形[x;y;z]永久
  %agent(i).set_property("reference",Reference_PathCenter(agent(i),agent.sensor.lrf.radius));
  % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
  agent(i).set_property("reference", Reference_Point_FH());                                                                                   % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
  %% set controller property
  agent(i).controller = [];

  %     fzapr = 1;%z方向に適用するか:1 else:~1
  %     fzsingle = 1;%tanhが一つか:1 tanh2:~1
  %     fxyapr = 1;%%%xy近似するか:1 else:~1
  %     fxysingle = 1;%%% tanh1:1 or tanh2 :~1
  %     alp = 0.9;%alphaの値 0.8だとゲインの位置の重みを大きくすると発散
  %     erz=[0 1];%近似する範囲z
  %     erxy=[0 1];%近似する範囲xy
  %     agent(i).set_property("controller",Controller_FT(dt,fzapr,fzsingle,fxyapr,fxysingle,alp,erz,erxy));

  %agent(i).set_property("controller",Controller_FT(dt)); % 有限時間整定制御
  %agent(i).set_property("controller", Controller_HL(dt));                                                                                     % 階層型線形化
  %agent(i).set_property("controller", Controller_FHL(dt));                                % 階層型線形化
  %agent(i).set_property("controller", Controller_FHL_Servo(dt));                                % 階層型線形化

  %agent(i).set_property("controller",Controller_HL_Suspended_Load(dt)); % 階層型線形化
  %agent(i).set_property("controller",Controller_MEC()); % 実入力へのモデル誤差補償器
  %agent(i).set_property("controller",Controller_HL_MEC(dt);% 階層型線形化＋MEC
  %agent(i).set_property("controller",Controller_HL_ATMEC(dt));%階層型線形化+AT-MEC
  %agent(i).set_property("controller", struct("type", "TSCF_VEHICLE", "name", "tscf", "param", struct("F1", [1.0000 1.7321] * 3/4, "F2", [0.1000 0.4583]))); %)));
  %agent(i).set_property("controller",struct("type","MPC_controller","name","mpc","param",{agent(i)}));
  %agent(i).set_property("controller",Controller_TrackingMPC(dt));%MPCコントローラ
  %agent(i).set_property("controller",struct("type","DirectController","name","direct","param",[]));% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
  %agent(i).set_property("controller",struct("type","PDController","name","pd","param",struct("P",-0.9178*diag([1,1,3]),"D",-1.6364*diag([1,1,3]),"Q",-1)));
  agent(i).set_property("controller", Controller_PID(dt)); % not work for drone
  %agent(i).set_property("controller", Controller_PID_based(dt)); % not work for drone
  %agent(i).set_property("controller",Controller_APID(dt));
  %% 必要か？実験で確認 : TODO
  param(i).sensor.list = cell(1, length(agent(i).sensor.name));
  param(i).reference.list = cell(1, length(agent(i).reference.name));
end
