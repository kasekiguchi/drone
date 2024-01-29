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
    K
    Obs
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
  end

  methods
    function obj = CORRECT_OBSERVABILITY(self,param)
      obj.self = self;
      obj.est = self.estimator;
      obj.param = param;
      obj.dt = param.dt;
      obj.Obs = param.Obs_func; % Lieによる可観測性行列の関数：引数(状態，入力)
      obj.eps = param.eps; % 最少特異値の閾値
      obj.K = param.K; % チューニングパラメータK
      ELfile=strcat("Lghn_",obj.est.model.name,'_',param.funcname); % 推定モデルと可観測性行列の組み合わせから計算時利用するLghnの関数を作成するかの分岐
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
      if S(length(x)) < obj.eps % 可観測性行列の最小と閾値を比較して補正するか判定
          D = obj.Lghn(x,u,p); %
          [~,~,V] = svd(D);
          en = V(:,1); %誘導ノルムの性質よりD*enを最大にするenを右特異ベクトルより算出
          De = D * en;
          norm_De = norm(De, 2);
          epsn = obj.K/(obj.dt * norm_De); % 係数行列の算出
          obj.result.input = epsn * en;
      else
          obj.result.input = zeros(obj.self.estimator.model.dim(2),1);
      end
      result = obj.result;
    end
  end
end