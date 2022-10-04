function Reference = Reference_3DCoverage(agent,Env)
% reference ckass demo
% reference property を Reference class のインスタンス配列として定義
% 3次元ボロノイ分割クラス用
arguments
    agent
    Env
end
clear Reference
Reference.type = ["VORONOI_BARYCENTER_3D"];
Reference.name = ["covering_3D"];
Reference.param = Env;
if isfield(agent.sensor,'rpos')
    Reference.param.R = agent.sensor.rpos.r;
else
    warning("ACSL : required RANGE_POS_SIM (Sensor_RangePos)");
end
end

