function Estimator = Estimator_UKF2DSLAM_Vehicle(agent)

%% estimator class
%Estimator.Q = diag([1, 1, 1, 1e-1, 1e-1]);
%Estimator.Q = diag([0.001, 0.001, 0.001, 1]);%
Estimator.Q = diag([1e-2, 1e-2, 1e-2, 1e-1]);%ロボットのシステムノイズ
Estimator.R = 1.0E-2;%観測ノイズ
Estimator.Map_Q =1.0E-2;%マップのシステムノイズ
n = agent.model.dim(1);%ロボットモデルの状態数を呼び出し
Estimator.dim = n;
Estimator.P = eye(n); %初期時刻の共分散行列
%Estimator.k = 800;%スケーリングパラメータ
Estimator.k = 2;%スケーリングパラメータ : kappa in [0,3] : 1000
Estimator.NLP = 2;%Number of Line Param = [d, alpha]
Estimator.SensorRange = agent.sensor.lrf.radius;%センサレンジを呼び出し
Estimator.list=agent.model.state.list;

% the constant value for estimating of the map
Estimator.constant = struct; %定数パラメータ設定
Estimator.constant.LineThreshold = 0.3;%0.3; % 点群から直線を求める時に直線に含む点の直線からの距離閾値
Estimator.constant.SegmentThreshold = 0.5;% 線分からの距離：線分を直線に統合するかの基準
Estimator.constant.PointThreshold = 0.2;%0.2; %
Estimator.constant.GroupNumberThreshold = 5; % クラスタを構成する最小の点数
Estimator.constant.DistanceThreshold = 1e-2;%1e-1; % センサ値と計算値の許容誤差，対応付けに使用
Estimator.constant.ZeroThreshold = 1e-3; % ゼロとみなす閾値
Estimator.constant.CluteringThreshold = 0.5;%0.5; % 同じクラスタとみなす最大距離 通路幅/2より大きくすると曲がり角で問題が起こる
Estimator.constant.SensorRange = agent.sensor.lrf.radius; % Max scan range
Estimator.constant.LineDistance = 1; % 既存マップ端点からこれ以上離れた線分は別の線分とみなす．

end