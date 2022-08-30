function Reference = Reference_3DCoverage(agent,param)
% reference ckass demo
% reference property を Reference class のインスタンス配列として定義
% 3次元ボロノイ分割クラス用
arguments
    agent
    param.void = 0.05 % gridの刻み幅
end
clear Reference
Reference.type = ["VORONOI_BARYCENTER_3D"];
Reference.name = ["covering_3D"];
Reference.param.void = param.void;
if isfield(agent.sensor,'rdensity'); Reference.param.r = agent.sensor.rdensity.r; else warning("ACSL : required RANGE_DENSITY_SIM (Sensor_RangeD)"); end
if isfield(agent.sensor,'rpos'); Reference.param.R = agent.sensor.rpos.r; else warning("ACSL : required RANGE_POS_SIM (Sensor_RangePos)"); end
% if isfield(Env,'d'); Reference.param.d = Env.d;  end
Reference.param.fShow = 0;
end

