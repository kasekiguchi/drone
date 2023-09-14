classdef HLMCMPC_controller_mex <CONTROLLER_CLASS
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

  properties
      mex_input
      mex_state
      mex_param
      mex_A
      mex_B
      mex_N
  end

  methods
    function obj = HLMCMPC_controller_mex(self, param)
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
      % profile on
    
      xr = param{2};
      rt = param{3};
%       obj.input.InputV = param{5};
      obj.state.ref = xr;
      obj.param.t = rt;
      idx = round(rt/obj.self.model.dt+1);

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
      obj.reference.xd_imagine = [xr(1:3,:); zeros(1,obj.param.H); xr(7:9,:); zeros(1,obj.param.H);zeros(24, obj.param.H)]; % 実状態を仮想状態に合わせた形で抜き取る
      % xr_imagine = 
      % Rb0 = 1;
      xr_imagine(1:3,:)=Rb0'*obj.reference.xd_imagine(1:3,:);
      xr_imagine(4,:) = zeros(1,obj.param.H);
      xr_imagine(5:7,:)=Rb0'*obj.reference.xd_imagine(5:7,:);
      xr_imagine(9:11,:)=Rb0'*obj.reference.xd_imagine(9:11,:);
      xr_imagine(13:15,:)=Rb0'*obj.reference.xd_imagine(13:15,:);
      xr_imagine(17:19,:)=Rb0'*obj.reference.xd_imagine(17:19,:);
      obj.reference.xr_org = [xr_imagine(3,:);xr_imagine(7,:);xr_imagine(1,:);xr_imagine(5,:);xr_imagine(9,:);xr_imagine(13,:);xr_imagine(2,:);xr_imagine(6,:);xr_imagine(10,:);xr_imagine(14,:);xr_imagine(4,:);xr_imagine(8,:)];
      obj.reference.xr = obj.reference.xr_org(:,1) - obj.reference.xr_org;

      % 標準偏差，サンプル数の更新
      obj.input.sigma = obj.input.nextsigma;
      obj.N = obj.param.nextparticle_num;

      % OBJ.input = obj.input;

      %% MEX
      % OBJ.input.u1 = OBJ.input.sigma(1).*randn(obj.param.H, OBJ.N) + ave(1); 
      % OBJ.input.u2 = OBJ.input.sigma(2).*randn(obj.param.H, OBJ.N) + ave(2);
      % OBJ.input.u3 = OBJ.input.sigma(3).*randn(obj.param.H, OBJ.N) + ave(3);
      % OBJ.input.u4 = OBJ.input.sigma(4).*randn(obj.param.H, OBJ.N) + ave(4);
      % OBJ.input.u = obj.input.u;
      OBJ.state.state_data = obj.state.state_data; %OBJ.state.real_data = obj.state.real_data;
      % OBJ.state.error_data = obj.state.error_data;
      OBJ.reference.xr_org = obj.reference.xr_org;
      OBJ.param.H = obj.param.H;
      OBJ.input.sigma = obj.input.sigma; OBJ.input.v = obj.input.v;
      OBJ.input.ref_input = obj.param.ref_input;
      OBJ.current_state = obj.current_state;
      OBJ.A = obj.A; OBJ.B = obj.B; OBJ.N = obj.N;
      OBJ.Weight = obj.Weight; OBJ.WeightR = obj.WeightR; OBJ.WeightRp = obj.WeightRp;

      % 入力生成から評価値算出まで
      contResult = input2eval(OBJ);
      obj.input.Evaluationtra = contResult.eval;
      obj.state = contResult.state;
      obj.input.u = contResult.input.u;

      %-- 制約条件
      removeF = 0; removeX = []; survive = obj.N;
      % [removeF, removeX, survive] = obj.constraints();
      obj.state.COG.g = 0; obj.state.COG.gc = 0;
        
      
      if removeF ~= obj.N
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        % トルク入力にしたらそれぞれの最適入力をとる必要あり？
        vf = obj.input.u(1, 1, BestcostID(2));     % 最適な入力の取得
        vs(1) = obj.input.u(2, 1, BestcostID(3));     % 最適な入力の取得
        vs(2) = obj.input.u(3, 1, BestcostID(4));
        vs(3) = obj.input.u(4, 1, BestcostID(5));
        vs = vs';
        % GUI共通プログラムから トルク入力の変換のつもり
        tmp = Uf_GUI(xn,xd',vf,P) + Us_GUI(xn,xd',[vf,0,0],vs(:),P); 

        % tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P); 
        
        
        % yaw入力の削除
        % tmp(4) = 0;

        % obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4)]; % トルク入力への変換

        % obj.result.input = [0.269*9.81; tmp(2); tmp(3); 0];
        obj.self.input = obj.result.input;  % agent.inputへの代入

        obj.result.v = [vf; vs];
        OBJ.input.v = obj.result.v;

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
        Bestcost = ones(1,5) .* obj.param.ConstEval;
        BestcostID = ones(1,5);
        obj.input.AllRemove = 1;

        % 追加
        obj.param.nextparticle_num = obj.param.Maxparticle_num;
      end

      obj.input.u = obj.input.v;

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
      obj.result.Evaluationtra_norm = [];
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
      constX = find(x_real(3,end,:) > 1.5);
      % CX = reshape(obj.param.const * abs(obj.state.state_data(6, end, constX)).^2, [1, length(constX)]);
      obj.input.Evaluationtra(constX,1) = obj.param.ConstEval; 

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

    %%-- 連続；オイラー近似
%     function [predict_state] = predict(obj)
%       u = obj.input.u;
%       obj.state.state_data(:,1,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % サンプル数分初期値を作成
% %       obj.state.initial(:,:,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % 12 * obj.param.H * obj.N
%       for i = 1:obj.param.H-1
%         obj.state.state_data(:,i+1,1:obj.N) = pagemtimes(obj.A(:,:,1:obj.N),obj.state.state_data(:,i,1:obj.N)) + pagemtimes(obj.B(:,:,1:obj.N),u(:,i,1:obj.N));
%       end
%       predict_state = obj.state.state_data;
%     end

    %------------------------------------------------------
    %======================================================
    function [MCeval] = objective(obj, ~)   % obj.~とする
      X = obj.state.state_data(:,:,1:obj.N);       % 12 * 10 * N
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
      Z = obj.state.error_data;

      % Z = X;

      %% ホライズンごとの誤差
      % Z = X;
      % for h = 2:obj.param.H-1
      %   Z(:,h,:) = Z(:,h,:) + Xd(1:12,1,:) - Xd(1:12,h,:);
      % end

      %% ホライズンで信頼度を下げる
      % k = linspace(1,0.1, obj.param.H-1);
      k = ones(1, obj.param.H-1);

      %% コスト計算
      tildeUpre = U - obj.input.v;          % agent.input 　前時刻入力との誤差
      tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

      %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      % stageStateZ = sum(k .* Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,1:end-1,:)),[1,2]);%
      % stageInputPre  = sum(k .* tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
      % stageInputRef  = sum(k .* tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);
      stageStateZ = k .* Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,1:obj.N),Z(:,1:end-1,:));
      stageInputPre  = k .* tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,1:obj.N),tildeUpre(:,1:end-1,:));
      stageInputRef  = k .* tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,1:obj.N),tildeUref(:,1:end-1,:));

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

    function xd = ControllerReference(obj)
    %REFERENCE この関数の概要をここに記述
    %   詳細説明をここに記述
        xd = zeros(12, obj.param.H);
        RefTime = obj.self.reference.timeVarying.func;    % 時間関数の取得
        for h = 0:obj.param.H-1
    %         t = obj.param.t + obj.param.dt * h;
            Ref = RefTime(obj.param.t + obj.param.dt * h);
            xd(1:2, h+1) = [Ref(3); Ref(7)];
            xd(3:6, h+1) = [Ref(1); Ref(5); Ref(9); Ref(13)];
            xd(7:10,h+1) = [Ref(2); Ref(6); Ref(10);Ref(14)];
            xd(11:12,h+1)= [Ref(4); Ref(8)];
            %% 単純に　Ref　から対象を抽出する % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
            % z dz           3 7
            % x dx ddx dddx  1 5 9 13
            % y dy ddy dddy  2 6 10 14
            % yaw dyaw       4 8 
        end
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
