function Reference = Reference_2DCoverage(agent,Env)
    %% reference class demo
    % reference property をReference classのインスタンス配列として定義
    clear Reference
    Reference.type=["VoronoiBarycenter"];
    Reference.name=["covering"];
    Reference.param.void=0;
    if isfield(agent.sensor,'rdensity'); Reference.param.r = agent.sensor.rdensity.r;  end
    if isfield(agent.sensor,'rpos'); Reference.param.R = agent.sensor.rpos.r;  end
    if isfield(Env,'d'); Reference.param.d = Env.d;  end
end
