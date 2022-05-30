function Reference = Reference_2DCoverage(agent,Env,param)
    % reference class demo
    % reference property をReference classのインスタンス配列として定義
    arguments
        agent
        Env
        param.void = 0.2;
    end
    clear Reference
    Reference.type=["VORONOI_BARYCENTER"];
    Reference.name=["covering"];
    Reference.param.void=param.void;
    if isfield(agent.sensor,'rdensity'); Reference.param.r = agent.sensor.rdensity.r; else warning("ACSL : required RANGE_DENSITY_SIM (Sensor_RangeD)"); end
    if isfield(agent.sensor,'rpos'); Reference.param.R = agent.sensor.rpos.r; else warning("ACSL : required RANGE_POS_SIM (Sensor_RangePos)"); end
    if isfield(Env,'d'); Reference.param.d = Env.d;  end
    Reference.param.fShow = 1;
end
