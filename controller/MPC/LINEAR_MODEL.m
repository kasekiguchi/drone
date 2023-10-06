classdef LINEAR_MODEL < handle
  properties
    Ad
    Bd
    Cd
    Dd
    dt
    gen_ss
    x
    y
  end

  methods
    function obj = LINEAR_MODEL(gen_ss,dt,x)
      % linear discrete model
      obj.dt = dt;
      obj.gen_ss = gen_ss;
      [obj.Ad,obj.Bd,obj.Cd,obj.Dd] = ssdata(obj.gen_ss(obj.dt));
      obj.x = x;
      obj.y = obj.Cd*obj.x;
    end

    function x = do(obj,u)
      % calc 1 step time evolution
      x = obj.Ad*obj.x + obj.Bd*u;
      obj.y = obj.Cd*obj.x + obj.Dd*u;
      obj.x = x;
    end
  end
end