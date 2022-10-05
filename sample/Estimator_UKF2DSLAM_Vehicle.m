function Estimator = Estimator_UKF2DSLAM_Vehicle(agent,SensorRange)

%% estimator class
Estimator.name="ukfslam";
Estimator.type="UKF2DSLAM";
%UKF_param.Q = diag([1, 1, 1, 1e-1, 1e-1]);
%UKF_param.Q = diag([0.001, 0.001, 0.001, 1]);%
UKF_param.Q = 0.1*diag([1e-3, 1e-3, 1e-3, 1e-1]);%ロボットのシステムノイズ
UKF_param.R = 1.0E-3;%観測ノイズ
UKF_param.Map_Q =1.0E-3;%マップのシステムノイズ
n = agent.model.dim(1);%ロボットモデルの状態数を呼び出し
UKF_param.dim = n;
UKF_param.P = eye(n); %初期時刻の共分散行列
%UKF_param.k = 800;%スケーリングパラメータ
UKF_param.k = 1;%スケーリングパラメータ : kappa in [0,3] : 1000
UKF_param.NLP = 2;%Number of Line Param = [d, alpha]
UKF_param.SensorRange = SensorRange;%センサレンジを呼び出し
UKF_param.list=agent.model.state.list;
Estimator.param=UKF_param;
end