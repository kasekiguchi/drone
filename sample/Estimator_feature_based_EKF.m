function Estimator = Estimator_feature_based_EKF(agent,output,var)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    Estimator.name="feature_ekf";
    Estimator.type="feature_based_EKF";
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    if isfield(agent(1).sensor,'imu')
        output = ["w","a"];
    end
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    syms dummy1 dummy2
    col = agent.model.state.num_list;
    feature_based_EKF_param.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    feature_based_EKF_param.Q = diag([ones(3,1)*10^2;ones(3,1)*10^4]);%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
%     feature_based_EKF_param.Ri = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
    %%
    if agent.model.state.type == 3 % 姿勢がオイラー角の場合
%        feature_based_EKF_param.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
        feature_based_EKF_param.B = [1/2*eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
    elseif  agent.model.state.type == 4 % 姿勢がオイラーパラメータの場合
        feature_based_EKF_param.B = [1/2*eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
    end
    if strcmp(agent.model.name,"Suspended_Load_Model")
        feature_based_EKF_param.Q = eye(13)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
        feature_based_EKF_param.B = [1/2*dt^2*eye(7),zeros(7,6);...
            1/2*dt^2*eye(3),zeros(3,10);...
            zeros(3,13);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,10),dt*eye(3);...
            zeros(3,10),dt*eye(3)];
    end
    feature_based_EKF_param.gamma       = 0.1;%有効領域
    feature_based_EKF_param.SNR         = 1.0E-5;% SN ratio for initial value of posterior error covariance matrix
    feature_based_EKF_param.P = eye(n); % 初期共分散行列
    feature_based_EKF_param.list=output;
    Estimator.param=feature_based_EKF_param;
end

function mat = zeroone(row,col,idx)
    if idx == 0
        mat = zeros(row,col);
    elseif row== col
        mat = eye(row);
    else
        error("ACSL : invalid size");
    end
end

