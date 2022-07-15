function Estimator = Estimator_PF(agent,output_char,opts)
    % output ：出力のリスト　例 ["p","q"]
    % var : 各出力に対するセンサーの観測ノイズs
    %% estimator class demo
    % estimator property をEstimator classのインスタンス配列として定義
    % すべての機体で同一設定
    arguments
        agent
        output_char = ["p","q"];
        opts.P = [];
        opts.sd = 0.03; % system noise 
        opts.sample = 2000;
        opts.R = diag([0.001*ones(1,3), 0.00001*ones(1,3)]);
    end
    Estimator.name="pf";
    Estimator.type="PARTICLE_FILTER";
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    if isempty(opts.P)
        opts.P = 1e-5*eye(n);
    end
    PF_param.list=output_char;
    PF_param.prediction=@(x,u) x + dt*cell2mat(arrayfun(@(i) agent.model.method(x(:,i),u(:,i),agent.model.param),1:opts.sample,'UniformOutput',false));
    PF_param.output_function = @(x) x(1:6,:);
    PF_param.sd = opts.sd;
    PF_param.P = opts.P;
    PF_param.R = opts.R;
    PF_param.sample = opts.sample;
    PF_param.dt = agent.model.dt;
    Estimator.param=PF_param;
    %agent.plot=agent.estimator.pf.show("flag",mod(time.t,0.2)<dt,"FH",PL);

end
