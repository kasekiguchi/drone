classdef MPC_CONTROLLER_HLMC_akanuma < handle
  % MCMPC_CONTROLLER MCMPCのコントローラー

  properties
    % obj.○○.△△のような構造体のパラメータ
    options % QP
    param
    current_state
    input
    state
    const
    reference
    fRemove
    model
    result
    self
  end
  properties
    % よく使うパラメータはobj.○○とする
    modelf
    modelp
    F1 % HLのなんかの項
    P % drone parameter
    N % 現時刻のパーティクル数
    H % horizon
    Weight % ステージコストの重みQ
    WeightF % 終端コストの重みQf
    WeightR % 入力抑制項の重み
    WeightRp % 前時刻入力との誤差項
    A % 制御モデルのA行列
    B % 制御モデルのB行列
    qpparam % 二次計画法QPのパラメータ
    previous_input % 前時刻入力
  end

  methods
    function obj = MPC_CONTROLLER_HLMC_akanuma(self, param)
      %-- 変数定義
      obj.self = self; % agent
      obj.param = param; % param = Controller_MPC_HLMC.mで設定したパラメーター
      n = 12; % 状態数
      obj.input = param.input; %入力関連のみ
      
      obj.F1 = lqrd([0 1;0 0],[0;1],diag([400,1]),0.1,param.dt); % 100
      obj.P = obj.self.parameter.get();
      obj.N = param.particle_num; 
      obj.H = param.H;
      
      % 重みの配列サイズ変換
      obj.Weight = repmat(blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI), 1, 1, obj.N);
      obj.WeightF = repmat(blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf), 1, 1, obj.N);
      obj.WeightR = repmat(obj.param.R,1,1,obj.N);  % 目標入力
      obj.WeightRp = repmat(obj.param.RP,1,1,obj.N); % 前ステップとの入力

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
      obj.input.Evaluationtra = zeros(obj.N, 5);
      obj.input.sigma = param.input.sigma;
      obj.input.mu = zeros(4, obj.param.H, obj.N);
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用

      % Initialize input
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      obj.input.U = zeros(self.estimator.model.dim(2),1);

      % Extended Coefficient Matrix ベクトル化
      obj.model = ExtendedCoefficientMatrix({sysd.A,sysd.B,param.H,param.state_size}); % 一括計算 2025/1/21確認
      obj.param.A = repmat(obj.model.A, 1, 1, obj.N);
      obj.param.B = repmat(obj.model.B, 1, 1, obj.N);

      % QP change equation
      % Q = reshape(obj.Weight(:,:,1), obj.param.state_size, []);
      % Qf = reshape(obj.WeightF(:,:,1), obj.param.state_size, []);
      % R = reshape(obj.WeightR(:,:,1), obj.param.input_size, []);
      % Param = struct('A',A,'B',B,'C',C,'weight',Q,'weightF',Qf,'weightR',R,'H',obj.param.H);
      % [obj.qpparam.H, obj.qpparam.F] = change_equation_HLMCMPC(Param);
    end

    %-- main()的な
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
            result = obj.controller_HL(varargin); % takeoff and landing -> HLC
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
        P = obj.P;
        F1 = obj.F1;
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

    function result = controller_HLMC(obj,varargin)
        tic
      obj.param.t = varargin{1}{1}.t; % 現在時刻
      obj.param.te = varargin{1}{1}.te; % 終了時間(default : 10s)

      %% ===プログラム作成部分開始======================================

      % -- 仮想状態の算出
      xd = obj.self.reference.result.state.xd; % 目標値の取得 referenceクラス
      xd=[xd;zeros(32-size(xd,1),1)]; % 足りない分は０で埋める．

      HLest = obj.self.estimator.result; % 現在地の取得 この後を考えて構造体のまま取り出す
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      xn = [R2q(Rb0'*HLest.state.getq("rotmat"));Rb0'*HLest.state.p;Rb0'*HLest.state.v;HLest.state.w]; % [q, p, v, w]に並べ替え
      % yawを考慮した目標値の算出
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      % 仮想状態の算出
      P = obj.self.parameter.get();
      vfn = Vf(xn,xd',P,obj.F1); %v1
      z1n = Z1(xn,xd',P);
      z2n = Z2(xn,xd',vfn,P);
      z3n = Z3(xn,xd',vfn,P);
      z4n = Z4(xn,xd',vfn,P);

      % 仮想状態の結合 Z, X, Y, YAW
      obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)]; % 目標値，実現在状態から仮想状態の算出

      % obj.state.ref = obj.generate_reference();

      % %-- 入力生成
      rng("shuffle");
      % mu = repmat(obj.input.u, 1, obj.param.H, obj.N); % 前の入力を平均値

      %- 使えるパラメータ: obj.input.input_TH, obj.H, obj.N, inputSigma, mu
      ksigma_max = 0.1 * obj.H;
      ksigma = 1:ksigma_max/(obj.H-1):1+ksigma_max; % 1~1+ksigma_maxまでH個の配列を作成
      inputSigma = ksigma .* obj.input.sigma';

      obj.input.u = randn(4,obj.H,obj.N) .* inputSigma + obj.input.mu; % 制約なし
      % obj.input.u = max(-obj.input.input_TH(:), min(obj.input.input_TH(:), randn(4,obj.H,obj.N) .* inputSigma + obj.input.mu));

      obj.predict(); % ココは変えない

      %% 実状態変換
      Xd = repmat(obj.state.ref(1:12,:), 1,1,obj.N);
      Xreal = Xd + obj.state.state_data; % + or -
      % obj.state.error_data = Xd - Xreal; % error_data = state_data   / default : -
      %現状ホライズンを考慮していない．obj.state.ref(:,1)との誤差になってしまっている気がする
      obj.state.real_data = Xreal;

      obj.objective();
      obj.input.EvalNorm = obj.normalize();
      obj.input.mu = obj.Resampling_IS(); % Resampling_LVS or Resampling_IS(obj)
      obj.get_input(xn, xd); % 最適入力の取得および標準偏差のリサンプリング

      %% 値の保存
      obj.result.input_v = obj.input.u; % input.v
      obj.result.bestcostID = obj.input.BestcostID;
      obj.result.bestcost = obj.input.Bestcost_now;
      % obj.result.contParam = obj.param;
      % obj.result.path = obj.state.real_data; % 実状態
      obj.result.sigma = obj.input.sigma;
      % obj.result.variable_N = obj.N;
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      % obj.result.xr = obj.state.ref;

      % obj.show();
      %%
      result = obj.result;
      toc
    end
    function show(obj)
        clc;
        est_print = obj.self.estimator.result.state;
        fprintf("==================================================================\n")
        fprintf("==================================================================\n")
        fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
            est_print.p(1), est_print.p(2), est_print.p(3),...
            est_print.v(1), est_print.v(2), est_print.v(3),...
            est_print.q(1)*180/pi, est_print.q(2)*180/pi, est_print.q(3)*180/pi); % s:state 現在状態
        fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
            obj.state.ref(3,1), obj.state.ref(7,1), obj.state.ref(1,1),...
            obj.state.ref(4,1), obj.state.ref(8,1), obj.state.ref(2,1),...
            0, 0, obj.state.ref(11,1)*180/pi)                             % r:reference 目標状態
        fprintf("t: %f \t input: %f %f %f %f", ...
            obj.param.t, obj.result.input(1), obj.result.input(2), obj.result.input(3), obj.result.input(4));
        fprintf("\n");
    end

    %% 状態予測
    function predict(obj)
        %-- 使えるパラメータ：obj.A, obj.B, obj.N, obj.H, obj.state.state_data, obj.current_state, obj.input.u
        x_0 = repmat(obj.current_state,1,1,obj.N);
        U = reshape(obj.input.u,[],1,obj.N);
        X = pagemtimes(obj.param.A,x_0)+pagemtimes(obj.param.B,U);
        obj.state.state_data = reshape(X,12,obj.H,[]);
    end

    function objective(obj)
        % obj.Weight:12*12*200, obj.WeightR:4*4*200
        u = obj.input.u; % 入力:4，ホライズン:10，サンプル:200
        x = obj.state.state_data; % 状態数:12，ホライズン:10，サンプル:200，状態（z, z', x, x',x'' ,x''' ,y ,y' ,y'' ,y''' ,yaw ,yaw'）

        %% ホライズンで重み大きく
        k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
        % k = ones(1, obj.param.H);

        %% コスト計算
        tildeUpre = u - obj.input.v;          % agent.input 　前時刻入力との誤差
        tildeUref = u - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

        %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
        %-- 入力
        stageInputPre  = k .* tildeUpre.*pagemtimes(obj.WeightR(:,:,1),tildeUpre);
        stageInputRef  = k .* tildeUref.*pagemtimes(obj.WeightRp(:,:,1),tildeUref);

        stageStateZ =    k .* x.*pagemtimes(obj.Weight(:,:,1),x);
        terminalState = 0;

        %% 人工ポテンシャル場法
        % Jconst = Constraints(obj);
        Jconst(:,1) = {zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N)};
        %% ステージコストとターミナルコストを合計
        stageStateZ = stageStateZ + terminalState;

        %-- 評価値計算 方向ごとに入力決定のために評価値を分けて保存
        obj.input.Evaluationtra(:,1) = reshape(sum(stageStateZ,[1,2]) + sum(stageInputPre,[1,2]) + sum(stageInputRef,[1,2]) + Jconst{1,1}, obj.N, 1);  % 全体の評価値
        obj.input.Evaluationtra(:,2) = reshape(sum(stageStateZ(1:2,:,:),  [1,2]) + Jconst{2,1}, obj.N, 1);   % Z
        obj.input.Evaluationtra(:,3) = reshape(sum(stageStateZ(3:6,:,:),  [1,2]) + Jconst{3,1}, obj.N, 1);   % X
        obj.input.Evaluationtra(:,4) = reshape(sum(stageStateZ(7:10,:,:), [1,2]) + Jconst{4,1}, obj.N, 1);   % Y
        obj.input.Evaluationtra(:,5) = reshape(sum(stageStateZ(11:12,:,:),[1,2]) + Jconst{5,1}, obj.N, 1);   % YAW
    end

    function [pw_new] = normalize(obj)
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

        resampling_u = repmat(reshape(reshape(sum(u.*reshape(pw,1,1,[]),2), 4,obj.N)...
            ./ sum(pw), 4, 1, NP), 1, H, 1);
    end

    function get_input(obj, xn, xd)
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        vf = obj.input.u(1, 1, BestcostID(2));
        vs(1,1) = obj.input.u(2, 1, BestcostID(3));
        vs(2,1) = obj.input.u(3, 1, BestcostID(4));
        vs(3,1) = obj.input.u(4, 1, BestcostID(5));

        P = obj.P;
        tmp = Uf(xn,xd',vf,P) + Us_GUI_mex(xn,xd',[vf,0,0],vs(:),P); % Us_GUIも17% 計算時間

        obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        obj.input.u = [vf; vs];
        obj.input.v = obj.input.u;

        obj.input.Bestcost_pre = obj.input.Bestcost_now;
        obj.input.Bestcost_now = Bestcost;

        obj.input.sigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))));
        obj.input.input_TH = max(obj.param.input.range(:,2), min(obj.param.input.range(:,1), obj.input.input_TH .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))'));
        obj.input.BestcostID = BestcostID;
    end

    %% 目標軌道生成
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
    end
  end
end
