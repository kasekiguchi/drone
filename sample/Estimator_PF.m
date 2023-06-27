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
    dt = agent.model.dt;
    n = agent.model.dim(1);% 状態数
    if isempty(opts.P)
        opts.P = 1e-5*eye(n);
    end
    Estimator.list=output_char;
    Estimator.prediction=@(x,u) x + dt*cell2mat(arrayfun(@(i) agent.model.method(x(:,i),u(:,i),agent.model.param),1:opts.sample,'UniformOutput',false));
    %Estimator.prediction=@(x,u) ode_function(agent.model.method,x,u,agent.model.param,opts.sample,dt);
    Estimator.output_function = @(x) x(1:6,:);
    Estimator.sd = opts.sd;
    Estimator.P = opts.P;
    Estimator.R = opts.R;
    Estimator.sample = opts.sample;
    Estimator.dt = agent.model.dt;
    %agent.plot=agent.estimator.pf.show("flag",mod(time.t,0.2)<dt,"FH",PL);

end
function X = ode_function(method,x,u,param,sample,dt)
    for i = sample:-1:1
       [~,tmp]=ode45(@(t,x) method(x,u(:,i),param),[0,dt],x(:,i));
       X(:,i) = tmp(end,:)';
    end
end

