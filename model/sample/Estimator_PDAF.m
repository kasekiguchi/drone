function Estimator = Estimator_PDAF(agent,output,var)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    if isfield(agent(1).sensor,'imu')
        output = ["w","a"];
    end
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    syms dummy1 dummy2
    col = agent.model.state.num_list;
    Estimator.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false)); 
    
    
    % For simulation
    Estimator.PD          = 0.8;                                             % Target probability
    Estimator.PG          = 0.8;                                             % Gate probability
    Estimator.lambda      = 1.8;                                               % Expected value of Poisson distribution
    Estimator.gamma       = 1;                                               % Validation region
    Estimator.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix
    Estimator.Q = eye(6)*1E3; % システムノイズ
    Estimator.Ri = diag(ones(3,1))*10^-4;                               % Observation covariance matrix of one feature

%     obj.param.sigmaw      = 1.0E-4*ones(3,1);
%     obj.param.sigmav      = [50;50;50;100;100;200];
    Estimator.InvRi   = inv(Estimator.Ri);
    Estimator.P           = eye(12)*Estimator.SNR;
    
     % For experiment for model less
%     Estimator.PD          = 0.8;                                             % Target probability
%     Estimator.PG          = 0.8;                                             % Gate probability
%     Estimator.lambda      = 4;                                               % Expected value of Poisson distribution
%     Estimator.gamma       = 1;                                               % Validation region
%     Estimator.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix
%     Estimator.Q = eye(6)*1E3; % システムノイズ
%     Estimator.Ri = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
%     obj.param.sigmaw      = 1.0E-4*ones(3,1);
%     obj.param.sigmav      = [50;50;50;0.9E02;0.9E02;1.8E02];
%     Estimator.InvRi    = inv(obj.param.Ri);
%     Estimator.P           = eye(12)*obj.param.SNR;
    
     % For experiment for using input model
%     Estimator.PD          = 0.8;                                             % Target probability
%     Estimator.PG          = 0.8;                                             % Gate probability
%     Estimator.lambda      = 4;                                               % Expected value of Poisson distribution
%     Estimator.gamma       = 1;                                               % Validation region
%     Estimator.SNR         = 1.0E-5;                                          % SN ratio for initial value of posterior error covariance matrix
%     Estimator.Q = eye(6)*1E3; % システムノイズ
%     Estimator.Ri = diag(cell2mat(arrayfun(@(i) var(i)*ones(1,output_num(i)),1:length(output_num),"UniformOutput",false)));
%     obj.param.sigmaw      = 1.0E-4*ones(3,1);
%     obj.param.sigmav      = [50;50;50;6.0E01;6.0E01;6.0E01];
%     Estimator.InvRi    = inv(obj.param.Ri);
%     Estimator.P           = eye(12)*obj.param.SNR;
    

    %%
    if agent.model.state.type == 3 % 姿勢がオイラー角の場合
%        Estimator.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
        Estimator.B = [eye(6)*0.01;eye(6)*0.1]; % システムノイズが加わるチャンネル
    elseif  agent.model.state.type == 4 % 姿勢がオイラーパラメータの場合
        Estimator.B = [eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
    end
    if strcmp(agent.model.name,"Suspended_Load_Model")
        Estimator.Q = eye(13)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
        Estimator.B = [dt^2*eye(7),zeros(7,6);...
            dt^2*eye(3),zeros(3,10);...
            zeros(3,13);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,7),dt*eye(3),zeros(3,3);...
            zeros(3,10),dt*eye(3);...
            zeros(3,10),dt*eye(3)];
    end
    Estimator.P = eye(n); % 初期共分散行列
    Estimator.list=output;
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

