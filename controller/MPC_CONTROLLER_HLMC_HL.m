classdef MPC_CONTROLLER_HLMC_HL < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];

    % options
    current_state
    input
    state
    const
    reference
    fRemove
    model
  end

  properties
    modelf
    modelp
    F1
    N % 現時刻のパーティクル数
    Weight
    WeightF
    WeightR
    WeightRp
    WeightConst
    A
    B
    qpparam
    previous_input
  end

  methods
      function obj = MPC_CONTROLLER_HLMC_HL(self, param)
      %-- 変数定義
      obj.self = self; % agent
      obj.param = param; % param = Controller_MPC_HLMC.mで設定したパラメーター
      n = 12; % 状態数
      obj.input = param.input; %入力関連のみ
      
      % obj.F1 = lqrd([0 1;0 0],[0;1],diag([400,1]),0.1,param.dt); % 100
      obj.F1 = param.F1;
      obj.N = param.particle_num; 
      obj.param.P = self.parameter.get(obj.parameter_name);
      
      % 重みの配列サイズ変換
      obj.Weight = repmat(blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI), 1, 1, obj.N);
      obj.WeightF = repmat(blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf), 1, 1, obj.N);
      obj.WeightR = repmat(obj.param.R,1,1,obj.N);  % 目標入力
      obj.WeightRp = repmat(obj.param.RP,1,1,obj.N); % 前ステップとの入力
      obj.WeightConst = repmat(obj.param.AP,1,1,obj.N);

      % HL. A, B行列定義 z, x, y, yawの順番
      A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
      B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
      C = eye(size(A,1));
      sysd = c2d(ss(A,B,eye(12),0),obj.param.dt); % 離散化
      obj.A = repmat(sysd.A,1,1,obj.N); % サンプル分同時に計算のためobj.N分のA行列を用意
      obj.B = repmat(sysd.B,1,1,obj.N);

      % Initialize parameter
      obj.result.bestx(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.besty(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.bestz(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.state.state_data = zeros(n,obj.param.H, obj.N);
      obj.input.Evaluationtra = zeros(1, obj.N);
      obj.input.sigma = param.input.sigma;
      obj.input.mu = zeros(4, obj.param.H, obj.N);
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用

      % Initialize input
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      obj.input.U = zeros(self.estimator.model.dim(2),1);

      % Extended Coefficient Matrix ベクトル化
      obj.model = ExtendedCoefficientMatrix({sysd.A,sysd.B,param.H,param.state_size});
      obj.param.A = repmat(obj.model.A, 1, 1, obj.N);
      obj.param.B = repmat(obj.model.B, 1, 1, obj.N);

      % QP change equation
      Q = reshape(obj.Weight(:,:,1), obj.param.state_size, []);
      Qf = reshape(obj.WeightF(:,:,1), obj.param.state_size, []);
      R = reshape(obj.WeightR(:,:,1), obj.param.input_size, []);
      Param = struct('A',A,'B',B,'C',C,'weight',Q,'weightF',Qf,'weightR',R,'H',obj.param.H);
      [obj.qpparam.H, obj.qpparam.F] = change_equation_HLMCMPC(Param);
    end

    function result = do(obj,varargin)
        tic
        %%initialize
        time = varargin{1};
        phase = varargin{2};
        obj.param.t = time.t;
        %% phaseによるcontrollerの選択
        % result: controllerで算出された入力
        if phase == 'a'
            obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input;0;0;0],1,obj.param.H);
            result = obj.controller_HLMC(varargin);
            disp('controller: MC,  phase: a');
        elseif phase == 't' || phase == 'l'
            result = obj.controller_HL(varargin);
            disp('controller: HL  phase: t or l');
        elseif phase == 'f'
            obj.state.ref = obj.generate_reference();
            result = obj.controller_HLMC(varargin);
            disp('controller: MC  phase: f');
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
        % tic
      obj.param.t = varargin{1}{1}.t; % 現在時刻
      obj.param.te = varargin{1}{1}.te; % 終了時間(default : 10s)

      xd = obj.self.reference.result.state.xd;
      xd=[xd;zeros(32-size(xd,1),1)];% 足りない分は０で埋める．

      HLest = obj.self.estimator.result;
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      xn = [R2q(Rb0'*HLest.state.getq("rotmat"));Rb0'*HLest.state.p;Rb0'*HLest.state.v;HLest.state.w]; % [q, p, v, w]に並べ替え
      
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      P = obj.self.parameter.get();
      vfn = Vf(xn,xd',P,obj.F1); %v1
      z1n = Z1(xn,xd',P);
      z2n = Z2(xn,xd',vfn,P);
      z3n = Z3(xn,xd',vfn,P);
      z4n = Z4(xn,xd',vfn,P);

      obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)]; % 目標値，実現在状態から仮想状態の算出

      %% Referenceの取得、ホライズンごと
      % 現在地から目標値（座標）への誤差
      act = HLest.state.get(); % 実状態目標値
      img = [act(3); act(9); act(1); act(7); 0;0; act(2); act(8); 0;0; act(6); act(12)]; %仮想状態列
      obj.reference.xrd = img - obj.state.ref(1:12,:);

      mu = obj.input.mu; % Importance Sampling / Low Variance Sampling
      % mu = repmat(obj.input.u, 1, obj.param.H, obj.N); % 前の入力を平均値

      rng("shuffle");
      %% ホライズンにかけて分散大きく
      ksigma_max = 0.1 * obj.param.H;
      ksigma = linspace(1,1+ksigma_max,obj.param.H);
      inputSigma = ksigma .* obj.input.sigma';
      % inputSigma = obj.input.sigma;

      obj.input.u = randn(4,obj.param.H,obj.N) .* inputSigma + mu;
      obj.input.u = max(-obj.input.input_TH, min(obj.input.input_TH, randn(4,obj.param.H,obj.N) .* inputSigma + mu));

      % obj.input.u1 = max(-obj.input.input_TH(1), min(obj.input.input_TH(1), normrnd(zeros(obj.param.H,obj.N), inputSigma(1)) + reshape(mu(1,:,:), obj.param.H, obj.N)));
      % obj.input.u2 = max(-obj.input.input_TH(2), min(obj.input.input_TH(2), normrnd(zeros(obj.param.H,obj.N), inputSigma(2)) + reshape(mu(2,:,:), obj.param.H, obj.N)));
      % obj.input.u3 = max(-obj.input.input_TH(3), min(obj.input.input_TH(3), normrnd(zeros(obj.param.H,obj.N), inputSigma(3)) + reshape(mu(3,:,:), obj.param.H, obj.N)));
      % obj.input.u4 = max(-obj.input.input_TH(4), min(obj.input.input_TH(4), normrnd(zeros(obj.param.H,obj.N), inputSigma(4)) + reshape(mu(4,:,:), obj.param.H, obj.N)));
      % 
      % obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
      % obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
      % obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
      % obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

      obj.predict();

      %% 実状態変換
      Xd = repmat(obj.state.ref(1:12,:), 1,1,obj.N);
      Xreal = Xd + obj.state.state_data; % + or -
      obj.state.error_data = Xd - Xreal; % error_data = state_data   / default : -
      %現状ホライズンを考慮していない．obj.state.ref(:,1)との誤差になってしまっている気がする
      obj.state.real_data = Xreal;

      %-- 評価値計算 
      obj.input.Evaluationtra = obj.objective();

      % 評価値の正規化
      obj.input.EvalNorm = obj.Normalize();

      % 平均のリサンプリング
      [obj.input.mu, ~] = obj.Resampling_LVS(); % LowVarianceSampling
      % [obj.input.Resampling_mu, ~] = obj.Resampling_IS(); % ImportanceSampling

      [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
      vf = obj.input.u(1, 1, BestcostID(2));           
      vs(1,1) = obj.input.u(2, 1, BestcostID(3));      
      vs(2,1) = obj.input.u(3, 1, BestcostID(4));      
      vs(3,1) = obj.input.u(4, 1, BestcostID(5));    

      tmp = Uf(xn,xd',vf,P) + Us_GUI_mex(xn,xd',[vf,0,0],vs(:),P); % Us_GUIも17% 計算時間

      obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      obj.input.u = [vf; vs];
      obj.input.v = obj.input.u;

      obj.input.Bestcost_pre = obj.input.Bestcost_now;
      obj.input.Bestcost_now = Bestcost;

      obj.input.sigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))));
      obj.input.input_TH = max(obj.param.input.range(:,2), min(obj.param.input.range(:,1), obj.input.input_TH .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))'));

      %% save value
      obj.result.input_v = obj.input.u; % input.v
      obj.result.BestcostID = BestcostID;
      obj.result.bestcost = Bestcost;
      obj.result.contParam = obj.param;
      obj.result.path = obj.state.real_data; % 実状態
      obj.result.sigma = obj.input.sigma;
      obj.result.variable_N = obj.N; % 追加
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      obj.result.xr = obj.state.ref;

      %%
      result = obj.result;
      % profile viewer
      % toc
    end
    function show(obj)
        obj.result
    end

    %%-- 離散：階層型線形化
    function predict(obj)
      obj.state.state_data = pagemtimes(obj.param.A, obj.current_state) + pagemtimes(obj.param.B, reshape(obj.input.u, [], 1, obj.N)); % 予測計算 12*Hx1xN
      obj.state.state_data = [repmat(obj.current_state,1,1,obj.N), reshape(obj.state.state_data(1:end-obj.param.state_size,:,:), obj.param.state_size, [], obj.N)];
    end

    function [MCeval] = objective(obj, ~)   % obj.~とする
      U = obj.input.u(:,:,1:obj.N);                % 4  * 10 * N
      Z = obj.state.error_data;
        
      %% ホライズンで重み大きく
      k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
      % k = ones(1, obj.param.H);

      %% コスト計算
      tildeUpre = U - obj.input.v;          % agent.input 　前時刻入力との誤差
      tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

      %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      %-- 入力
      stageInputPre  = k .* tildeUpre.*pagemtimes(obj.WeightR(:,:,1:obj.N),tildeUpre);
      stageInputRef  = k .* tildeUref.*pagemtimes(obj.WeightRp(:,:,1:obj.N),tildeUref);

      stageStateZ =    k .* Z.*pagemtimes(obj.Weight(:,:,1:obj.N),Z);
      terminalState = 0;

      %% 人工ポテンシャル場法
      % Jconst = Constraints(obj);
      Jconst(:,1) = {zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N)};
      %% ステージコストとターミナルコストを合計
      stageStateZ = stageStateZ + terminalState;

      %-- 評価値計算 方向ごとに入力決定のために評価値を分けて保存
      Eval{1} = sum(stageStateZ,[1,2]) + sum(stageInputPre,[1,2]) + sum(stageInputRef,[1,2]) + Jconst{1,1};  % 全体の評価値
      Eval{2} = sum(stageStateZ(1:2,:,:),  [1,2]) + Jconst{2,1};   % Z
      Eval{3} = sum(stageStateZ(3:6,:,:),  [1,2]) + Jconst{3,1};   % X
      Eval{4} = sum(stageStateZ(7:10,:,:), [1,2]) + Jconst{4,1};   % Y
      Eval{5} = sum(stageStateZ(11:12,:,:),[1,2]) + Jconst{5,1};   % YAW

      %-- 評価値をreshapeして縦ベクトルに変換
      MCeval = reshape(cell2mat(Eval), 5, obj.N)';
    end

    function Jconst = Constraints(obj)
        Jconst = 0;
    end

    function [pw_new] = Normalize(obj)
      NP = obj.N;
      pw = obj.input.Evaluationtra(:,1); % 全評価値に対してのほうが性能よさそう

      pw = exp(-pw);
      sumw = sum(pw);
      if sumw~=0
        pw = (pw/sum(pw))';%正規化
      else
        pw = zeros(1,NP)+1/NP;
      end
      pw_new = pw;
    end

    function [resampling_u,pw] = Resampling_LVS(obj)
        %RESAMPLING この関数の概要をここに記述
        % アルゴリズムはLow Variance Sampling
        NP = obj.N;   % サンプル数
        pw = obj.input.EvalNorm; % 正規化された評価値
        u1 = reshape(obj.input.u(1,:,:), [], NP); 
        u2 = reshape(obj.input.u(2,:,:), [], NP); 
        u3 = reshape(obj.input.u(3,:,:), [], NP); 
        u4 = reshape(obj.input.u(4,:,:), [], NP); 
        wcum=cumsum(pw); % 評価値を累積
        base=cumsum(pw*0+1/NP)-1/NP;%乱数を加える前のbase
        resampleID=base+rand/NP;%ルーレットを乱数分増やす
        pu1 = u1;%データ格納用
        pu2 = u2;
        pu3 = u3;
        pu4 = u4;
        ind=1;%新しいID
        for ip=1:NP
            while(resampleID(ip)>wcum(ind))
                ind=ind+1;
            end
            u1(1:end,ip)= [pu1(2:end,ind);pu1(end,ind)];%LVSで選ばれたパーティクルに置き換え
            u2(1:end,ip)= [pu2(2:end,ind);pu2(end,ind)];
            u3(1:end,ip)= [pu3(2:end,ind);pu3(end,ind)];
            u4(1:end,ip)= [pu4(2:end,ind);pu4(end,ind)];
            pw(ip)=1/NP;%尤度は初期化
        end
        resampling_u(4, 1:obj.param.H, 1:obj.N) = u4;
        resampling_u(3, 1:obj.param.H, 1:obj.N) = u3;
        resampling_u(2, 1:obj.param.H, 1:obj.N) = u2;
        resampling_u(1, 1:obj.param.H, 1:obj.N) = u1;
    end

    function [resampling_u, pw] = Resampling_IS(obj)
        % 重点サンプリング
        NP = obj.N;
        pw = obj.input.EvalNorm; % 正規化された評価値
        H = obj.param.H;
        u = obj.input.u;
        resampling_u = zeros(4, H, NP);
        u1 = reshape(u(1,:,:), [], NP); 
        u2 = reshape(u(2,:,:), [], NP); 
        u3 = reshape(u(3,:,:), [], NP); 
        u4 = reshape(u(4,:,:), [], NP); 
        sumu1w = sum(u1.*pw);
        sumu2w = sum(u2.*pw);
        sumu3w = sum(u3.*pw);
        sumu4w = sum(u4.*pw);
        sumw = sum(pw);
        u1 = repmat(sumu1w ./ sumw, H, 1);
        u2 = repmat(sumu2w ./ sumw, H, 1);
        u3 = repmat(sumu3w ./ sumw, H, 1);
        u4 = repmat(sumu4w ./ sumw, H, 1);
        resampling_u(4, 1:H, 1:NP) = u4;
        resampling_u(3, 1:H, 1:NP) = u3;
        resampling_u(2, 1:H, 1:NP) = u2;
        resampling_u(1, 1:H, 1:NP) = u1;
    end

    function [xr] = generate_reference(obj)
        xr = zeros(16, obj.param.H);    % initialize
        % 時間関数の取得→時間を代入してリファレンス生成
        RefTime = obj.self.reference.func;    % 時間関数の取得
        for h = 0:obj.param.H-1
            t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
            r = RefTime(t);
            xr(1:12,h+1) = [r(3);r(7);r(1);r(5);r(9);r(13);r(2);r(6);r(10);r(14);r(4);r(8)];
            xr(13:16,h+1)= obj.param.ref_input;
        end
        % 3 7 1 5 9 13 2 6 10 14 4 8
    end
  end
end

