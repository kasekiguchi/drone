classdef HLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    inifTime
  end

  methods
    function obj = HLC(self,param)
      obj.self = self;
      obj.param = param;
      obj.param.P = self.parameter.get(obj.parameter_name);
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      obj.inifTime =[];
    end

    function result = do(obj,varargin)
        %実機でMPCを飛ばすときに必要
        % var = varargin{1};
      % if isempty(obj.inifTime) && var{2} =='f'
      %     obj.inifTime = var{1}.t;
      %     obj.result.fTime = 0;
      % elseif var{2} =='f'
      %     obj.result.fTime = var{1}.t - obj.inifTime;
      % end
      
      model = obj.self.estimator.result;
      ref = obj.self.reference.result;
      xd = ref.state.xd;
      xd0 =xd;
      P = obj.param.P;
      F1 = obj.param.F1;
      F2 = obj.param.F2;
      F3 = obj.param.F3;
      F4 = obj.param.F4;
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
%       state_monte = obj.self.estimator.result.state;
% %             % state_monte = obj.self.plant.state;
%             fprintf("==================================================================\n")
%             fprintf("==================================================================\n")
%             fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
%                     state_monte.p(1), state_monte.p(2), state_monte.p(3),...
%                     state_monte.v(1), state_monte.v(2), state_monte.v(3),...
%                     state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi, ...
%                     state_monte.w(1)*180/pi, state_monte.w(2)*180/pi, state_monte.w(3)*180/pi);       % s:state 現在状態
% %             fprintf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
%             fprintf("\n");
      result = obj.result;
    end
  end
end

