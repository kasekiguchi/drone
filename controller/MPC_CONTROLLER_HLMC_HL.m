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
      current_state
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
        xd = [obj.state.ref(1:3,1); 0; obj.state.ref(7:9,1); 0]; % 9次多項式にも対応
        xd = [xd; zeros(24, 1)];

        model_HL = obj.self.estimator.result;
        Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
        xn = [R2q(Rb0'*model_HL.state.getq("rotmat"));Rb0'*model_HL.state.p;Rb0'*model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え
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
        obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)];

        obj.reference.xd_imagine = [obj.state.ref(1:3,:); zeros(1,obj.param.H); obj.state.ref(7:9,:); zeros(1,obj.param.H); obj.state.ref(17:19,:); zeros(21, obj.param.H)]; % 実状態目標値=Rb0をかけるために合わせる
        xr_imagine(1:3,:)=Rb0'*obj.reference.xd_imagine(1:3,:); xr_imagine(4,:) = zeros(1,obj.param.H);
        xr_imagine(5:7,:)=Rb0'*obj.reference.xd_imagine(5:7,:); xr_imagine(9:11,:)=Rb0'*obj.reference.xd_imagine(9:11,:);
        xr_imagine(13:15,:)=Rb0'*obj.reference.xd_imagine(13:15,:); xr_imagine(17:19,:)=Rb0'*obj.reference.xd_imagine(17:19,:);
        % 仮想状態の目標値
        obj.reference.xr_org = [xr_imagine(3,:);xr_imagine(7,:);xr_imagine(1,:);xr_imagine(5,:);xr_imagine(9,:);xr_imagine(13,:);xr_imagine(2,:);xr_imagine(6,:);xr_imagine(10,:);xr_imagine(14,:);xr_imagine(4,:);xr_imagine(8,:)];
        % 仮想状態の目標値。Objectiveで使用。　現在地から目標値（座標）への誤差
        obj.reference.xr = obj.reference.xr_org(:,1) - obj.reference.xr_org;

        %% input
        mu = obj.input.Resampling_mu; % Importance Sampling / Low Variance Sampling
        % mu = repmat(obj.input.u, 1, obj.param.H, obj.N); % 前の入力を平均値
        % 標準偏差，サンプル数の更新
        obj.input.sigma = obj.input.nextsigma;
        obj.N = obj.param.nextparticle_num;
        % ホライズンにかけて分散大きく
        ksigma_max = 0.1 * obj.param.H;
        ksigma = linspace(1,1+ksigma_max,obj.param.H);
        inputSigma = ksigma .* obj.input.sigma';
        obj.input.u1 = max(-obj.input.input_TH, min(obj.input.input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(1)) + reshape(mu(1,:,:), obj.param.H, obj.N)));
        obj.input.u2 = max(-obj.input.input_TH, min(obj.input.input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(2)) + reshape(mu(2,:,:), obj.param.H, obj.N)));
        obj.input.u3 = max(-obj.input.input_TH, min(obj.input.input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(3)) + reshape(mu(3,:,:), obj.param.H, obj.N)));
        obj.input.u4 = max(-obj.input.input_TH, min(obj.input.input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(4)) + reshape(mu(4,:,:), obj.param.H, obj.N)));
        % reshape
        obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;
        obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
        obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
        obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

        %% -- 状態予測
        obj.predict_gpu();

        % 実状態変換
        Xd = repmat(obj.reference.xr_org, 1,1,obj.N);
        Xreal = Xd + obj.state.state_data; % + or -
        obj.state.error_data = Xd - Xreal;
        obj.state.real_data = Xreal;

        %% -- 評価値計算
        obj.input.Evaluationtra =  obj.objective();
        % obj.input.Evaluationtra = objective(Objobj);

        % 評価値の正規化
        obj.input.EvalNorm = obj.Normalize();

        %% -- 平均のリサンプリング
        [obj.input.Resampling_mu, ~] = obj.Resampling_LVS(); % LowVarianceSampling
        % [obj.input.Resampling_mu, ~] = obj.Resampling_IS(); % ImportanceSampling

        %% -- 制約条件
        removeF = 0; removeX = []; survive = obj.N;

        %% -- 入力取得
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        vf = obj.input.u(1, 1, BestcostID(2));           % 最適な入力の取得
        vs(1,1) = obj.input.u(2, 1, BestcostID(3));      % こちらは確実に飛ぶが良くない
        vs(2,1) = obj.input.u(3, 1, BestcostID(4));      % 時間延ばすと収束・高速な軌道だと追いつかない
        vs(3,1) = obj.input.u(4, 1, BestcostID(5));      % 2,3,4,5 だと個別の評価値に対する入力

        tmp = Uf(xn,xd',vf,P) + Us_GUI_mex(xn,xd',[vf,0,0],vs(:),P);

        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4)];
        obj.input.u = [vf; vs];

        %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，
        %   評価が良くなったら標準偏差を狭めるようにしている
        obj.input.Bestcost_pre = obj.input.Bestcost_now;
        obj.input.Bestcost_now = Bestcost;

        obj.result.removeF = removeF;
        obj.result.removeX = removeX;
        obj.result.survive = survive;
        obj.result.input_v = obj.input.u; % input.v
        obj.result.bestcostID = BestcostID;
        obj.result.bestcost = Bestcost;
        obj.result.contParam = obj.param;
        obj.result.fRemove = obj.param.fRemove;
        obj.result.path = obj.state.real_data; % 実状態
        obj.result.sigma = obj.input.sigma;
        obj.result.Evaluationtra = obj.input.Evaluationtra;
        obj.result.xr = obj.state.ref;

        result = obj.result;
    end

    function predict_gpu(obj)
      obj.state.state_data(:,1,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % サンプル数分初期値を作成
      for i = 1:obj.param.H-1
        obj.state.state_data(:,i+1,1:obj.N) = pagemtimes(obj.A(:,:,1:obj.N),obj.state.state_data(:,i,1:obj.N)) + pagemtimes(obj.B(:,:,1:obj.N),obj.input.u(:,i,1:obj.N));
      end
    end

    function [MCeval] = objective(obj, ~)   % obj.~とする
      U = obj.input.u(:,:,1:obj.N);                % 4  * 10 * N
      removeX = [];
      AP = [];
      %% 実状態との誤差
      Z = obj.state.error_data;
        
      %% ホライズンで重み大きく
      k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
      % k = ones(1, obj.param.H);

      %% コスト計算
      tildeUpre = U - obj.input.v;          % agent.input 　前時刻入力との誤差
      tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

      %% 制約外の軌道に対して値を付加
      % [~, removeX, ~] = obj.constraints();

      %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      %-- 入力
      stageInputPre  = k .* tildeUpre.*pagemtimes(obj.weight.R(:,:,1:obj.N),tildeUpre);
      stageInputRef  = k .* tildeUref.*pagemtimes(obj.weight.Rp(:,:,1:obj.N),tildeUref);

      stageStateZ =    k .* Z.*pagemtimes(obj.weight.Q(:,:,1:obj.N),Z);
      terminalState = 0;

      %% ステージコストとターミナルコストを合計
      stageStateZ = stageStateZ + terminalState;
      %% 軌道ごとに制約を評価
      if ~isempty(removeX)
          % stageStateZ(3:6, removeX) = stageStateZ(3:6, removeX) + obj.param.ConstEval;
          % stageStateZ(7:10, removeX) = stageStateZ(7:10, removeX) + obj.param.ConstEval;
          stageStateZ(1:2, removeX) = stageStateZ(1:2, removeX) + obj.param.ConstEval;
      end

      %% 人工ポテンシャルをx, yにプラス
      if ~isempty(AP)
          stageStateZ(3, :,:) = stageStateZ(3, :,:) + AP;% + AP2;
          stageStateZ(7, :,:) = stageStateZ(7, :,:) + AP;% + AP2;
      end

      %-- 評価値計算 方向ごとに入力決定のために評価値を分けて保存
      Eval{1} = sum(stageStateZ,[1,2]) + sum(stageInputPre,[1,2]) + sum(stageInputRef,[1,2]);  % 全体の評価値
      Eval{2} = sum(stageStateZ(1:2,:,:),  [1,2]);   % Z
      Eval{3} = sum(stageStateZ(3:6,:,:),  [1,2]);   % X
      Eval{4} = sum(stageStateZ(7:10,:,:), [1,2]);   % Y
      Eval{5} = sum(stageStateZ(11:12,:,:),[1,2]);   % YAW

      %-- 評価値をreshapeして縦ベクトルに変換
      MCeval(:,1) = reshape(Eval{1}, obj.N, 1);
      MCeval(:,2) = reshape(Eval{2}, obj.N, 1);
      MCeval(:,3) = reshape(Eval{3}, obj.N, 1);
      MCeval(:,4) = reshape(Eval{4}, obj.N, 1);
      MCeval(:,5) = reshape(Eval{5}, obj.N, 1);
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
        H = obj.H;
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

