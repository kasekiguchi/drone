classdef HLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    AdBd
    gainFunc
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
  end

  methods
    function obj = HLC(self,param)
      obj.self = self;
      obj.param = param;
      obj.param.P = self.parameter.get(obj.parameter_name);
      % obj.AdBd = param.AdBd; 
      % p2 = param.p2;
      % p4 = param.p4;
      % obj.gainFunc = @(sA2d, sB2d, sA4d, sB4d) deal(place(sA2d, sB2d,p2),place(sA4d,sB4d,p4),place(sA4d,sB4d,p4),place(sA2d,sB2d,p2));%意図した極（p2,p4）になるようにゲインを計算。
      obj.gainFunc = param.gainFunc;%意図した極（p2,p4）になるようにゲインを計算。
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result;
      ref = obj.self.reference.result;
      xd = ref.state.xd;
      xd0 =xd;
      P = obj.param.P;

      xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

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
        [F1,F2,F3,F4]=obj.gainFunc(dt);
        % [A2d,B2d,A4d,B4d]=obj.AdBd(dt);
        % [F1,F2,F3,F4]=obj.gainFunc(A2d,B2d,A4d,B4d)
         % F1 = obj.param.F1;
         % F2 = obj.param.F2;
         % F3 = obj.param.F3;
         % F4 = obj.param.F4;
      else
        dt = obj.param.dt;
        F1 = obj.param.F1;
         F2 = obj.param.F2;
         F3 = obj.param.F3;
         F4 = obj.param.F4;
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

