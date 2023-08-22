classdef CSLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    P
    parameter_name = ["g","m0","J0","rho","li","mi","Ji"];
    gains
    Pdagger
    gen_input
    N
    toR
    dqid
    ddqid
  end

  methods
    function obj = CSLC(self,param)
      obj.self = self;
      obj.P = self.parameter.get("all","row");
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],self.parameter.rho));
      obj.Pdagger = pinv(P);
      obj.N = size(P,2)/3;
      obj.gains = param.gains; %
      %[kx0' kr0 kdx0' ko0 kqi kwi kri koi epsilon]
      obj.gen_input = str2func(param.method);
      if self.estimator.model.state.type ==3
        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
      else
        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
      end
      obj.dqid = 0;
      obj.ddqid = 0;
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result.state;
      ref = obj.self.reference.result.state;
      x = model.get(["p"  "Q" "v"    "O"    "qi"    "wi"  "Qi"  "Oi"]);
      qi = reshape(model.qi,3,obj.N);
      Ri = obj.toR(model.Qi);
      R0 = obj.toR(model.Q);
      xd = 0*ref.xd;
      R0d = reshape(xd(end-8:end),3,3);
      R0d = eye(3);
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      %[obj.result.input,obj.dqid,obj.ddqid] = obj.gen_input(x,qi,R0,Ri,R0d,xd,obj.gains,obj.P,obj.Pdagger,obj.dqid,obj.ddqid);
      obj.result.input = obj.gen_input(x,qi,R0,Ri,R0d,xd,obj.gains,obj.P,obj.Pdagger);
      result = obj.result;
    end
  end
end