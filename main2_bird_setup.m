%% generate environment
%Env = DensityMap_sim(Env_2DCoverage); % 重要度マップ設定
% Env = Map3D_sim(Env_3DCoverage()); % 3次元重要度マップ設定
% Env = [];

for i = 1:Nb
    %% generate Drone instance
    % DRONE classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
    if fExp
        bird(i) = BIRD(Model_Bird_Exp(dt,initial_bird_state(i),"udp",[50,132]),BIRD_PARAM("TCUbird")); % for exp % 機体番号（ESPrのIP）
        bird(i).input = [0; 0; 0; 0];
    else
%         bird(i) = BIRD(Model_Bird(dt,initial_bird_state(i), i),BIRD_PARAM("TCUbird"));                % euler angleのプラントモデル : for sim
        bird(i) = BIRD(Model_Bird_EulerAngle(dt,initial_bird_state(i), i),BIRD_PARAM("TCUbird"));                % euler angleのプラントモデル : for sim
    end

    %% model
    % set control model
%     bird(i).set_model(Model_Bird(dt,initial_bird_state(i),i),BIRD_PARAM("TCUbird")) % 鳥のモデル（離散時間モデル）
    bird(i).set_model(Model_Bird_EulerAngle(dt,initial_bird_state(i),i),BIRD_PARAM("TCUbird")) % 鳥のモデル（オイラー角モデル）
    close all
    %% set input_transform property
    if fExp                                                                               % isa(agent(i).plant,"Lizard_exp")
        bird(i).input_transform = [];
        bird(i).set_property("input_transform", InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
    end
    %% set sensors property
    bird(i).sensor = [];
%     if fMotive
%         if ~exist('initial_bird_yaw_angles')
%             initial_bird_yaw_angles = zeros(1, Nb);
%         end
%         bird(i).set_property("sensor", Sensor_Motive(bird_ids(i), initial_bird_yaw_angles(i), motive_bird)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
%     end

    bird(i).set_property("sensor",Sensor_RangePos_Bird(i,'r',1.5)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
    bird(i).set_property("sensor",Sensor_Direct(0.0)); % 状態真値(plant.state)　：simのみ % 入力はノイズの大きさ
%     bird(i).set_property("sensor",Sensor_Map_3D(agent,'d',10)); % 測定距離d（第二引数宇）内の重要度を計測 : sim のみ
    %% set estimator property
    bird(i).estimator = [];
    bird(i).set_property("estimator",Estimator_Direct()); % Directセンサーと組み合わせて真値を利用する　：sim のみ
%     bird(i).set_property("estimator",Estimator_EKF(bird(i), ["p", "q"])); % （剛体ベース）EKF
    %% set reference property
    bird(i).reference = [];
    bird(i).set_property("reference",Reference_Bird(Nb)); % 鳥の群れの動き
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    bird(i).set_property("reference", Reference_Point_FH());                              % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    bird(i).controller = [];
%     bird(i).set_property("controller", Controller_HL(dt));                                % 階層型線形化
    bird(i).set_property("controller", Controller_BIRD());                                % 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
    %% 必要か？実験で確認 : TODO
    param(i).sensor.list = cell(1, length(bird(i).sensor.name));
    param(i).reference.list = cell(1, length(bird(i).reference.name));
end
