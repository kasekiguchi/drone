function Estimator = Estimator_UKFSLAM_WheelChairA(agent,SensorRange)

%% estimator class
Estimator.name="ukfslam_WC";
% Estimator.type="UKFSLAM_WheelChairA";%propose method
Estimator.type="UKFSLAM_WheelChairAomega";%モデルに対応したクラス名を呼び出す
UKF_param.dt = agent(1).model.dt;%刻み時間はモデルと同じ
% UKF_param.Q = diag([1, 1, 1, 1e-1, 1e-1]);
UKF_param.Q = diag([0.1, 0.1, 1e-3, 1]);%0.1*diag([1, 1, 1e-2, 100]);%ロボットのシステムノイズ
UKF_param.R = 1.0E-3;%観測ノイズ
UKF_param.Map_Q =1.0E-3;%マップのシステムノイズ
n = agent.model.dim(1);%ロボットモデルの状態数を呼び出し
UKF_param.dim = n;
UKF_param.P = eye(n); %初期時刻の共分散行列
%UKF_param.k = 800;%スケーリングパラメータ
UKF_param.k = 1000;%スケーリングパラメータ
UKF_param.NLP = 2;%Number of Line Param
UKF_param.SensorRange = SensorRange;%センサレンジを呼び出し
% UKF_param.list=["p","q","v", "w"];
UKF_param.list=["p","q","v"];
Estimator.param=UKF_param;
disp('Execute "do" method with following parameter to operate UKF estimator.');
disp('param.estimator={{agent(i),agent(i).sensor.result.state.get(["q","p"]),[]}}');
end