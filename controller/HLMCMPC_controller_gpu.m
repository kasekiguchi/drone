classdef HLMCMPC_controller_gpu <CONTROLLER_CLASS
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
    function obj = HLMCMPC_controller_gpu(self, param)
      %-- 変数定義
      obj.self = self;
      %---MPCパラメータ設定---%
      obj.param = param;
      %             obj.param.subCheck = zeros(obj.N, 1);
      obj.param.modelparam.modelparam = obj.self.parameter.get();
      obj.param.modelparam.modelmethod = obj.self.model.method;
      obj.param.modelparam.modelsolver = obj.self.model.solver;
      obj.modelf = obj.self.model.method;
      obj.modelp = obj.self.parameter.get();

      %%
      obj.input = param.input;
      obj.const = param.const;
      obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
      obj.param.H = param.H + 1;
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
      obj.Weight = gpuArray(repmat(blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI), 1, 1, obj.N));
      obj.WeightF = gpuArray(repmat(blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf), 1, 1, obj.N));
      obj.WeightR = gpuArray(repmat(obj.param.R,1,1,obj.N));  % 目標入力
      obj.WeightRp = gpuArray(repmat(obj.param.RP,1,1,obj.N)); % 前ステップとの入力
      % HL. A, B行列定義
      % z, x, y, yawの順番
      A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
      B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
      sysd = c2d(ss(A,B,eye(12),0),param.dt); % 離散化
      obj.A = gpuArray(repmat(sysd.A,1,1,obj.N)); % サンプル分同時に計算のためobj.N分のA行列を用意
      obj.B = gpuArray(repmat(sysd.B,1,1,obj.N));

      obj.result.bestx(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.besty(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.bestz(1, :) = repmat(obj.input.Bestcost_now(1), param.H, 1); % - 制約外は前の評価値を引き継ぐ
      
      %%
      
%       obj.param.te = 10;
    end

    %-- main()的な
    function result = do(obj,param)
      % profile on
      % OB = obj;
      xr = param{2};
      rt = param{3};
%       obj.input.InputV = param{5};
      obj.state.ref = xr;
      obj.param.t = rt;
      idx = round(rt/obj.self.model.dt+1);

      % InputV = param{5};

      %% HL 5/18 削除------------------------------------------------------------------------------------------------------------------------
      % ref = obj.self.reference.result;
      % xd = ref.state.get();
      % if isprop(ref.state,'xd')
      %   if ~isempty(ref.state.xd)
      %     xd = ref.state.xd; % 20次元の目標値に対応するよう
      %   end
      % end

      %% from main ref
      xd = [xr(1:3,1); 0; xr(7:9,1); 0];
      xd = [xd; zeros(24, 1)];
%
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
      % xd に０ではない値が入っている。
      % ↓
      % obj.current_state=0じゃない。　ホバリング目標値で0,0,1が現在位置だから誤差があるわけではない
      % ここも問題の一つ
      % -------------------------------------------------------------------------------------------------------------------------------------
      %% Referenceの取得、ホライズンごと
      % obj.reference.xr = ControllerReference(obj); % 12 * obj.param.H 仮想状態 * ホライズン

      % xd:114-119行目　仮想状態の目標値に変換？　➡　xdを評価関数としての目標値に再利用
      % obj.reference.xr = [xd(3);xd(7);xd(1);xd(5);xd(9);xd(13);xd(2);xd(6);xd(10);xd(14);xd(4);xd(8)];

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

      % main から　reference
      % z vz x vx ax jx y vy ay jy yaw vyaw
      % obj.reference.xr = [xr(3,:); xr(9,:); 
      %                 xr(1,:); xr(7,:); zeros(2,obj.param.H); 
      %                 xr(2,:); xr(8,:); zeros(2, obj.param.H); 
      %                 zeros(2,obj.param.H)];
      
      % ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
      % ave2 = obj.input.u(2);    % 初期値はparamで定義
      % ave3 = obj.input.u(3);
      % ave4 = obj.input.u(4);

      mu(1,1) = 0;
      mu(2,1) = 0;
      mu(3,1) = 0;
      mu(4,1) = 0; % トルク入力モデルだと基本は0であってほしいことから平均値を0に固定

      % ave1 = InputV(1,idx);
      % ave2 = InputV(2,idx);
      % ave3 = InputV(3,idx);
      % ave4 = InputV(4,idx);
      % 標準偏差，サンプル数の更新
      obj.input.sigma = obj.input.nextsigma;
      obj.N = obj.param.nextparticle_num;

      % 全棄却時のケア
      if obj.input.AllRemove == 1
        % ave1 = 10;
        % ave2 = 10;
        % ave3 = 10;
        % ave4 = 10;
        if rem(idx,2) == 0 % 時間ごとに±入れ替え
            mu = obj.input.Constinput * [0;1;1;0];
        else
            mu = -obj.input.Constinput *[0;1;1;0];
        end
        % mu = obj.param.ref_input;
        % obj.input.sigma = obj.input.Constsigma;
        obj.input.AllRemove = 0;
      end

      % obj.input.sigma(4) = 0;
      % 入力生成 Z; X; Y; YAW
      obj.input.u1 = obj.input.sigma(1).*randn(obj.param.H, obj.N) + mu(1,1); 
      obj.input.u2 = obj.input.sigma(2).*randn(obj.param.H, obj.N) + mu(2,1);
      obj.input.u3 = obj.input.sigma(3).*randn(obj.param.H, obj.N) + mu(3,1);
      obj.input.u4 = obj.input.sigma(4).*randn(obj.param.H, obj.N) + mu(4,1);

      obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

      %-- 状態予測
      Objpredict.H = obj.param.H;
      Objpredict.N = obj.N; Objpredict.A = obj.A; Objpredict.B = obj.B;
      Objpredict.input = obj.input.u; Objpredict.current_state = obj.current_state;
      Objpredict.state = obj.state.state_data; 
      [obj.state.state_data] = predict(Objpredict);
      % [obj.state.state_data] = predict_mex(Objpredict);

      %% 墜落 or 飛びすぎたら終了
      if obj.state.state_data(1,1,:) + xd(3) < 0
        obj.param.fRemove = 1;
      elseif obj.state.state_data(1,1,:) + xd(3) > 5
        obj.param.fRemove = 1;
      end

      %% 実状態変換
      Xd = repmat(obj.reference.xr_org, 1,1,obj.N);
      Xreal = Xd + obj.state.state_data; % + or -
      obj.state.error_data = Xd - Xreal;
      obj.state.real_data = Xreal;

      %-- 評価値計算 
      profile on;
      obj.input.Evaluationtra =  obj.objective();
      % obj.input.Evaluationtra = objective(Objobj);  
      profile viewer;

      % 評価値の正規化
      % obj.input.normE = obj.Normalize();

      %-- 制約条件
      removeF = 0; removeX = []; survive = obj.N;
      [removeF, removeX, survive] = obj.constraints();
      obj.state.COG.g = 0; obj.state.COG.gc = 0;
        
      
      if removeF ~= obj.N
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        % トルク入力にしたらそれぞれの最適入力をとる必要あり？
        % vf = obj.input.u(1, 1, BestcostID(2));     % 最適な入力の取得
        % vs(1) = obj.input.u(2, 1, BestcostID(3));     % 最適な入力の取得
        % vs(2) = obj.input.u(3, 1, BestcostID(4));
        % vs(3) = obj.input.u(4, 1, BestcostID(5)); % 2,3,4,5 だと個別の評価値に対する入力
        vf = obj.input.u(1, 1, BestcostID(1));     % 最適な入力の取得
        vs(1) = obj.input.u(2, 1, BestcostID(1));     % 最適な入力の取得
        vs(2) = obj.input.u(3, 1, BestcostID(1));
        vs(3) = obj.input.u(4, 1, BestcostID(1)); % 2,3,4,5 だと個別の評価値に対する入力
        vs = vs';
        % GUI共通プログラムから トルク入力の変換のつもり
        tmp = Uf_GUI(xn,xd',vf,P) + Us_GUI(xn,xd',[vf,0,0],vs(:),P); % Us_GUIも17% 計算時間

        % obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4)]; % トルク入力への変換

        % obj.result.input = [0.269*9.81; tmp(2); tmp(3); 0];
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
          obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now(1)/obj.input.Bestcost_pre(1)))));
        end

      elseif removeF == obj.N    % 全棄却
        %agent.input = そのまま
        obj.input.nextsigma = obj.input.Constsigma;
        Bestcost = ones(1,5) .* obj.param.ConstEval;
        BestcostID = ones(1,5);
        obj.input.AllRemove = 1;

        obj.param.nextparticle_num = obj.param.Maxparticle_num;
        % previous input
        obj.result.input = obj.self.input;
      end

      obj.input.u = obj.input.v; % 仮想状態の保存

      % 座標として軌跡を保存するため　x = xd + state
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
      obj.result.path = obj.state.real_data; % 実状態
      obj.result.sigma = obj.input.sigma;
      obj.result.variable_N = obj.N; % 追加
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      % obj.result.Evaluationtra_norm = obj.input.normE;
      obj.result.eachcost = [Bestcost, ...
          obj.input.Evaluationtra(BestcostID(1), 1), ...
          obj.input.Evaluationtra(BestcostID(2), 2), ...
          obj.input.Evaluationtra(BestcostID(3), 3), ...
          obj.input.Evaluationtra(BestcostID(4), 4), ...
          obj.input.Evaluationtra(BestcostID(5), 5)]; % all, z, x, y, yaw, 

      result = obj.result;
      % profile viewer
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
      % removeX = find(removeFe);
      % 制約違反の入力サンプル(入力列)を棄却
      % obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
      % 全制約違反による分散リセットを確認するフラグ
      % removeF = size(removeX, 1); % particle_num -> 全棄却
      
      % removeF = 0;
      removeX = 0;

      %% 制約 状態＝目標値との誤差
      % HLstate = x_real - ref
      x_real = obj.state.real_data;
      constX = find(x_real(3,5,:) > 0.5);
      % CX = reshape(obj.param.const * abs(obj.state.state_data(6, end, constX)).^2, [1, length(constX)]);
      obj.input.Evaluationtra(constX,1) = NaN;  % 棄却

      removeF = size(constX, 1);
      survive = obj.N - removeF;
      if removeF ~= 0
          removeF
      end

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

    %%-- 離散：階層型線形化
    % function [predict_state] = predict(obj)
    %   u = obj.input.u;
    %   obj.state.state_data(:,1,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % サンプル数分初期値を作成
    %   for i = 1:obj.param.H-1
    %     obj.state.state_data(:,i+1,1:obj.N) = pagemtimes(obj.A(:,:,1:obj.N),obj.state.state_data(:,i,1:obj.N)) + pagemtimes(obj.B(:,:,1:obj.N),u(:,i,1:obj.N));
    %   end
    %   predict_state = obj.state.state_data;
    % end

    %------------------------------------------------------
    %======================================================
    function [MCeval] = objective(obj, ~)   % obj.~とする
      % X = obj.state.state_data(:,:,1:obj.N);       % 12 * 10 * N
      U = obj.input.u(:,:,1:obj.N);                % 4  * 10 * N
      %% Referenceの取得、ホライズンごと
      % Xd = repmat(obj.reference.xr, 1,1, obj.N); % z vz x vx ax jx ... に目標値を並べ替えただけ
%       Z = X;% - obj.state.ref(1:12,:);
      %% ホライズンごとに実際の誤差に変換する（リファレンス(1)の値からの誤差）
      % Xh = X + Xd(:, 1, :);
      %% 現在位置の目標値に収束
      % Z = Xd - Xh;
      % Z = X - Xd(1:12,:,:);

      %% 実状態との誤差
      Z = gpuArray(obj.state.error_data);

      % Z = X;

      %% ホライズンごとの誤差
      % Z = X;
      % for h = 2:obj.param.H-1
      %   Z(:,h,:) = Z(:,h,:) + Xd(1:12,1,:) - Xd(1:12,h,:);
      % end

      %% ホライズンで信頼度を下げる
      % k = linspace(1,0.1, obj.param.H-1);
      k = gpuArray(ones(1, obj.param.H-1));

      %% コスト計算
      tildeUpre = gpuArray(U - obj.input.v);          % agent.input 　前時刻入力との誤差
      tildeUref = gpuArray(U - obj.param.ref_input);  % 目標入力との誤差 0　との誤差

      %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      stageStateZ =    k .* Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,1:obj.N),Z(:,1:end-1,:));
      stageInputPre  = k .* tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,1:obj.N),tildeUpre(:,1:end-1,:));
      stageInputRef  = k .* tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,1:obj.N),tildeUref(:,1:end-1,:));

      %% pagefun
      % array_fun = @(Q, z) Q*z;
      % stageStateZ = k .* Z(:,1:end-1,:).*pagefun(array_fun, gpuArray(obj.Weight(:,:,1:obj.N)), gpuArray(Z(:,1:end-1,:)));

      %-- 状態の終端コストを計算 状態だけの終端コスト
      terminalState = sum(k .* Z(:,end,:).*pagemtimes(obj.Weight(:,:,1:obj.N),Z(:,end,:)),[1,2]);

      %-- 評価値計算
      Eval{1} = sum(sum(stageStateZ,[1,2]) + stageInputPre + stageInputRef + terminalState, [1,2]);  % 全体の評価値
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
