function Estimator = Estimator_KF(agent,output,var)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズ
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments 
        agent
        output
        var.Q = 1E-3;
        var.R = 1E-2;
    end
    Estimator.name="kf";
    Estimator.type="KF";
    dt = agent.model.dt;
    tmp=arrayfun(@(i) strcmp(agent.model.state.list,output(i)),1:length(output),'UniformOutput',false);
    col = agent.model.state.num_list;
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    n = agent.model.dim(1);% 状態数
    m = agent.model.dim(2);% 入力数
    KF_param.Q = var.Q.*eye(m);
    KF_param.R = var.R.*eye(sum(output_num));
    %%
    KF_param.P = eye(n); % 初期共分散行列
    KF_param.A = agent.parameter.A;
    KF_param.B = agent.parameter.B;
    KF_param.C = agent.parameter.C;
    
    KF_param.list=output;
    Estimator.param=KF_param;
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

