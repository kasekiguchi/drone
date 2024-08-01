classdef CSLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    P
    Param
    parameter_name = ["g","m0","J0","rho","li","mi","Ji"];
    gains
    Pdagger
    gen_input
    gen_muid
    N
    toR
    dqid
    ddqid
    Q2E
  end

  methods
    function obj = CSLC(self,param)
      obj.self = self;
      obj.P = self.parameter.get("all","row");
      % obj.result.input = zeros(self.estimator.model.dim(2),1);
      P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],self.parameter.rho));%張力の仮想入力を求めるための行列P
      obj.Pdagger = pinv(P);
      obj.N = size(P,2)/3;
      obj.Param = param;
      obj.gains = param.gains; %[kx0' kr0 kdx0' ko0 kqi kwi kri koi epsilon]
      obj.gen_input = str2func(param.method);%ドローンの入力(35)
      obj.gen_muid= str2func(param.method2);%紐の張力を求める(27)
      obj.result.mui = zeros(6,obj.N);
      if self.estimator.model.state.type ==3
        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
        obj.Q2E = @(angle) angle;%オイラー角に変換
      else
        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
        obj.Q2E = @(angle) Quat2Eul(angle);%オイラー角に変換
      end
      obj.dqid = 0;
      obj.ddqid = 0;
      %初期入力設定
      parameters = self.parameter;
      input = zeros(4*obj.N,1);
        for i = 1:obj.N
            input(4*i-3) = (parameters.mi(i) + parameters.m0/obj.N)*parameters.g;
        end
      obj.result.input = input;
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result.state;
      x = model.get(["p","Q","v","O","qi","wi","Qi","Oi"]);
      ref = obj.self.reference.result.state.xd;%Muid_6の想定：Xd = [x0d;dx0d;ddx0d;dddx0d;o0d;do0d]; % R0d は除いている
      xd = [ref(1:12);ref(22:27)];%Muid_6に合うように整頓ref=[x0d;dx0d;d2x0d;d3x0d;d4x0d;d5x0d;d6x0d;o0d;do0d;reshape(R0d,[],1)]
      qi = reshape(model.qi,3,obj.N);
      R0 = obj.toR(model.Q);
      R0d = reshape(ref(end-8:end),3,3);
      obj.result.mui = obj.gen_muid(x,qi,R0,R0d,xd,obj.gains,obj.P,obj.Pdagger);%[muid;mui]
      obj.result.Qeul = obj.Q2E(model.Q);%オイラー角を保存する用
      result = obj.result;
    end
  end
end