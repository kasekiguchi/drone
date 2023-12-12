classdef CORRECT_OBSERVABILITY < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    est
    dt
    result
    param
    Lghn
    eps
    Obs
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
  end

  methods
    function obj = CORRECT_OBSERVABILITY(self,param)
      obj.self = self;
      obj.est = self.estimator;
      obj.param = param;
      obj.dt = param.dt;
      obj.Obs = param.Obs_func;
      obj.eps = param.eps;
      ELfile=strcat("Lghn_",obj.est.model.name,'_',param.funcname);
        if ~exist(ELfile,"file")
            obj.Lghn=CalculateLghn(ELfile,obj.est,param.funcname);
        else
            obj.Lghn=str2func(ELfile);
        end
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
      state = obj.self.estimator.result.state;
      x = [state.p;state.q;state.v;state.w;state.ps;state.qs];
      p = obj.self.parameter.get(); 
      u = obj.result.input;
      S = svd(obj.Obs(x,u));
      if S(length(x)) < obj.eps
      D = obj.Lghn(x,u,p);
      [~,~,V] = svd(D);
%       en2 = V(1,:)';
      en = V(:,1); %誘導ノルムより
      De = D * en;
      norm_De = norm(De, 2);
%       norm_De2 = norm(D*en2, 2);
      epsn = obj.eps/(obj.dt * norm_De);
      obj.result.input = epsn * en;
      else
          obj.result.input = zeros(obj.self.estimator.model.dim(2),1);
      end
      result = obj.result;
    end
  end
end