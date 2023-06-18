classdef GEOMETRIC_CONTROLLER < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["g","m0","j01","j02","j03","rho1_1","rho1_2","rho1_3","rho2_1","rho2_2","rho2_3","rho3_1","rho3_2","rho3_3","rho4_1","rho4_2","rho4_3","li1","li2","li3","li4","mi1","mi2","mi3","mi4","ji1_1","ji1_2","ji1_3","ji2_1","ji2_2","ji2_3","ji3_1","ji3_2","ji3_3","ji4_1","ji4_2","ji4_3"];
  end

  methods
    function obj = GEOMETRIC_CONTROLLER(self,param)
      obj.self = self;
      obj.param.P = self.parameter.get(obj.parameter_name);
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result;
      ref = obj.self.reference.result;
      xd = ref.state.p;
      P = obj.param.P;
%       F1 = obj.param.F1;
%       F2 = obj.param.F2;
%       F3 = obj.param.F3;
%       F4 = obj.param.F4;
%       xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

      % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      %if isfield(obj.param,'dt')
      if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
        dt = varargin{1}.dt;
      else
        dt = obj.param.dt;
        % vf = Vf(x,xd',P,F1);
        % vs = Vs(x,xd',vf,P,F2,F3,F4);
      end
        vf = Vfd(dt,x,xd',P,F1);
        vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
      %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
      tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
      % max,min are applied for the safty
      obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      result = obj.result;
    end
  end
end