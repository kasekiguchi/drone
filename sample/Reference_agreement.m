function Reference = Reference_agreement(agent)
    %% reference class demo
    % reference property をReference classのインスタンス配列として定義
    clear Reference
    Reference.type=["consensus_agreement"];
    Reference.name=["agreement"];
    Reference.param.void=0.3;
    if isfield(agent.sensor,'rdensity'); Reference.param.r = agent.sensor.rdensity.r;  end
    if isfield(agent.sensor,'rpos'); Reference.param.R = agent.sensor.rpos.r;  end
end
