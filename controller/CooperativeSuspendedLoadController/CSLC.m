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
  end

  methods
    function obj = CSLC(self,param)
      obj.self = self;
      obj.P = self.parameter.get("all","row");
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],self.parameter.rho));
      obj.Pdagger = pinv(P);
      obj.N = size(P,2)/3;
      obj.gains = [1,1,1.7321,1.7321,1,1.7321,1,1.7321,0.1]'; % kx0, kr0,kdx0, ko0, kqi, kwi, kri, koi, e
      obj.gen_input = str2func(param.method);
      if self.estimator.model.state.type ==3
        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
      else
        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
      end
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result.state;
      ref = obj.self.reference.result.state;
      x = model.get(["p"  "v"    "O"    "qi"    "wi"    "Oi"]);
      qi = reshape(model.qi,3,obj.N);
      Ri = obj.toR(model.Qi);
      R0 = obj.toR(model.Q);
      R0d = obj.toR([0;0;0]);

      %xd = ref.xd;
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      % Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      % % x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
      % xd = [x0d;dx0d;ddx0d;dddx0d;r0d;o0d;do0d]
      xd = [[0;0;0];[0;0;0];[0;0;0];[0;0;0];[0;0;0];[0;0;0]];
      % xd(1:3)=Rb0'*xd(1:3);
      % xd(4) = 0;
      % xd(5:7)=Rb0'*xd(5:7);
      % xd(9:11)=Rb0'*xd(9:11);
      % xd(13:15)=Rb0'*xd(13:15);
      % xd(17:19)=Rb0'*xd(17:19);

      % if vecnorm(vd(1:2)) == 0
      %   vdt = [1;0;0];
      %   dvdt = [0;0;0];
      %   ddvdt = [0;0;0];
      % else
      %   vdt = vd;
      %   dvdt = dvd;
      %   ddvdt = ddvd;
      % end
      obj.result.input = obj.gen_input(x,qi,R0,Ri,R0d,xd,obj.gains,obj.P,obj.Pdagger);
      result = obj.result;
    end
  end
end