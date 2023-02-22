classdef MCMPC_controller <CONTROLLER_CLASS
  % MCMPC_CONTROLLER MCMPCのコントローラー

  properties
    options
    param
    current_state
    input
    state
    const
    reference
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
    function obj = MCMPC_controller(self, param)
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
      obj.result.v = obj.input.u;

      %             obj.input.Evaluationtra = zeros(1, obj.N);
      obj.model = self.model;
      %-- 全予測軌道のパラメータの格納変数を定義,　最大のサンプル数で定義
      %             obj.state.p_data = 10000 * ones(obj.param.H, obj.N);
      %             obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
      %             obj.state.v_data = 10000 * ones(obj.param.H, obj.N);
      %             obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
      %             obj.state.q_data = 10000 * ones(obj.param.H, obj.N);
      %             obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
      %             obj.state.w_data = 10000 * ones(obj.param.H, obj.N);
      %             obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);

      obj.param.fRemove = 0;
      obj.input.AllRemove = 0;
      obj.modelf = obj.param.modelparam.modelmethod;
      obj.modelp = obj.param.modelparam.modelparam;

      obj.input.nextsigma = param.input.Initsigma;
      % 追加
      obj.param.nextparticle_num = param.Maxparticle_num;
      obj.input.Bestcost_now = 1e6;% 十分大きい値にする
      obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],self.model.dt);    
      obj.N = param.particle_num;
      n = 12; % 状態数
      obj.state.state_data = zeros(n,obj.param.H, obj.N);
      obj.input.Evaluationtra = zeros(1, obj.N);
      obj.Weight = repmat(blkdiag(obj.param.P,obj.param.V,obj.param.QW),1,1,obj.N);
      obj.WeightF = repmat(blkdiag(obj.param.Pf,obj.param.Vf,obj.param.QWf),1,1,obj.N);
      obj.WeightR = repmat(obj.param.R,1,1,obj.N);
      obj.WeightRp = repmat(obj.param.RP,1,1,obj.N);
      A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
      B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
      sysd = c2d(ss(A,B,eye(12),0),obj.model.dt);
      obj.A = repmat(sysd.A,1,1,obj.N);
      obj.B = repmat(sysd.B,1,1,obj.N);
    end

    %-- main()的な
    % u fFirst
    function result = do(obj,param)
      %profile on
      idx = param{1};
      xr = param{2};
      rt = param{3};
      phase = param{4};
      obj.state.ref = xr;
      obj.param.t = rt;

      ref = obj.self.reference.result;
      xd = ref.state.get();
      if isprop(ref.state,'xd')
        if ~isempty(ref.state.xd)
          xd = ref.state.xd; % 20次元の目標値に対応するよう
        end
      end
      model = obj.self.estimator.result;
      xn = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
      P = obj.param.modelparam.modelparam ;
      vfn = Vf(xn,xd',P,obj.F1);%v1
      z1n = Z1(xn,xd',P);
      z2n = Z2(xn,xd',vfn,P);
      z3n = Z3(xn,xd',vfn,P);
      z4n = Z4(xn,xd',vfn,P);
      obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)];
      

      %
      %             if phase == 1
      %                 obj.param.QW = diag([1000; 1000; 100; 1; 1; 1]);
      %             end

      ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
      ave2 = obj.input.u(2);
      ave3 = obj.input.u(3);
      ave4 = obj.input.u(4);


      obj.input.sigma = obj.input.nextsigma;
      obj.N = obj.param.nextparticle_num;

      % 全棄却時のケア
      if obj.input.AllRemove == 1
        ave1 = 0.269*9.81;
        ave2 = 0;
        ave3 = 0;
        ave4 = 0;
        obj.input.AllRemove = 0;
      end
      %             rng ('shuffle');
      
      obj.input.u1 = max(0,obj.input.sigma(1).*randn(obj.param.H, obj.N) + ave1);
      obj.input.u2 = obj.input.sigma(2).*randn(obj.param.H, obj.N) + ave2;
      obj.input.u3 = obj.input.sigma(3).*randn(obj.param.H, obj.N) + ave3;
      obj.input.u4 = obj.input.sigma(4).*randn(obj.param.H, obj.N) + ave4;
      
      obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

      %-- 状態予測
      [obj.state.predict_state] = obj.predict();
      if obj.state.predict_state(1, 1, :) < 0
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
        vf = obj.input.u(1, 1, BestcostID);     % 最適な入力の取得
        vs = obj.input.u(2:4, 1, BestcostID);     % 最適な入力の取得
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);
            obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)];
            obj.self.input = obj.result.input;  % 入力算出

            %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
        
          obj.input.Bestcost_pre = obj.input.Bestcost_now;
          obj.input.Bestcost_now = Bestcost;

        % 棄却数がサンプル数の半分以上なら入力増やす
        if removeF > obj.N /2
          obj.input.nextsigma = obj.input.Constsigma;
          obj.param.nextparticle_num = obj.param.Maxparticle_num;
          obj.input.AllRemove = 1;
        else
          obj.input.nextsigma = min( obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma * (obj.input.Bestcost_now/obj.input.Bestcost_pre)));
          % 追加
          obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now/obj.input.Bestcost_pre))));
        end

        %                 if obj.param.nextparticle_num < obj.N * 2
        %                     obj.param.nextparticle_num = obj.N * 2;
        %                 end


      elseif removeF == obj.N    % 全棄却
        obj.result.v = obj.input.u;
        obj.input.nextsigma = obj.input.Constsigma;
        Bestcost = obj.param.ConstEval;
        BestcostID = 1;
        obj.input.AllRemove = 1;

        % 追加
        obj.param.nextparticle_num = obj.param.Maxparticle_num;
      end

      %             if Bestcost > obj.param.ConstEval; Bestcost = obj.param.ConstEval;  end

      obj.result.removeF = removeF;
      obj.result.removeX = removeX;
      obj.result.survive = survive;
      obj.result.COG = obj.state.COG;
      obj.input.u = obj.result.v;
      obj.result.BestcostID = BestcostID;
      obj.result.bestcost = Bestcost;
      obj.result.contParam = obj.param;
      obj.result.fRemove = obj.param.fRemove;
      obj.result.path = obj.state.state_data;
      obj.result.sigma = obj.input.sigma;
      obj.result.variable_N = obj.N; % 追加
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      obj.result.Evaluationtra_norm = obj.input.normE;

      result = obj.result;
      %profile viewer
    end
    function show(obj)
      obj.result
      %             view([2]);
    end

    %-- 制約とその重心計算 --%
    function [removeF, removeX, survive] = constraints(obj)
      % 状態制約
      %             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(1, end, :) < 0);
      %             removeFe = (obj.state.state_data(1, end, :) <= -0.5);
      %             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(2, end, :) <= obj.const.Y);

      % 姿勢角
      removeFe = (obj.state.state_data(5, end, :) >= 0.3975 | obj.state.state_data(5, end, :) <= 0.1975);

      % ドローンの四隅の座標
      % drone = 四隅の座標 Particle_num * 2
      %             drone = obj.state.state_data(1,end,:);
      %             drone_1 = drone+obj.self.parameter.lx*cos(obj.state.state_data(9, end, :));
      %             drone_2 = drone-obj.self.parameter.lx*cos(obj.state.state_data(9, end, :));
      %             drone_3 = drone_2;
      %             drone_4 = drone_1;
      %             d4edge = [drone_1, drone_2];

      % 高度
      %             zx = 10;
      %             zz = 3;
      %             removeFe = (any(repmat(obj.state.state_data(3, end, :), 1, 2) <= zz/zx * d4edge(1,:, :)+0.1));


      removeX = find(removeFe);
      % 制約違反の入力サンプル(入力列)を棄却
      obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
      % 全制約違反による分散リセットを確認するフラグ
      removeF = size(removeX, 1); % particle_num -> 全棄却
      %             sur = (obj.state.state_data(1, end, :) > 0.5*sin(obj.param.t));  % 生き残りサンプル
      %             survive = find(sur);
      survive = obj.N;

      %% ソフト制約
      % 棄却はしないが評価値を大きくする

      %% 重心計算
      %             if removeF == obj.N
      %                 obj.state.COG.g  = NaN;               % 制約内は無視
      %                 obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
      %             elseif removeF == 0
      %                 obj.state.COG.gc = NaN;               % 制約外は無視
      %                 obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
      %             else
      %                 obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
      %                 obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
      %             end
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
      %-- 予測軌道計算
%       for m = 1:obj.N
%         x0 = obj.current_state;
%         obj.state.state_data(:, 1, m) = obj.current_state;
%         %                 for h = 1:obj.param.H-1
%         %                     x0 = x0 + obj.param.dt * obj.param.modelparam.modelmethod(x0, obj.input.u(:, h, m), obj.param.modelparam.modelparam);
%         %                     obj.state.state_data(:, h+1, m) = x0;
%         %                 end
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 1, m), obj.modelp); obj.state.state_data(:, 2, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 2, m), obj.modelp); obj.state.state_data(:, 3, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 3, m), obj.modelp); obj.state.state_data(:, 4, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 4, m), obj.modelp); obj.state.state_data(:, 5, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 5, m), obj.modelp); obj.state.state_data(:, 6, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 6, m), obj.modelp); obj.state.state_data(:, 7, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 7, m), obj.modelp); obj.state.state_data(:, 8, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 8, m), obj.modelp); obj.state.state_data(:, 9, m) = x0;
%         x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 9, m), obj.modelp); obj.state.state_data(:, 10, m) = x0;
%       end


      %ベクトル化：  input[4*obj.N, obj.param.H]
      % 無名関数@ cellには入れられた気がする
      %             model_equ = {obj.N, 1};
      %             for mk = 1:obj.N
      %                 model_equ{mk, 1} = obj.param.modelparam.modelmethod;
      %             end
      %             x0 = repmat(obj.current_state, obj.N, 1);
      %             obj.state.state_data(:, 1) = repmat(obj.current_state, obj.N, 1);
      %             for h = 1:obj.param.H-1
      %                 x0 = x0 + obj.param.dt * model_equ{:, 1}(); cell配列の式に値を代入する方法
      %             end
      predict_state = obj.state.state_data;
    end

    %------------------------------------------------------
    %======================================================
    function [MCeval] = objective(obj)   % obj.~とする
      X = obj.state.state_data(:,:,1:obj.N);       %12 * 10 * N
      U = obj.input.u(:,:,1:obj.N);         %12 * 10 * N
      Z = X;% - obj.state.ref(1:12,:);

      tildeUpre = U - obj.result.v;       % agent.input
      tildeUref = U - obj.param.ref_input;

      %% 入力の変化率
      %             rate_change = tildeUpre/U;


      %-- 状態及び入力のステージコストを計算
      %             stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
      %             stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
      %             stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
      %             stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
      %             stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);
      stageStateZ = sum(Z.*pagemtimes(obj.Weight(:,:,obj.N),Z),[1,2]);%
      stageInputPre  = sum(tildeUpre.*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
      stageInputRef  = sum(tildeUref.*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);
      
      %-- 状態の終端コストを計算 状態だけの終端コスト
      terminalState = sum(Z(:,end,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,end,:)),[1,2]);
%       tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
%         +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
%         +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);
      %             APF = obj.param.Qapf/apfLower;
      %-- 評価値計算
      MCeval = stageStateZ + stageInputPre + stageInputRef + terminalState;
    end

    function [pw_new] = Normalize(obj)
      NP = obj.N;
      pw = obj.input.Evaluationtra;

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
