function Reference = Reference_2DCoverage(agent,Env,param)
    % reference class demo
    % reference property をReference classのインスタンス配列として定義
    arguments
        agent
        Env
        param.void = 0.2;
    end
    Reference.void=param.void;
    if isfield(agent.sensor,'rdensity'); Reference.r = agent.sensor.rdensity.r; else warning("ACSL : required RANGE_DENSITY_SIM (Sensor_RangeD)"); end
    if isfield(agent.sensor,'rpos'); Reference.R = agent.sensor.rpos.r; else warning("ACSL : required RANGE_POS_SIM (Sensor_RangePos)"); end
    if isfield(Env,'d'); Reference.d = Env.d;  end
    Reference.fShow = 0;
end
