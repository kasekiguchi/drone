classdef HLMCMPC_controller <CONTROLLER_CLASS
  % MCMPC_CONTROLLER MCMPCのコントローラー

  properties
    options
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
    modelf
    modelp
    F1
    N % 現時刻のパーティクル数
    Weight
    WeightF
    WeightR
    WeightRp
    A
    B
  end

  methods
    function obj = HLMCMPC_controller(self, param)
      %-- 変数定義
      obj.self = self;
      %---MPCパラメータ設定---%
      obj.param = param;
      % obj.modelf = obj.self.model.method;
      obj.modelp = obj.self.parameter.get();
      %%  
      obj.input = param.input;
      obj.const = param.const;
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
      % obj.model = self.model;
      obj.param.fRemove = 0;
      obj.input.AllRemove = 0; % 全棄却フラグ
      obj.input.nextsigma = param.input.Initsigma;  % 初期化
      obj.param.nextparticle_num = param.Maxparticle_num;   % 初期化
      obj.input.Bestcost_now = [1e1, 1e-5, 1e-5, 1e-5, 1e-5];% 十分大きい値にする  初期周期での比較用
      %% HL
      obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.dt);
      obj.N = param.particle_num;
      n = 12; % 状態数
      obj.state.state_data = zeros(n,obj.param.H, obj.N);
      obj.input.Evaluationtra = zeros(1, obj.N);
      % 重みの配列サイズ変換
      obj.Weight = repmat(blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI), 1, 1, obj.N);
      obj.WeightF = repmat(blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf), 1, 1, obj.N);
      obj.WeightR = repmat(obj.param.R,1,1,obj.N);  % 目標入力
      obj.WeightRp = repmat(obj.param.RP,1,1,obj.N); % 前ステップとの入力
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

      [obj.param.expand_A, obj.param.expand_B] = EXPAND_STATE(obj);

      obj.input.Resampling_mu = zeros(4, obj.param.H, obj.N);
    end

    %-- main()的な
    function result = do(obj,param)
      % rng(0, "twister");
      % profile on
      % OB = obj;
      xr = param{2};
      rt = param{3};
%       obj.input.InputV = param{5};
      obj.state.ref = xr;
      obj.param.t = rt;
      % idx = round(rt/obj.self.model.dt+1);

      %% from main ref
      xd = [xr(1:3,1); 0; xr(7:9,1); 0]; % 9次多項式にも対応
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
      P = obj.modelp;
      vfn = Vf(xn,xd',P,obj.F1); %v1
      z1n = Z1(xn,xd',P);
      z2n = Z2(xn,xd',vfn,P);
      z3n = Z3(xn,xd',vfn,P);
      z4n = Z4(xn,xd',vfn,P);
      obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)]; 
      % -------------------------------------------------------------------------------------------------------------------------------------
      %% Referenceの取得、ホライズンごと
      % xrを仮想状態目標値に変換 ホライズン分の変換
      % xyz yaw v_{xyz yaw} a_{xyz yaw}
      obj.reference.xd_imagine = [xr(1:3,:); zeros(1,obj.param.H); xr(7:9,:); zeros(1,obj.param.H);zeros(24, obj.param.H)]; % 実状態を仮想状態に合わせた形で抜き取る
      % xr_imagine = 
      % yaw入力時にHL用に目標値が切り替わるように　Rb0をかけるようにする
      xr_imagine(1:3,:)=Rb0'*obj.reference.xd_imagine(1:3,:);
      xr_imagine(4,:) = zeros(1,obj.param.H);
      xr_imagine(5:7,:)=Rb0'*obj.reference.xd_imagine(5:7,:);
      xr_imagine(9:11,:)=Rb0'*obj.reference.xd_imagine(9:11,:);
      xr_imagine(13:15,:)=Rb0'*obj.reference.xd_imagine(13:15,:);
      xr_imagine(17:19,:)=Rb0'*obj.reference.xd_imagine(17:19,:);
      obj.reference.xr_org = [xr_imagine(3,:);xr_imagine(7,:);xr_imagine(1,:);xr_imagine(5,:);xr_imagine(9,:);xr_imagine(13,:);xr_imagine(2,:);xr_imagine(6,:);xr_imagine(10,:);xr_imagine(14,:);xr_imagine(4,:);xr_imagine(8,:)];
      obj.reference.xr = obj.reference.xr_org(:,1) - obj.reference.xr_org; 

      % mu = zeros(4, obj.param.H, obj.N); % トルク入力モデルだと基本は0であってほしいことから平均値を0に固定
      mu = obj.input.Resampling_mu; % Importance Sampling / Low Variance Sampling

      % 標準偏差，サンプル数の更新
      obj.input.sigma = obj.input.nextsigma;
      obj.N = obj.param.nextparticle_num;
      input_TH = obj.param.input.range; % 最大最小入力

      % 全棄却時のケア
      if obj.input.AllRemove == 1
        mu = obj.param.ref_input;
        obj.input.sigma = obj.input.Constsigma;
        obj.input.AllRemove = 0;
      end

      %% ホライズンにかけて分散大きく
      ksigma_max = 0.01 * obj.param.H;
      ksigma = linspace(1,1 + ksigma_max,obj.param.H);
      inputSigma = ksigma .* obj.input.sigma';
      obj.input.u1 = max(-input_TH, min(input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(1)) + reshape(mu(1,:,:), obj.param.H, obj.N)));
      obj.input.u2 = max(-input_TH, min(input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(2)) + reshape(mu(2,:,:), obj.param.H, obj.N)));
      obj.input.u3 = max(-input_TH, min(input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(3)) + reshape(mu(3,:,:), obj.param.H, obj.N)));
      obj.input.u4 = max(-input_TH, min(input_TH, normrnd(zeros(obj.param.H,obj.N), inputSigma(4)) + reshape(mu(4,:,:), obj.param.H, obj.N)));

      %% 正規分布ふつう
      % obj.input.u1 = max(-input_TH, min(input_TH, obj.input.sigma(1).*randn(obj.param.H, obj.N) + mu(1,1,1))); 
      % obj.input.u2 = max(-input_TH, min(input_TH, obj.input.sigma(2).*randn(obj.param.H, obj.N) + mu(2,1,1))); 
      % obj.input.u3 = max(-input_TH, min(input_TH, obj.input.sigma(3).*randn(obj.param.H, obj.N) + mu(3,1,1))); 
      % obj.input.u4 = max(-input_TH, min(input_TH, obj.input.sigma(4).*randn(obj.param.H, obj.N) + mu(4,1,1))); 

      obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

      %% ベクトル化　4*H*N -> 4H * N
      % obj.input.u_vec = reshape(obj.input.u, [4*obj.param.H, obj.N]);

      %% 目標値-仮想入力　関係
      % input = 83.46 * ref - 2.92

      %-- 状態予測　mex化　準備
      % Objpredict.H = obj.param.H;
      % Objpredict.N = obj.N; Objpredict.A = obj.A; Objpredict.B = obj.B;
      % Objpredict.input = obj.input.u; Objpredict.current_state = obj.current_state;
      % Objpredict.state = obj.state.state_data; 
      % [obj.state.state_data] = predict(Objpredict);
      % [obj.state.state_data] = predict_mex(Objpredict); % N=5000のみ対応

      [obj.state.state_data] = predict_gpu(obj.input.u, obj.state.state_data, obj.current_state, obj.N, obj.param.H, obj.A, obj.B);
      % [obj.state.state_data] = obj.predict();

      %% 実状態変換
      Xd = repmat(obj.reference.xr_org, 1,1,obj.N);
      Xreal = Xd + obj.state.state_data; % + or -
      obj.state.error_data = Xd - Xreal;
      obj.state.real_data = Xreal;

      %-- 評価値計算 
      obj.input.Evaluationtra =  obj.objective();
      % obj.input.Evaluationtra = objective(Objobj);  

      % 評価値の正規化
      obj.input.EvalNorm = obj.Normalize();

      % 平均のリサンプリング

      % [obj.input.Resampling_mu, ~] = obj.Resampling_LVS(); % LowVarianceSampling
      [obj.input.Resampling_mu, ~] = Resampling_IS_mex(obj.N, obj.param.H, obj.input.EvalNorm, obj.input.u); % ImportanceSampling

      %-- 制約条件
      removeF = 0; removeX = []; survive = obj.N;
      % [removeF, removeX, survive] = obj.constraints();
      obj.state.COG.g = 0; obj.state.COG.gc = 0;
        
      
      if removeF ~= obj.N
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        % トルク入力にしたらそれぞれの最適入力をとる必要あり？
        vf = obj.input.u(1, 1, BestcostID(2));           % 最適な入力の取得
        vs(1,1) = obj.input.u(2, 1, BestcostID(3));      % こちらは確実に飛ぶが良くない
        vs(2,1) = obj.input.u(3, 1, BestcostID(4));      % 時間延ばすと収束・高速な軌道だと追いつかない
        vs(3,1) = obj.input.u(4, 1, BestcostID(5));      % 2,3,4,5 だと個別の評価値に対する入力
        % 
        % input_ind = BestcostID(1); % 
        % vf      = obj.input.u(1, 1, input_ind);     
        % vs(1,1) = obj.input.u(2, 1, input_ind);     
        % vs(2,1) = obj.input.u(3, 1, input_ind);
        % vs(3,1) = obj.input.u(4, 1, input_ind); 

        % vs = vs';
        % GUI共通プログラムから トルク入力の変換のつもり
        tmp = Uf_GUI(xn,xd',vf,P) + Us_GUI_mex(xn,xd',[vf,0,0],vs(:),P); % Us_GUIも17% 計算時間
        % tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P); % force

        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4)]; % トルク入力への変換
        obj.self.input = obj.result.input;  % agent.inputへの代入

        obj.input.u = [vf; vs];

        %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，
        %   評価が良くなったら標準偏差を狭めるようにしている
        obj.input.Bestcost_pre = obj.input.Bestcost_now;
        obj.input.Bestcost_now = Bestcost;

        % 棄却数がサンプル数の半分以上なら入力増やす
        if removeF > obj.N /2
          obj.input.nextsigma = obj.input.Constsigma;
          obj.param.nextparticle_num = obj.param.Maxparticle_num;
          % obj.input.AllRemove = 1;
        else
          obj.input.nextsigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))));
          % obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now(1)/obj.input.Bestcost_pre(1)))));
        end

      elseif removeF == obj.N    % 全棄却
        %agent.input = そのまま
        obj.input.nextsigma = obj.input.Constsigma;
        Bestcost = ones(1,5) .* obj.param.ConstEval;
        BestcostID = ones(1,5);
        obj.input.AllRemove = 1;

        obj.param.nextparticle_num = obj.param.Maxparticle_num;
        %% previous input
        obj.result.input = obj.self.input;
        obj.input.u = obj.self.input;

        %%
        % vf = obj.input.u(1,1,1);
        % vs(:,1) = obj.input.u(2:4,1,1);
        % obj.result.input  = Uf_GUI(xn,xd',vf,P) + Us_GUI(xn,xd',[vf,0,0],vs(:),P);
        % obj.input.u = [vf; vs];
      end

      obj.result.removeF = removeF;
      obj.result.removeX = removeX;
      obj.result.survive = survive;
      obj.result.COG = obj.state.COG;
      obj.result.input_v = obj.input.u; % input.v
      obj.result.bestcostID = BestcostID;
      obj.result.bestcost = Bestcost;
      obj.result.contParam = obj.param;
      obj.result.fRemove = obj.param.fRemove;
      obj.result.path = obj.state.real_data; % 実状態
      obj.result.sigma = obj.input.sigma;
      obj.result.variable_N = obj.N; % 追加
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      % obj.result.Evaluationtra_norm = obj.input.normE;

      result = obj.result;
      % profile viewer
    end
    function show(obj)
      obj.result
    end

    %-- 制約とその重心計算 --%
    function [removeF, removeX, survive] = constraints(obj)      
      % removeF = 0;
      removeX = 0;

      %% 制約 状態＝目標値との誤差
      % HLstate = x_real - ref
      x_real = obj.state.real_data;
      % constX = find(x_real(3,5,1:obj.N) > 2); % 1:obj.N 大事
      % constY = find(x_real(3,5,1:obj.N) > -0.5);
      % constX = find(x_real(3,5,1:obj.N) < -1.5 | x_real(7,5,1:obj.N) > 0.5);

      %% Any horizon
      constX = find(x_real(3,:,1:obj.N) < -1.5 | x_real(7,:,1:obj.N) > 0.5); % Any horizon
      constX = unique(constX);
      %% 進路上に物体
      % 四角
      % InputIdx = obj.param.H;
      % constAreaY = x_real(7,InputIdx,find(x_real(3,InputIdx,1:obj.N) > 2 & x_real(3,InputIdx,1:obj.N) < 4));
      % constX = find(constAreaY < 0.2);

      %% 評価値で棄却 
      % obj.input.Evaluationtra(constX, :) = obj.param.ConstEval;

      %% 配列から棄却
      % obj.input.Evaluationtra(constX, :) = nan;
      % obj.input.u(:,:,constX) = nan;

      % obj.input.Evaluationtra(constY, :) = nan;
      % obj.input.u(:,:,constY) = nan;

      removeX = constX;
      removeF = size(constX, 1);
      survive = obj.N - removeF;
      if removeF ~= 0
          removeF
      end

      %% ソフト制約
      % 棄却はしないが評価値を大きくする
    end

    % function cog = COG(obj, I)
    %   if size(I) == 1
    %     x = obj.state.state_data(1, end, I);
    %     y = obj.state.state_data(2, end, I);
    %     cog = [x, y];
    %   else
    %     x = reshape(obj.state.state_data(1, end, I), [size(I,1), 1]);
    %     y = reshape(obj.state.state_data(2, end, I), [size(I,1), 1]);
    %     cog = mean([x,y]);
    %   end
    % end

    %%-- 離散：階層型線形化
    % obj.param.expand_A 
    function [predict_state] = predict(obj)
      predict_state = zeros(12*obj.param.H, obj.N);
      u = obj.input.u_vec;
      x0 = obj.current_state;
      for i = 1:obj.N
          predict_state(:,i) = obj.param.expand_A(:,:,i) * x0 + obj.param.expand_B(:,:,i) * u(:,i);
      end
      % predict_state = 12H * 1
      predict_state = reshape(predict_state, 12, obj.param.H, obj.N); 
      % TODO: for なし
    end

    %------------------------------------------------------
    %======================================================
    function [MCeval] = objective(obj, ~)   % obj.~とする
      U = obj.input.u(:,:,1:obj.N);                % 4  * 10 * N
      removeX = [];
      AP = [];
      %% 実状態との誤差
      Z = obj.state.error_data;
      Zreal = obj.state.real_data;
        
      %% ホライズンで重み大きく
      k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
      % k = ones(1, obj.param.H);

      %% コスト計算
      tildeUpre = U - obj.input.v;          % agent.input 　前時刻入力との誤差
      tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

      %% 制約外の軌道に対して値を付加
      % x:3, y:7
      % [~, removeX, ~] = obj.constraints();

      %% Artificial potential
      % Xreal = Zreal(3,:,:);
      % Yreal = Zreal(7,:,:);
      % AP = obj.param.AP ./(sqrt((Xreal - obj.param.constX).^2) + sqrt((Yreal - obj.param.constY).^2));

      %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      % stageStateZ =    k .* Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,1:obj.N),Z(:,1:end-1,:));
      % stageInputPre  = k .* tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,1:obj.N),tildeUpre(:,1:end-1,:));
      % stageInputRef  = k .* tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,1:obj.N),tildeUref(:,1:end-1,:));

      %-- 状態の終端コストを計算 状態だけの終端コスト
      % terminalState = sum(k .* Z(:,end,:).*pagemtimes(obj.Weight(:,:,1:obj.N),Z(:,end,:)), [1,2]);
      stageStateZ =    k .* Z.*pagemtimes(obj.Weight(:,:,1:obj.N),Z);
      stageInputPre  = k .* tildeUpre.*pagemtimes(obj.WeightR(:,:,1:obj.N),tildeUpre);
      stageInputRef  = k .* tildeUref.*pagemtimes(obj.WeightRp(:,:,1:obj.N),tildeUref);

      %% 軌道ごとに制約を評価
      if ~isempty(removeX)
      stageStateZ(3, removeX) = stageStateZ(3, removeX) + obj.param.ConstEval;
      stageStateZ(7, removeX) = stageStateZ(7, removeX) + obj.param.ConstEval;
      end

      %% 人工ポテンシャルをx, yにプラス
      if ~isempty(AP)
      stageStateZ(3, :,:) = AP;
      stageStateZ(7, :,:) = AP;
      end

      %-- 評価値計算
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
        pw = pw/sum(pw);%正規化
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
  end
end
