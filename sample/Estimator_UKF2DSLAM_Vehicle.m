function Estimator = Estimator_UKF2DSLAM_Vehicle(agent, dt, model, output)
arguments
    agent
    dt
    model
    output = ["p", "q"]
end

Estimator.model = model;

%UKF_param.Q = diag([1, 1, 1, 1e-1, 1e-1]);
%UKF_param.Q = diag([0.001, 0.001, 0.001, 1]);%
% UKF_param.Q = diag([1e-2, 1e-2, 1e-2, 1e-1]);
UKF_param.Q = diag([1e-2, 1e-2, 1e-1]); %*8.6; %ボットのシステムノイズ
% UKF_param.R = 3.5e-5;
UKF_param.R = 2.5e-5; %6.0e-5 %3.6e-6; %1.0e-2 %観測ノイズ1.4e-4
UKF_param.Map_Q = 1.0e-3; %1.0e-5;
% UKF_param.Map_Q =1.0e-5;%1.0e-2%マップのシステムノイズ
n = model.dim(1); %ロボGットモデルの状態数を呼び出し
UKF_param.dim = n;
UKF_param.P = eye(n); %初期時刻の共分散行列
%UKF_param.k = 800;%スケーリングパラメータ
UKF_param.k = 2; %2スケーリングパラメータ : kappa in [0,3] : 1000
UKF_param.NLP = 2; %Number of Line Param = [d, alpha]
% UKF_param.SensorRange = agent.sensor.lrf.radius; %センサレンジを呼び出し
% UKF_param.list = agent.model.state.list;

% the constant value for estimating of the map
UKF_param.constant = struct; %定数パラメータ設定
UKF_param.constant.LineThreshold = 0.4; %0.3; % 点群から直線を求める時に直線に含む点の直線からの距離閾値
UKF_param.constant.SegmentThreshold = 0.8; %0.5 線分からの距離：線分を直線に統合するかの基準
UKF_param.constant.PointThreshold = 0.3; %0.2; %
UKF_param.constant.GroupNumberThreshold = 5; %5 クラスタを構成する最小の点数
UKF_param.constant.DistanceThreshold = 1e-1; %1e-1; % センサ値と計算値の許容誤差，対応付けに使用
UKF_param.constant.ZeroThreshold = 1e-3; % 1e-3ゼロとみなす閾値
UKF_param.constant.CluteringThreshold = 0.5; %0.5; % 同じクラスタとみなす最大距離 通路幅/2より大きくすると曲がり角で問題が起こる
UKF_param.constant.SensorRange = agent.sensor.lrf.radius; % Max scan range
UKF_param.constant.LineDistance = 1; %1 既存マップ端点からこれ以上離れた線分は別の線分とみなす．
Estimator.param = UKF_param;
end
