function Estimator = Estimator_PF(agent,output_char,opts)
    % output_char ：出力のリスト　例 ["p","q"]
    % opts
    % 
    arguments
        agent
        output_char = ["p","q"];
        opts.P = [];
        opts.sd = 0.4; % system noise 
        opts.sample = 10000;
        opts.R = diag([0.1*ones(1,3), 0.01*ones(1,3)]); % sensor noise
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
    %PF_param.prediction=@(x,u) ode_function(agent.model.method,x,u,agent.model.param,opts.sample,dt);
    PF_param.output_function = @(x) x(1:6,:);
    PF_param.sd = opts.sd;
    PF_param.P = opts.P;
    PF_param.R = opts.R;
    PF_param.sample = opts.sample;
    PF_param.dt = agent.model.dt;
    Estimator.param=PF_param;
    %agent.plot=agent.estimator.pf.show("flag",mod(time.t,0.2)<dt,"FH",PL);

end
function X = ode_function(method,x,u,param,sample,dt)
    for i = sample:-1:1
       [~,tmp]=ode45(@(t,x) method(x,u(:,i),param),[0,dt],x(:,i));
       X(:,i) = tmp(end,:)';
    end
end

