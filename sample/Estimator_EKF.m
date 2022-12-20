function Estimator = Estimator_EKF(agent,output,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments
        agent
        output = ["p","q"]
        opts.B = []
        opts.P = []
        opts.Q = []
        opts.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3)]);
    end
    Estimator.name="ekf";
    Estimator.type="EKF";
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数

    % 出力方程式の拡張線形化行列(JacobianH)の生成
    % output で登録された出力
    if class(output)=="function_handle"
        EKF_param.JacobianH = output;
    else
        tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
        syms dummy1 dummy2
        col = agent.model.state.num_list;
        EKF_param.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    end
    
    % P, Q, R, B生成
    if isempty(opts.P) % 初期共分散行列
        EKF_param.P = eye(n);
    else
        EKF_param.P = opts.P;
    end
    if isempty(opts.Q)
        EKF_param.Q = diag([1E3,1E3,1E3,1E5,1E5,1E5]);%eye(6)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    else
        EKF_param.Q = opts.Q;
    end
    EKF_param.R = opts.R;
    if isempty(opts.B)
        if agent.model.state.type == 3 % 姿勢がオイラー角の場合
%        EKF_param.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
            EKF_param.B = [eye(6)*0.01;eye(6)*0.1]; % システムノイズが加わるチャンネル
        elseif  agent.model.state.type == 4 % 姿勢がオイラーパラメータの場合
            EKF_param.B = [eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
        end
    else
        EKF_param.B = opts.B;
    end

    if strcmp(agent.model.name,"Suspended_Load_Model")
        EKF_param.Q = blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8); % システムノイズ（Modelクラス由来）
        EKF_param.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]);
    end
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
