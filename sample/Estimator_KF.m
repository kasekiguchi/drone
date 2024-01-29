function Estimator = Estimator_KF(agent,dt,model,output,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズ
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments 
      agent
        dt
        model
        output
        opts.B
        opts.P
        opts.Q
        opts.R = diag([1e-5*ones(1,3), 1e-8*ones(1,3)]);
    end
    Estimator.model = model;    
    dt = model.dt;
    tmp=arrayfun(@(i) strcmp(model.state.list,output(i)),1:length(output),'UniformOutput',false);
    col = model.state.num_list;
    output_num =  cell2mat(arrayfun(@(i) col(tmp{i}),1:length(tmp),"UniformOutput",false));
    n = model.dim(1);% 状態数
    m = model.dim(2);% 入力数
    Estimator.Q = opts.Q;
    Estimator.R = opts.R;
    Estimator.B = opts.B;
    %%
    Estimator.P = eye(n); % 初期共分散行列
    Estimator.A = agent.parameter.A;
    Estimator.C = agent.parameter.C;
    
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

