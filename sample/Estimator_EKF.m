function Estimator_EKF(agent)

%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
% すべての機体で同一設定
Estimator.name="ekf";
Estimator.type="EKF";
dt = agent(1).model.dt;
n = agent(1).model.dim(1);
%    EKF_param.Q = 100* diag([0.5;0.5;0.5;0.9;0.9;1.8]);%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    EKF_param.Q = 100* diag(ones(n,1));%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5]/100;[6.716E-5; 7.058E-5; 7.058E-5]/1000]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
%    EKF_param.R = 10^-5*diag(ones(sum(agent(1).sensor.result.state.num_list),1));
%    EKF_param.JacobianH = @(~,~) eye(n); % C行列 全状態観測
    pqnum = sum(agent(1).model.state.num_list(contains(agent(1).model.state.list,["p","q"]))); % p, q の次元の和
    EKF_param.JacobianH = @(~,~) [eye(pqnum),zeros(pqnum,n-pqnum)];% C行列 p, q観測
if isfield(agent(1).sensor,'imu')
    EKF_param.JacobianH = ["w","a"];
end
    EKF_param.H = EKF_param.JacobianH;
    %EKF_param.B = [eye(6)*dt^2;eye(6)*dt];%eye(sum(agent(1).model.state.num_list)); % システムノイズが加わるチャンネル
    EKF_param.B = eye(n); % システムノイズが加わるチャンネル
    EKF_param.P = eye(n); % 初期共分散行列
    EKF_param.list=["p","q"];
Estimator.param=EKF_param;
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
disp('Execute "do" method with following parameter to operate EKF estimator.');
disp('param.estimator={{agent(i),agent(i).sensor.result.state.get(["q","p"]),[]}};')
end
