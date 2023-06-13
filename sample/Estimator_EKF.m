function Estimator = Estimator_EKF(agent,dt,initial_state,model,output,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments
        agent
        dt
        initial_state
        model
        output = ["p","q"]
        opts.B = []
        opts.P = []
        opts.Q = []
        opts.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3)]);
    end
    Estimator.model = model;
    %dt = Estimator.model.dt;
    n = Estimator.model.dim(1);% 状態数
    % 出力方程式の拡張線形化行列(JacobianH)の生成
    % output で登録された出力
    if class(output)=="function_handle"
        Estimator.JacobianH = output;
    else
        tmp=arrayfun(@(i) strcmp(Estimator.model.state.list,output(i)),1:length(output),'UniformOutput',false);
        syms dummy1 dummy2
        col = Estimator.model.state.num_list;
        Estimator.JacobianH= matlabFunction(cell2mat(arrayfun(@(k) cell2mat(arrayfun(@(i,j) zeroone( col*tmp{k}',i,j),col,tmp{k},"UniformOutput",false)),1:length(output),"UniformOutput",false)'),"Vars",[dummy1,dummy2]);
    end
    
    % P, Q, R, B生成
    if isempty(opts.P) % 初期共分散行列
        Estimator.P = eye(n);
    else
        Estimator.P = opts.P;
    end
    if isempty(opts.Q)
        Estimator.Q = eye(6);%diag([1E3,1E3,1E3,1E5,1E5,1E5]);%eye(6)*1E3;%*7.058E-5;%diag(ones(n,1))*1e-7;%eye(6)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % システムノイズ（Modelクラス由来）
    else
        Estimator.Q = opts.Q;
    end
    Estimator.R = opts.R;
    if isempty(opts.B)
        if Estimator.model.state.type == 3 % 姿勢がオイラー角の場合
        %Estimator.B = [eye(6)*dt^2;eye(6)*dt]; % システムノイズが加わるチャンネル
            Estimator.B = [eye(6)*0.01;eye(6)*0.1]; % システムノイズが加わるチャンネル
        elseif  Estimator.model.state.type == 4 % 姿勢がオイラーパラメータの場合
            Estimator.B = [eye(6)*dt^2;zeros(1,6);eye(6)*dt]; % システムノイズが加わるチャンネル
        end
    else
        Estimator.B = opts.B;
    end

    if strcmp(Estimator.model.name,"Suspended_Load_Model")
        Estimator.Q = blkdiag(eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-3,eye(3)*1E-8); % システムノイズ（Modelクラス由来）
        Estimator.B = blkdiag([0.5*dt^2*eye(6);dt*eye(6)],[0.5*dt^2*eye(3);dt*eye(3)],[zeros(3,3);dt*eye(3)]);
    end
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
