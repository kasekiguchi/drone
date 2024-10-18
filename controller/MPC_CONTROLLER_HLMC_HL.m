classdef MPC_CONTROLLER_HLMC_HL < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
  end

  properties
      input
      model
      state
      reference
      N
      H
      weight
      A
      B
  end

  methods
    function obj = MPC_CONTROLLER_HLMC_HL(self,param)
      obj.self = self;
      obj.param = param;
      obj.param.P = self.parameter.get(obj.parameter_name);

      %% HLMCMPC
      obj.input = param.input;
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
      obj.input.input_TH = param.input.range; % 最大最小入力
      obj.param.fRemove = 0;
      obj.input.AllRemove = 0; % 全棄却フラグ
      obj.input.nextsigma = param.input.Initsigma;  % 初期化
      obj.param.nextparticle_num = param.Maxparticle_num;   % 初期化
      obj.input.Bestcost_now = [1e1, 1e-5, 1e-5, 1e-5, 1e-5];% 初期周期での比較用
      %% HL
      % obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,obj.param.dt);
      obj.N = param.particle_num;
      obj.H = param.H;
      n = 12; % 状態数
      obj.state.state_data = zeros(n,obj.param.H, obj.N);
      obj.input.Evaluationtra = zeros(1, obj.N);
      % 重みの配列サイズ変換
      obj.weight.Q = repmat(blkdiag(param.Z, param.X, param.Y, param.PHI), 1, 1, obj.N);
      obj.weight.Qf = repmat(blkdiag(param.Zf, param.Xf, param.Yf, param.PHIf), 1, 1, obj.N);
      obj.weight.R = repmat(param.R,1,1,obj.N);  % 目標入力
      obj.weight.Rp = repmat(param.RP,1,1,obj.N); % 前ステップとの入力
      % HL. A, B行列定義
      % z, x, y, yawの順番
      A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
      B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
      sysd = c2d(ss(A,B,eye(12),0),param.dt); % 離散化
      obj.A = repmat(sysd.A,1,1,obj.N); % サンプル分同時に計算のためobj.N分のA行列を用意
      obj.B = repmat(sysd.B,1,1,obj.N);

      obj.result.bestx(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.besty(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.bestz(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ

      obj.input.Resampling_mu = zeros(4, param.H, obj.N);
      obj.reference.polynomial = obj.param.reference.polynomial;

      % Initialize input
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
        tic
        %%initialize
        time = varargin{1};
        phase = varargin{2};
        %% phaseによるcontrollerの選択
        % result: controllerで算出された入力
        if phase == 'a'
            obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input;0;0;0],1,obj.param.H);
            result = obj.controller_HLMC(varargin);
            disp('controller: MC');
        elseif phase == 't' || phase == 'l'
            result = obj.controller_HL(varargin);
            disp('controller: HL');
        elseif phase == 'f'
            obj.state.ref = obj.generate_reference();
            result = obj.controller_HLMC(varargin);
            disp('controller: MC');
        end 
        toc
    end
    
    function result = controller_HL(obj,varargin)
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
        result = obj.result;
    end

    function result = controller_HLMC(obj, varargin)
        result = 1;
    end

    function [xr] = generate_reference(obj)
        xr = zeros(19, obj.param.H);    % initialize
        % 時間関数の取得→時間を代入してリファレンス生成
        RefTime = obj.self.reference.func;    % 時間関数の取得
        for h = 0:obj.param.H-1
            t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
            ref = RefTime(t);
            xr(1:3, h+1) = ref(1:3);
            xr(7:9, h+1) = ref(5:7);
            xr(17:19, h+1) = ref(9:11);
            xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            xr(10:12, h+1) = [0;0;0];
            xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            xr(17:19, h+1) = [0;0;0];
        end
    end
  end
end

