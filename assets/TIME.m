classdef TIME < handle
% handle化するためだけのクラス
properties
    t
    ts
    te
    dt
end
methods
  function obj = TIME(ts,dt,te)
    obj.t = ts;
    obj.ts = ts;
    obj.dt = dt;
    obj.te = te;    
  end
end

end
