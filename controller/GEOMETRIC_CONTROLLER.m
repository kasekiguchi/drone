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
      obj.param = param;
      obj.param.P = self.parameter.get(obj.parameter_name);
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
      m0 = obj.param.P(2);
      g  = obj.param.P(1);
      rho1 = obj.param.P(6:8)';
      rho2 = obj.param.P(9:11)';
      rho3 = obj.param.P(12:14)';
      rho4 = obj.param.P(15:17)';
      rho_hat = [Skew(rho1),Skew(rho2),Skew(rho3),Skew(rho4)];
      P_mat = [eye(3),eye(3),eye(3),eye(3);rho_hat]; 

      e3 = [0;0;1];
      J0 = diag([obj.param.P(3),obj.param.P(4),obj.param.P(5)]);
      model = obj.self.estimator.result.state;
      ref = obj.self.reference.result;
      pd = ref.state.p;
      Qd = ref.state.Q;
      vd = ref.state.v;
      Od = ref.state.O;
      ddxd = ref.state.ddx;
      dOd = ref.state.dO; %ペイロード角加速度
      P = obj.param.P;
      xd=0;

      Rb0 = RodriguesQuaternion(model.Q);
      Rbd = RodriguesQuaternion(Qd);
      kx0 = obj.param.F1; %Controller_Cooperative_Load(dt)から係数を持ってくる
      kdx0 = obj.param.F2;
      kR0 = obj.param.F3;
      kO0 = obj.param.F4; 
%       xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

      % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      ex0 = model.p - pd;
      edx0 = model.v - vd;
      eQ0 = 1/2*Vee(Rbd'*Rb0 - Rb0'*Rbd);
%       ev0 = model.v - vd;
      eO0 = model.O - Rb0'*Rbd*Od;
      
      Fd = m0*(-kx0*ex0 - kdx0*edx0 + ddxd - g*e3);
      R0Fd = Rb0'*Fd;
      Md = -kR0*eR0 - kO0*eO0 + Skew(Rb0'*Rbd*Od)*J0*Rb0'*Rbd*Od + J0*Rb0'*Rbd*dOd;
      con_mat = [R0Fd;Md];

      img_mu = diag(Rb0,Rb0,Rb0,Rb0)*P_mat'\(P_mat*P_mat')*con_mat;
      
      % max,min are applied for the safty
      result = obj.result;
    end
  end
end