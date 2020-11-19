function Estimator = Estimator_EKF(agent,output,var)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    Estimator.name="ekf";
    Estimator.type="EKF";
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    if isfield(agent(1).sensor,'imu')
        output = ["w","a"];
    end
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    syms dummy1 dummy2
    col = agent.model.state.num_list;
    EKF_param.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    %EKF_param.Q = 100* diag([0.5;0.5;0.5;0.9;0.9;1.8;0.5;0.5;0.5;0.9;0.9;1.8]);%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    EKF_param.Q = eye(6)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    %    EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5]/100;[6.716E-5; 7.058E-5; 7.058E-5]/1000]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
    EKF_param.R = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
    %EKF_param.R = diag([[6.716E-5;6.716E-5;6.716E-5;6.716E-5]/1000;[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
    %EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5]/100;[6.716E-5; 7.058E-5; 7.058E-5]/1000;[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 観測ノイズ（Sensorクラス由来）
    %    EKF_param.R = 10^-5*diag(ones(sum(agent(1).sensor.result.state.num_list),1));
    %%
    if agent.model.state.type == 3 % 姿勢がオイラー角の場合
        EKF_param.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
    elseif  agent.model.state.type == 4 % 姿勢がオイラーパラメータの場合
        EKF_param.B = [eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
    end
    if strcmp(agent.model.name,"Suspended_Load_Model")
        EKF_param.Q = eye(13)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
        EKF_param.B = [dt^2*eye(7),zeros(7,6);...
            dt^2*eye(3),zeros(3,10);...
            zeros(3,13);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,10),dt*eye(3);...
            zeros(3,10),dt*eye(3)];
    end
    EKF_param.P = eye(n); % 初期共分散行列
    EKF_param.list=output;
    Estimator.param=EKF_param;
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

