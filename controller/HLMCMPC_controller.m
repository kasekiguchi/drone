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
      %             obj.param.subCheck = zeros(obj.N, 1);
      obj.param.modelparam.modelparam = obj.self.parameter.get();
      obj.param.modelparam.modelmethod = obj.self.model.method;
      obj.param.modelparam.modelsolver = obj.self.model.solver;

      %%
      obj.input = param.input;
      obj.const = param.const;
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
      obj.model = self.model;
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
%       obj.Weight = repmat(blkdiag(obj.param.P,obj.param.V,obj.param.QW),1,1,obj.N); % ステージコスト
%       obj.WeightF = repmat(blkdiag(obj.param.Pf,obj.param.Vf,obj.param.QWf),1,1,obj.N); % ターミナルコスト
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

%       obj.param.te = 10;
    end

    %-- main()的な
    function result = do(obj,param)
      %profile on
      xr = param{2};
      rt = param{3};
%       obj.input.InputV = param{5};
      obj.state.ref = xr;
      obj.param.t = rt;
      idx = rt/obj.self.model.dt+1;

      %% HL
      ref = obj.self.reference.result;
      xd = ref.state.get();
      if isprop(ref.state,'xd')
        if ~isempty(ref.state.xd)
          xd = ref.state.xd; % 20次元の目標値に対応するよう
        end
      end
      model_HL = obj.self.estimator.result;
%       xn = [model_HL.state.getq('compact');model_HL.state.p;model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え

      %%
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      xn = [R2q(Rb0'*model_HL.state.getq("rotmat"));Rb0'*model_HL.state.p;Rb0'*model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      %%
      P = obj.param.modelparam.modelparam;
      vfn = Vf(xn,xd',P,obj.F1); %v1
      z1n = Z1(xn,xd',P);
      z2n = Z2(xn,xd',vfn,P);
      z3n = Z3(xn,xd',vfn,P);
      z4n = Z4(xn,xd',vfn,P);
      obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)];

      % ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
      % ave2 = obj.input.u(2);    % 初期値はparamで定義
      % ave3 = obj.input.u(3);
      % ave4 = obj.input.u(4);

      ave1 = 0;
      ave2 = 0;
      ave3 = 0;
      ave4 = 0;
      % 標準偏差，サンプル数の更新
      obj.input.sigma = obj.input.nextsigma;
      obj.N = obj.param.nextparticle_num;

      % 全棄却時のケア
      if obj.input.AllRemove == 1
        ave1 = 0;
        ave2 = 0;
        ave3 = 0;
        ave4 = 0;
        obj.input.AllRemove = 0;
      end

      % 入力生成
      % obj.input.u1 = obj.input.sigma(1).*randn(obj.param.H, obj.N) + ave1; % 負入力の阻止
      % obj.input.u2 = obj.input.sigma(2).*randn(obj.param.H, obj.N) + ave2;
      obj.input.u3 = obj.input.sigma(3).*randn(obj.param.H, obj.N) + ave3;
      % obj.input.u4 = obj.input.sigma(4).*randn(obj.param.H, obj.N) + ave4;

      obj.input.u1 = zeros(obj.param.H, obj.N);
      obj.input.u2 = zeros(obj.param.H, obj.N);
      obj.input.u4 = zeros(obj.param.H, obj.N);

      obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

      %-- 状態予測
      [obj.state.state_data] = obj.predict();
      %% 墜落 or 飛びすぎたら終了
      if obj.state.state_data(1,1,:) + xd(3) < 0
        obj.param.fRemove = 1;
      elseif obj.state.state_data(1,1,:) + xd(3) > 5
        obj.param.fRemove = 1;
      end

      %-- 評価値計算
      obj.input.Evaluationtra =  obj.objective();

      % 評価値の正規化
      obj.input.normE = obj.Normalize();

      %-- 制約条件
      removeF = 0; removeX = []; survive = obj.N;
      %             if obj.self.estimator.result.state.p(3) < 0.3
      %                 [removeF, removeX, survive] = obj.constraints();
      %             end
      obj.state.COG.g = 0; obj.state.COG.gc = 0;


      if removeF ~= obj.N
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        vf = obj.input.u(1, 1, BestcostID(1));     % 最適な入力の取得
        vs = obj.input.u(2:4, 1, BestcostID(1));     % 最適な入力の取得
        tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);
        obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
        obj.self.input = obj.result.input;  % agent.inputへの代入

        obj.result.v = [vf; vs];
        obj.input.v = obj.result.v;

        %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，
        %   評価が良くなったら標準偏差を狭めるようにしている

        obj.input.Bestcost_pre = obj.input.Bestcost_now;
        obj.input.Bestcost_now = Bestcost;

        % 棄却数がサンプル数の半分以上なら入力増やす
        if removeF > obj.N /2
          obj.input.nextsigma = obj.input.Constsigma;
          obj.param.nextparticle_num = obj.param.Maxparticle_num;
          obj.input.AllRemove = 1;
        else
          obj.input.nextsigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now(2:5)./obj.input.Bestcost_pre(2:5))));
          % 追加
          obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now(1)/obj.input.Bestcost_pre(1)))));
        end

      elseif removeF == obj.N    % 全棄却
        %agent.input = そのまま
        obj.input.nextsigma = obj.input.Constsigma;
        Bestcost = obj.param.ConstEval;
        BestcostID = 1;
        obj.input.AllRemove = 1;

        % 追加
        obj.param.nextparticle_num = obj.param.Maxparticle_num;
      end

      obj.input.u = obj.input.v;

      % 座標として軌跡を保存するため　x = state + xd
      state_xd = [xd(3);xd(7);xd(1);xd(5);xd(9);xd(13);xd(2);xd(6);xd(10);xd(14);xd(4);xd(8)];

      obj.result.removeF = removeF;
      obj.result.removeX = removeX;
      obj.result.survive = survive;
      obj.result.COG = obj.state.COG;
      obj.result.input_v = obj.input.v;
      obj.result.BestcostID = BestcostID;
      obj.result.bestcost = Bestcost;
      obj.result.contParam = obj.param;
      obj.result.fRemove = obj.param.fRemove;
      obj.result.path = obj.state.state_data + state_xd;
      obj.result.sigma = obj.input.sigma;
      obj.result.variable_N = obj.N; % 追加
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      obj.result.Evaluationtra_norm = obj.input.normE;

      result = obj.result;
      %profile viewer
    end
    function show(obj)
      obj.result
    end

    %-- 制約とその重心計算 --%
    function [removeF, removeX, survive] = constraints(obj)
      % 状態制約
      %             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(1, end, :) < 0);
      %             removeFe = (obj.state.state_data(1, end, :) <= -0.5);
      %             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(2, end, :) <= obj.const.Y);
      removeX = find(removeFe);
      % 制約違反の入力サンプル(入力列)を棄却
      obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
      % 全制約違反による分散リセットを確認するフラグ
      removeF = size(removeX, 1); % particle_num -> 全棄却
      survive = obj.N;

      %% ソフト制約
      % 棄却はしないが評価値を大きくする
    end

    function cog = COG(obj, I)
      if size(I) == 1
        x = obj.state.state_data(1, end, I);
        y = obj.state.state_data(2, end, I);
        cog = [x, y];
      else
        x = reshape(obj.state.state_data(1, end, I), [size(I,1), 1]);
        y = reshape(obj.state.state_data(2, end, I), [size(I,1), 1]);
        cog = mean([x,y]);
      end
    end

    %%-- 連続；オイラー近似
    function [predict_state] = predict(obj)
      u = obj.input.u;
      obj.state.state_data(:,1,1:obj.N) = repmat(obj.current_state,1,1,obj.N);
      for i = 1:obj.param.H-1
        obj.state.state_data(:,i+1,1:obj.N) = pagemtimes(obj.A(:,:,1:obj.N),obj.state.state_data(:,i,1:obj.N)) + pagemtimes(obj.B(:,:,1:obj.N),u(:,i,1:obj.N));
      end
      predict_state = obj.state.state_data;
    end

    %------------------------------------------------------
    %======================================================
    function [MCeval] = objective(obj, ~)   % obj.~とする
      X = obj.state.state_data(:,:,1:obj.N);       % 12 * 10 * N
      U = obj.input.u(:,:,1:obj.N);                % 12 * 10 * N
      Z = X;% - obj.state.ref(1:12,:);

      tildeUpre = U - obj.input.v;         % agent.input
      tildeUref = U - obj.param.ref_input;  %

      %-- 状態及び入力のステージコストを計算
      stageStateZ = sum(Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,1:end-1,:)),[1,2]);%
      stageInputPre  = sum(tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
      stageInputRef  = sum(tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);

      %-- 状態の終端コストを計算 状態だけの終端コスト
      terminalState = sum(Z(:,end,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,end,:)),[1,2]);

      %-- 評価値計算
      MCEval{1} = stageStateZ + stageInputPre + stageInputRef + terminalState;
      MCEval{2} = sum(Z(1:2,:,:)   .* pagemtimes(obj.Weight(1:2,1:2,obj.N),       Z(1:2,:,:)),[1,2]);
      MCEval{3} = sum(Z(3:6,:,:)   .* pagemtimes(obj.Weight(3:6,3:6,obj.N),       Z(3:6,:,:)),[1,2]);
      MCEval{4} = sum(Z(7:10,:,:)  .* pagemtimes(obj.Weight(7:10,7:10,obj.N),    Z(7:10,:,:)),[1,2]);
      MCEval{5} = sum(Z(11:12,:,:) .* pagemtimes(obj.Weight(11:12,11:12,obj.N), Z(11:12,:,:)),[1,2]);

      %-- 評価値をreshapeして縦ベクトルに変換
      MCeval(:,1) = reshape(MCEval{1}, obj.N, 1);
      MCeval(:,2) = reshape(MCEval{2}, obj.N, 1);
      MCeval(:,3) = reshape(MCEval{3}, obj.N, 1);
      MCeval(:,4) = reshape(MCEval{4}, obj.N, 1);
      MCeval(:,5) = reshape(MCEval{5}, obj.N, 1);

    end

    function [pw_new] = Normalize(obj)
      NP = obj.N;
      pw = obj.input.Evaluationtra(1);

      % 配列が空かどうかの判別/ pw=評価値
      %             if isempty(pw(pw<=49))
      %                 obj.reset_flag = 1;
      %             end
      % 評価値は0未満にならず最小値を正規化した際の1と考えた場合，指数関数を
      % 使って正規化をすることによって上手いことリサンプリングできる．
      pw = exp(-pw);
      sumw = sum(pw);
      if sumw~=0
        pw = pw/sum(pw);%正規化
      else
        pw = zeros(1,NP)+1/NP;
      end
      pw_new = pw;
    end
  end
end
