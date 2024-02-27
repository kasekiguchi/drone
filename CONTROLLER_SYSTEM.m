classdef CONTROLLER_SYSTEM < matlab.System
  % untitled Add summary here
  %
  % This template includes the minimum set of functions required
  % to define a System object.

  % Public, tunable properties
  properties (DiscreteState)
    % setting_name
    % self
    input
  end

  % Pre-computed constants or internal states
  properties (Access = private)
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
  end
methods
  function obj = CONTROLLER_SYSTEM(varargin)
      % obj.self = self;
      % obj.param = param;
      % Perform one-time calculations, such as computing constants
      setProperties(obj,nargin,varargin{:})
      %obj.result.input = zeros(4,1);
    end
end
  methods (Access = protected)

    function setupImpl(obj)
        tmp=coder.load("cparam.mat");
        obj.param = tmp.param;
        obj.input = [0;0;0;0];
    end
    function u = stepImpl(obj,x,xd)
      % Implement algorithm. Calculate y as a function of input u and
      % internal states.
      dt = 0.01;
      P = obj.param.P;
      F1 = obj.param.F1;
      F2 = obj.param.F2;
      F3 = obj.param.F3;
      F4 = obj.param.F4;
      xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

      % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      p = x(5:7);
      q = x(1:4);
      v = x(8:10);
      w = x(11:13);
      x = [R2q(Rb0'*RodriguesQuaternion(q));Rb0'*p;Rb0'*v;Rb0'*w];
      %x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      %if isfield(obj.param,'dt')
      vf = Vfd(dt,x,xd',P,F1);
      vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
      %vs = Vs(x,xd',vf,P,F2,F3,F4);
      %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
      tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
      % max,min are applied for the safty
      obj.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      %result = obj.result;
      u = obj.input;
    end

    function resetImpl(obj)
        obj.input = [0;0;0;0];
      % Initialize / reset internal properties
    end
  end
end
