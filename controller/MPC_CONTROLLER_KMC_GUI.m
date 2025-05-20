classdef MPC_CONTROLLER_KMC_GUI< handle
  % MCMPC_CONTROLLER MCMPCのコントローラー
  % the flow goes to 
  %
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
    sigma
  end
  properties
    % よく使うパラメータはobj.○○とする
    modelf
    modelp
    P % drone parameter
    N % 現時刻のパーティクル数
    H % horizon
    weight
    % Weight % ステージコストの重みQ
    % WeightF % 終端コストの重みQf
    % WeightR % 入力抑制項の重み
    % WeightRp % 前時刻入力との誤差項
    % Weightstl
    koopman
    % A % 制御モデルのA行列
    % B % 制御モデルのB行列
    % C % 制御モデルのC行列
    qpparam % 二次計画法QPのパラメータ
    previous_input % 前時刻入力
    
    gen_beq
    removeN
    survive
    removeX
    flag
    % mcflag %qp input mc flag
    % resampling_flag
    % stlhard_flag
    % reinputflag
    reinput
    reEva
    StageStateSTLsum
    STL_period = [2,4]
    quadH
    quadf
  end

  methods
    function obj = MPC_CONTROLLER_KMC_GUI(self, param)
      %-- 変数定義
      obj.self = self; % agent
      obj.param = param; % param = Controller_MPC_HLMC.mで設定したパラメーター
      obj.param.catchflag = 0;
      obj.flag.gpuflag = 1;
      %%flag defination
      obj.flag.mcflag = 1 ;%qp input mc flag| 0 = qpmpc; 1 = qpmpc+mc; 2=qpmpc+mc+stl;
      obj.flag.stlhard_flag = 0;% stl hard or soft  now it`s no sense
      obj.flag.resampling_flag = 0;% auto change when all samples are not satisfied
      obj.flag.reinputflag = 0; % uesd to go to resampling now it is not be used
      obj.flag.stl_flag = 0; % 1 means in stl period ;0 out
      %%
      
      obj.modelf = obj.self.plant.method;
      obj.P = obj.self.parameter.get(); % ドローンのパラメータ（質量，ロータ間距離，慣性モーメントなど）
      obj.N = param.particle_num; % サンプル数
      obj.H = param.H; % ホライズン
   
      % 重みの配列サイズ変換
      obj.weight = param.weight; % 重みを変数に保存
      obj.weight.stagestate = blkdiag(obj.weight.P, obj.weight.Q, obj.weight.V, obj.weight.W); % blkdiagで配列同士を結合
      obj.weight.terminalstate = blkdiag(obj.weight.Pf, obj.weight.Qf, obj.weight.Vf, obj.weight.Wf);
      obj.weight.input = param.weight.R;  % 目標入力
      obj.weight.preinputdif = param.weight.RP; % 前ステップとの入力
      obj.weight.weightstl = 10;
      % obj.param.Weightstl = blkdiag(obj.param.P,eye(9)); 
      % obj.param.P = param.weight.P;
      % obj.param.V = param.weight.V;    % 速度
      % obj.param.R = param.weight.R; % 入力
      % obj.param.RP = param.weight.RP;  % 1ステップ前の入力との差    0*(無効化)
      % obj.param.Q = param.weight.Q;  % 姿勢角
      % obj.param.W = param.weight.W;  % 角速度
      % obj.param.Pf = obj.param.P; % 6
      % obj.param.Vf = obj.param.V; % 6
      % obj.param.Qf = obj.param.Q; % 7,8
      % obj.param.Wf = obj.param.W;
      % obj.param.Weight = blkdiag(obj.param.P, obj.param.Q, obj.param.V, obj.param.W);  %total weight easy for calculate
      % obj.param.Weightf = blkdiag(obj.param.P, obj.param.Qf, obj.param.Vf, obj.param.Wf);%↑
      
      % 入力の初期化
      obj.result.input = obj.param.ref_input; % 目標入力 初期時刻にresultを定義しておかないと実行時にエラー出る
      obj.input = obj.param.input; %入力関連のみ
      obj.input.pre_u = repmat(obj.result.input,1,obj.H); % 前入力
      obj.input.var = repmat(obj.param.ref_input,obj.H,1);
      obj.result.Bestcost_STL = 0;
      obj.input.sigma = param.input.Initsigma; 
      % MPCパラメータ初期化 = メモリの確保
      obj.result.bestx(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.besty(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.bestz(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.state.state_data = zeros(obj.param.state_size,obj.H, obj.N);
      obj.result.Evaluationtra = zeros(obj.N, 2);
      obj.StageStateSTLsum = 0;
     obj.result.pre_u = obj.input.pre_u;
      % obj.input.mu = param.ref_input;
      
      % A, B行列定義 z, x, y, yawの順番ベクトル化 speical defination for koopman
      obj.koopman = param.koopman;
      C = repmat({obj.koopman.C}, 1, obj.H);
      obj.koopman.ExC = blkdiag(C{:});
     
      [obj.koopman.ExA,obj.koopman.ExB] = ExtendedCoefficientMatrix({obj.koopman.A,obj.koopman.B,obj.H,param.state_size}); % 一括計算 2025/1/21確認
      % obj.koopman.ExA = obj.model.A;
      % obj.koopman.ExB = obj.model.B;
        obj.flag.A = 0;
      obj.result.bestcost = obj.input.Bestcost_now;
    
      %% 勾配MPCとの併用を見据えてのQP(Quadratic Programming:二次計画法)の式変換
      %-- M2鬼澤がやっていたと思う
      % Q = reshape(obj.Weight(:,:,1), obj.param.state_size, []);
      % Qf = reshape(obj.WeightF(:,:,1), obj.param.state_size, []);
      % R = reshape(obj.WeightR(:,:,1), obj.param.input_size, []);
      % Param = struct('A',A,'B',B,'C',C,'weight',Q,'weightF',Qf,'weightR',R,'H',obj.param.H);
      % [obj.qpparam.H, obj.qpparam.F] = change_equation_HLMCMPC(Param);
    end

    %-- main()的な
    function result = do(obj,varargin)
     
      obj.result2input();
      time = varargin{1};
      phase = varargin{2};
      obj.param.t = time.t;
      
      obj.current_state = obj.self.estimator.result.state.get(); % 現在状態の取得
      %   obj.state.current = obj.param.F([obj.current_state;obj.input.mu(:,1,1)]);
      obj.state.current = obj.param.F([obj.current_state; obj.input.pre_u(:,1,1)]);
    
      %% phaseによるcontrollerの選択
      if phase == 'a' % arming
        obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input;0;0;0],1,obj.param.H);
        result = obj.controller_KMC(varargin);
        disp('controller: MC,  phase: a');
      elseif phase == 't' || phase == 'l' % takeoff | landing
        result = obj.controller_HL(varargin); % HLC: refはvararginに入っている
        disp('controller: HL  phase: t or l');
      elseif phase == 'f' % flight
       
        obj.state.ref = obj.generate_reference(); % vararginのrefをHorizonに拡張
        if   abs(obj.self.plant.state.p(3)-obj.state.ref(3))>0.05 %&& obj.flag.A == 0 && ~obj.flag.stl_flag 
            obj.param.catchflag = 1;
            obj.param.catchtime = 2;
            obj.self.reference.func =  gen_ref_for_HL(bezier_curve4([obj.self.plant.state.p(1:3)],obj.param));
             %obj.flag.A =1;
        end
        % result = obj.controller_HL(varargin);

        result = obj.controller_KMC(varargin);
        disp('controller: MC  phase: f');
        
      end
      show(obj);
    end

  

    function result = controller_KMC(obj,varargin)
      obj.param.t = varargin{1}{1}.t; % 現在時刻
      obj.param.te = varargin{1}{1}.te; % 終了時間(default : 10s)
      % obj.input.mu = obj.input.pre_u; % 採択入力を平均
      %% データ表示用  
      obj.QP_MPC();%qp
      %obj.input.u = obj.result.input; %%%%%%% use without qp->output+mc
      % obj.input.mu = obj.param.ref_input;%%%%
      % 目標入力
      if obj.flag.mcflag == 1%qp+mc
        % 状態予測
        % QP 出った結果を入力生成
        U =obj.generate_input(0,1);% d
        obj.predictmc(U);       %d
        obj.objectivemc(1,obj.H);           % 評価計算
        obj.normalize();        %d    % 評価値の正規化
        %obj.Resampling_LVS();%Low Variance Sampling
        obj.Resampling_IS();  % Important Samplingリサンプリング
        obj.get_input();  % 最適入力の取得および標準偏差のリサンプリング
        % obj.result.bestcostID = obj.input.BestcostID;

      elseif obj.flag.mcflag == 2%qp+mc+resampling+stl
        if obj.param.t >obj.STL_period(1) - obj.param.H*obj.param.dt && obj.param.t <obj.STL_period(2)
          %obj.removeX= find(any(squeeze(obj.state.state_data(1:2, 1:end-1, :))<0.0,[1,2]));
          %obj.removeN =size(obj.removeX,1);
          s = find((1:obj.H)*obj.param.dt + obj.param.t > obj.STL_period(1),1,"first");
          e = find((1:obj.H)*obj.param.dt + obj.param.t < obj.STL_period(2),1,"last");
          obj.flag.stl_flag = 1;
        else
          s = [];
          e = [];
          obj.flag.stl_flag = 0;
        end
        obj.predictmc(obj.input.var);
        STLOK = obj.STL(s,e);
        processStep(obj,0,s,e,STLOK);
        % obj.result.bestcostID = obj.input.BestcostID;
        

      end
      %% 値の保存　実験時は取り出す変数に気を付ける->ファイルサイズが大きくなりすぎる
        
       result = obj.result;
   
    end
   function result2input(obj)
        % obj.input.u = obj.result.input;
        % obj.input.var = obj.result.var;
        obj.input.pre_u = obj.result.pre_u;
    end
   
    function processStep(obj,resumping_num,s,e,STLOK)
      obj.flag.resampling_flag = 0;
      U = obj.generate_input(resumping_num,STLOK);
      obj.predictmc(U);
      STLOK = obj.STL(s,e);
      obj.objectivemc(s,e);
    
      obj.get_input();

      if obj.flag.resampling_flag && resumping_num < 10
        % obj.input.u=obj.reinput;
        % obj.result.Evaluationtra=obj.reEva;
        % obj.normalize();
        % obj.Resampling_HVS();
        % disp("goback to input...");
        processStep(obj,resumping_num+1,s,e,1);
      end
    end
    function U = generate_input(obj, num,STLOK)
      % ksigma_max = si * obj.H;
      if STLOK
        mu =  obj.input.var; % QP input
      else
        mu =  repmat(obj.param.ref_input,1,obj.H); % hovering input
      end


      ksigma_max = 1;
      ksigma = linspace(1, ksigma_max, obj.H); % 1~1+ksigma_maxまでH個の配列を作成
      %  inputSigma = ksigma .* obj.input.sigma;
      if obj.StageStateSTLsum == 0
        tempsigma =1;
      else
        esp=1e8;
        tempsigma = 1+3*(1-exp(-1*obj.StageStateSTLsum/esp));%%%%% 注意サンプ数に関わる
      end
      inputSigma =tempsigma .*obj.input.sigma;
      if obj.flag.resampling_flag
        mu=obj.input.pre_u;
      end
      if obj.result.Bestcost_STL > 0
         
        disp(obj.result.Bestcost_STL);
        sigma = [inputSigma(1)*min(min(10,1.2^num),max(1,1+obj.result.Bestcost_STL*1e-4));inputSigma(2:4)];
        
      else
        sigma = inputSigma;
      end
      % obj.input.u = randn(4,obj.H,obj.N) .* inputSigma + mu; % 制約なし
      % obj.input.u = max(-obj.input.input_TH(:), min(obj.input.input_TH(:), randn(4,obj.H,obj.N) .* inputSigma + mu)); 可変制約
      %%%%%%%% 4 x obj.H xobj.N
      if obj.flag.gpuflag == 0
        obj.input.u(1:4,1:obj.H,2:obj.N) = max(obj.param.input.lb, min(obj.param.input.ub, randn(4,obj.H,obj.N-1) .* sigma + reshape(mu,4,[])));
        obj.input.u(:,:,1) = reshape(obj.input.var,4,[]);
        obj.input.u(4,:,:) = 0;
      elseif obj.flag.gpuflag == 1
        mu_gpu     = gpuArray(reshape(mu, 4, []));
        sigma_gpu  = gpuArray(sigma);
        lb_gpu     = gpuArray(obj.param.input.lb);
        ub_gpu     = gpuArray(obj.param.input.ub);
        rand_input = randn(4, obj.H, obj.N-1, 'gpuArray');
        input_tmp  = max(lb_gpu, min(ub_gpu, rand_input .* sigma_gpu + mu_gpu));
        % obj.input.u = zeros(4, obj.H, obj.N, 'like', input_tmp);
        obj.input.u(1:4,1:obj.H,2:obj.N) = input_tmp;
        obj.input.u(:,:,1)       = gpuArray(reshape(obj.input.var, 4, []));
        obj.input.u(4,:,:)       = 0;
      end
      % 検証用
      if obj.param.test.input == 1
        obj.input.u(2:4,:,:) = zeros(3, obj.H, obj.N);
      elseif obj.param.test.input == 2
        % obj.input.u(1,:,:) = obj.param.ref_input(1) * ones(1, obj.H, obj.N);
        % obj.input.u(2,:,:) = zeros(1, obj.H, obj.N); obj.input.u(4,:,:) = zeros(1, obj.H, obj.N);
        obj.input.u(3,:,:) = zeros(1, obj.H, obj.N); obj.input.u(4,:,:) = zeros(1, obj.H, obj.N);
      end
      U = obj.input.u;
    end

    % 状態予測for mc
    function X = predictmc(obj,U)
      if obj.flag.gpuflag==0
        if obj.param.code  == '26'
            AX0 = obj.koopman.ExA*obj.param.F([obj.current_state;obj.param.ref_input]);
        else
            AX0 = obj.koopman.ExA*obj.param.F(obj.current_state);
        end
          N = size(U,3);
          AX = repmat(AX0, 1, 1, N);
    
          tmp_z = AX + pagemtimes(obj.koopman.ExB, reshape(U, [], 1, N)); % 予測計算 12*Hx1xN
          %tmp = pagemtimes(obj.param.C, tmp_z);
          % obj.state.state_data = reshape(tmp, obj.param.state_size, obj.H, obj.N);
          tmp = reshape(tmp_z,[],obj.H,N);
          obj.state.state_data = tmp(1:obj.param.state_size,:,:);
          X = obj.state.state_data;
      elseif  obj.flag.gpuflag==1
          U = gpuArray(U);
          N = size(U,3);
          if obj.param.code == '26'
              input_f = [obj.current_state; obj.param.ref_input];
          else
              input_f = obj.current_state;
          end
          AX0 = gpuArray(obj.koopman.ExA) * gpuArray(obj.param.F(input_f));
          AX = repmat(AX0,1,1,N);
          U_reshaped = reshape(U,[],1,N);
          tmp_z = AX + pagemtimes(gpuArray(obj.koopman.ExB), U_reshaped);
          tmp = reshape(tmp_z,[],obj.H,N);
          obj.state.state_data = tmp(1:obj.param.state_size,:,:);
          X = obj.state.state_data;

      end
    end
    function STLOK = STL(obj,s,e)
        
        obj.removeX= find(any(squeeze(obj.state.state_data(3, s:e, :))<0.5,1));
        obj.removeN =size(obj.removeX',1);
        obj.survive = obj.N-obj.removeN;
        
        if obj.survive == 0
          obj.flag.resampling_flag =1; 
          obj.flag.stlhard_flag =0;
        end
        STLOK = isempty(obj.removeX);
    end
    function objectivemc(obj,s,e)
      % U = reshape(obj.input.u,4*obj.H,obj.N);
      % tmpJ= sum(U.*(obj.quadH*U)/2 + obj.quadf.*U,1);
      %%   
      if obj.flag.gpuflag ==0
      U = obj.input.u;
      % obj.result.Evaluationtra =zeros(size(obj.input.u,3),2);
      obj.result.Evaluationtra =zeros(size(obj.input.u,3),2);
      X = obj.state.state_data;
      stlbase =obj.state.ref;
      stlbase(3,:)=0.5;
      %% ホライズンで重み大きく
      % k = linspace(1,obj.param.H/10, obj.param.H); % これにより制約はいるとき滑らかになる
      k = ones(1,obj.param.H);

      %% 誤差計算
      tildeUpre = U - obj.input.pre_u;          % 前時刻入力
      tildeUref = U - obj.state.ref(13:16,:);  % 目標入力
      tildeX = X - obj.state.ref(1:12,:);
      %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
      stageInputPre  = k .* tildeUpre.*pagemtimes(obj.weight.preinputdif,tildeUpre); % u'*R*u
      stageInputRef  = k .* tildeUref.*pagemtimes(obj.weight.input,tildeUref);

      %obj.Weight = blkdiag(obj.param.P, obj.param.Q, obj.param.V, obj.param.W);
      stageStateX =    k .* tildeX.*pagemtimes(obj.weight.stagestate,tildeX);
      terminalState = 0;
      % if obj.param.t > obj.STL_period(2)  % ???
      %   stageInputPre  =0 .*stageInputPre;
      %   stageInputRef =0 .*stageInputRef;
      % end
      if ~isempty(s) && obj.flag.mcflag == 2%obj.param.t >obj.STL_period(1)- obj.param.H*obj.param.dt && obj.param.t < obj.STL_period(2)
        tildeSTL = X(3,s:e,:) - stlbase(3,s:e);
        tildeSTL(tildeSTL > 0) = 0;
        StageStateSTL = reshape(sum(tildeSTL,2)*(-1e8),1,obj.N);
        % StageStateSTL =  sum(reshape(tildeSTL, obj.H, obj.N),1),;
        % StageStateSTL(StageStateSTL < 0) = StageStateSTL(StageStateSTL < 0) * -1e8;
        % if sum(StageStateSTL>0) > 0
        %   fprintf("Violate: %d", sum(StageStateSTL>0));
        % end

      else
        StageStateSTL = zeros(1,obj.N);
      end
      elseif obj.flag.gpuflag==1
          U = gpuArray(obj.input.u);
          obj.result.Evaluationtra = zeros(size(U,3),2,'gpuArray');
          X = gpuArray(obj.state.state_data);
          stlbase = gpuArray(obj.state.ref);
          stlbase(3,:) = 0.5;
          k = ones(1,obj.param.H,'gpuArray');
          tildeUpre = U - obj.input.pre_u;
          tildeUref = U - obj.state.ref(13:16,:);
          tildeX = X - obj.state.ref(1:12,:);
          stageInputPre = k .* tildeUpre .* pagemtimes(obj.weight.preinputdif,tildeUpre);
          stageInputRef = k .* tildeUref .* pagemtimes(obj.weight.input,tildeUref);
          stageStateX = k .* tildeX .* pagemtimes(obj.weight.stagestate,tildeX);
          terminalState = 0;
          if ~isempty(s) && obj.flag.mcflag == 2
              tildeSTL = X(3,s:e,:) - stlbase(3,s:e);
              tildeSTL(tildeSTL > 0) = 0;
              StageStateSTL = reshape(sum(tildeSTL,2)*(-1e8),1,obj.N);
          else
              StageStateSTL = zeros(1,obj.N,'gpuArray');
          end
      end
      %% 人工ポテンシャル場法
      % Jconst = Constraints(obj);
      % Jconst(:,1) = {zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N)};

      %% ステージコストとターミナルコストを合計
      % obj.StageStateSTLsum =sum(StageStateSTL);
  
      costX = stageStateX + terminalState;
      Jx = reshape(sum(costX, [1,2]),  size(obj.input.u,3), 1);
      Jref = reshape(sum(stageInputRef,[1,2]),  size(obj.input.u,3), 1);
      Jpre = reshape(sum(stageInputPre,[1,2]),  size(obj.input.u,3), 1);
      obj.result.Evaluationtra(:,1) = Jx + Jref + Jpre +StageStateSTL';
      obj.result.Evaluationtra(:,2) = Jref;
      obj.result.Evaluationtra(:,3) = StageStateSTL';

      %% 制約 STL
      % obj.constraints_STL(tildeX); % ???
      % if ~obj.reinputflag
      %   obj.reEva = obj.result.Evaluationtra(:,1) ;
      %   obj.reinput = obj.input.u;
      % end
    end

    function constraints_STL(obj, tildeX)% stl soft 
      % v1_min = 0.00;
      % v1_max = 0.15;
      % v2_min = 0.01;
      % v2_max = 0.05;
      % v1_weight = diag([1e2;1e2;1]);
      % v2_weight = diag([1e2;1e2;1]);
      p1=0.45;
      p2=0.55;
      p1_weight = 1e0;
      % v2_weight = diag([1e2;1e2;1]);
      pobs = tildeX(3,:,:);
      if obj.param.t >1 - obj.param.H*obj.param.dt && obj.param.t <3
        stageVobs = p1_weight.*((p1-pobs).^2+(pobs-p2).^2);
        obj.result.Evaluationtra(:,1) = obj.result.Evaluationtra(:,1) + sum(reshape(stageVobs, obj.H, []))';
        % stageVobs = pagemtimes(v1_weight,((v1_min-Vobs).^2+(Vobs-v1_max).^2));
        % V_step_sum = sum(stageVobs, 2);
        % V_final = sum(squeeze(V_step_sum), 1)';
        % obj.result.Evaluationtra(:,1) =obj.result.Evaluationtra(:,1)+V_final;
      end
      % if obj.param.t >4 && obj.param.t <7
      %     % stageVobs2 = v2_weight .*((v2_min-Vobs).^2+(Vobs-v2_max).^2);
      %     % obj.result.Evaluationtra(:,1) = obj.result.Evaluationtra(:,1) + sum(reshape(stageVobs2, obj.H, []))';
      %     stageVobs2 = pagemtimes(v2_weight,((v2_min-Vobs).^2+(Vobs-v2_max).^2));
      %     V_step_sum2 = sum(stageVobs2, 2);
      %     V_final2 = sum(squeeze(V_step_sum2), 1)';
      %     obj.result.Evaluationtra(:,1) =obj.result.Evaluationtra(:,1)+V_final2;
      % end
    end

    function normalize(obj)
      if obj.flag.gpuflag ==0
          NP = size(obj.input.u,3);
          pw = obj.result.Evaluationtra(:,1); % 全評価値に対してのほうが性能よさそう

          pw = exp(-pw);
          sumw = sum(pw);
          if sumw~=0
              pw = pw/sumw;%正規化
          else
              pw = zeros(1,NP)+1/NP;
          end
          obj.result.EvalNorm = pw;
      elseif obj.flag.gpuflag==1
          NP = size(obj.input.u,3);
          pw = gpuArray(obj.result.Evaluationtra(:,1));
          pw = exp(-pw);
          sumw = sum(pw);
          if sumw ~= 0
              pw = pw / sumw;
          else
              pw = ones(1, NP, 'gpuArray') / NP;
          end
          obj.result.EvalNorm = pw;
      end

    end

    function Resampling_LVS(obj)
      %RESAMPLING この関数の概要をここに記述
      % アルゴリズムはLow Variance Sampling
      NP = size(obj.input.u,3);   % サンプル数
      pw = obj.result.EvalNorm; % 正規化された評価値
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
        u1(1:end,ip)= [pu1(2:end,ind);pu1(end,ind)];%+noise_factor*randn(size(obj.input.u));%LVSで選ばれたパーティクルに置き換え
        u2(1:end,ip)= [pu2(2:end,ind);pu2(end,ind)];
        u3(1:end,ip)= [pu3(2:end,ind);pu3(end,ind)];
        u4(1:end,ip)= [pu4(2:end,ind);pu4(end,ind)];
        pw(ip)=1/NP;%尤度は初期化
      end
      obj.input.u(4, 1:obj.param.H, 1:obj.N) = u4;
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = u1;
      obj.flag.resampling_flag =0;
      obj.flag.reinputflag =0;
    end
    function Resampling_HVS(obj)
      %RESAMPLING この関数の概要をここに記述
      % アルゴリズムは Variance Sampling
      NP = size(obj.input.u,3);   % サンプル数
      pw = obj.input.EvalNorm; % 正規化された評価値
      u1 = reshape(obj.input.u(1,:,:), [], NP);
      u2 = reshape(obj.input.u(2,:,:), [], NP);
      u3 = reshape(obj.input.u(3,:,:), [], NP);
      u4 = reshape(obj.input.u(4,:,:), [], NP);
      eps = 1e-6;
      inv_pw = 1 ./ (pw + eps);
      inv_pw = inv_pw / sum(inv_pw);  % 標準化
      wcum = cumsum(inv_pw);  % 逆評価値を累積
      base = cumsum(inv_pw * 0 + 1 / NP) - 1 / NP;  % 乱数を加える前のbase
      resampleID = base + rand / NP;  % ルーレットに乱数を加えたID
      pu1 = u1;%データ格納用
      pu2 = u2;
      pu3 = u3;
      pu4 = u4;
      ind=1;%新しいID
      noise_factor = 0.3;
      for ip=1:NP
        while(resampleID(ip)>wcum(ind))
          ind=ind+1;
        end
        u1(1:end,ip)= [pu1(2:end,ind);pu1(end,ind)];%+[noise_factor*randn(size(pu1(2:end,ind)));pu1(end,ind)];%LVSで選ばれたパーティクルに置き換え
        u2(1:end,ip)= [pu2(2:end,ind);pu2(end,ind)];
        u3(1:end,ip)= [pu3(2:end,ind);pu3(end,ind)];
        u4(1:end,ip)= [pu4(2:end,ind);pu4(end,ind)];
        pw(ip)=1/NP;%尤度は初期化
      end
      obj.input.u(4, 1:obj.param.H, 1:obj.N) = u4;
      obj.input.u(3, 1:obj.param.H, 1:obj.N) = u3;
      obj.input.u(2, 1:obj.param.H, 1:obj.N) = u2;
      obj.input.u(1, 1:obj.param.H, 1:obj.N) = u1;
      obj.flag.resampling_flag =0;
      obj.flag.reinputflag =0;
    end
   
    function Resampling_IS(obj)
      % 重点サンプリング
      % NP = obj.N;
      % pw = obj.input.EvalNorm; % 正規化された評価値
      % u = obj.input.u;
      obj.input.mu = repmat(reshape(reshape(sum(obj.input.u.*reshape(obj.result.EvalNorm,1,1,[]),2), 4,obj.N)...
        ./ sum(obj.result.EvalNorm), 4, 1, obj.N), 1, obj.param.H, 1);
      obj.flag.resampling_flag =0;
    end

    function get_input(obj)
      STL_pass_ids = find(obj.result.Evaluationtra(:,3)==0);
      if isempty(STL_pass_ids)
        [Bestcost, BestcostID] = min(obj.result.Evaluationtra(:,3));
      else
        [Bestcost,BestcostID] = min(obj.result.Evaluationtra(STL_pass_ids,1));
        BestcostID = STL_pass_ids(BestcostID(1));
      end
      
      tmp = obj.input.u(:,1,BestcostID(1));
      %fprintf("ID: %d, \t, u = [%f, %f, %f, %f]\n",BestcostID,tmp);
      obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      % obj.result.input = tmp;
      % obj.input.pre_u = obj.result.input;
      obj.input.pre_u = obj.input.u(:,:,BestcostID(1));
       obj.result.pre_u = obj.input.pre_u;
      obj.result.Bestcost_pre = obj.result.bestcost;
      obj.result.bestcost = Bestcost;
      obj.result.Bestcost_STL = obj.result.Evaluationtra(BestcostID(1),3);
      obj.flag.reinputflag = 0;
      if obj.param.test.sigma ~= 1
        obj.input.sigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.bestcost(1)./obj.input.Bestcost_pre(1))));
      end
      % obj.input.input_TH = max(obj.param.input.range(:,2), min(obj.param.input.range(:,1), obj.input.input_TH .* (obj.input.Bestcost_now(1)./obj.input.Bestcost_pre(1))'));
      obj.result.BestcostID = BestcostID(1);
    end
 
    %% 目標軌道生成
    function [xr] = generate_reference(obj)
        xr = zeros(obj.param.total_size, obj.H);    % initialize
        % 時間関数の取得→時間を代入してリファレンス生成
           
        RefTime = obj.self.reference.func;    % 時間関数の取得
      for h = 0:obj.H-1
        t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
        ref = RefTime(t);
        xr(1:3, h+1) = ref(1:3);
        xr(7:9, h+1) = ref(5:7);
        xr(4:6, h+1) =   [0;0;ref(4)]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = obj.param.ref_input(:,1); % MC -> 0.6597,   HL -> 0
      end
    end
    function QP_MPC(obj)
        n = size(obj.state.current,1); % number of observables
      %qp def
      Q = blkdiag(kron(eye(obj.param.H-1),blkdiag(obj.weight.stagestate,0*eye(n-12))),blkdiag(obj.weight.terminalstate,0*eye(n-12)));
      R = kron(eye(obj.param.H),obj.weight.input);
      RP = kron(eye(obj.param.H),obj.weight.preinputdif);
      Xr = reshape([obj.state.ref(1:12,:);zeros(n-12,obj.param.H)],[],1);
      Ur = reshape(obj.state.ref(13:16,:),[],1);
      [obj.quadH,obj.quadf]=obj.gen_Hf(obj.koopman.ExA,obj.koopman.ExB,obj.state.current,Q,R,RP,Xr,Ur,obj.input.var);
      %qp
      A = []; b = [];
      Aeq = []; beq = [];
      lb = repmat(obj.param.input_min,1,obj.param.H);
      ub = repmat(obj.param.input_max,1,obj.param.H);
      obj.options = optimset('Display', 'off');
      [var,fval,eflag,~,~] = quadprog(obj.quadH,obj.quadf,A,b,Aeq,beq,lb,ub,[],obj.options);
      var(4*(1:obj.H))= 0;
      % fval
      obj.result.input =var(1:4, 1); % 算出された入力
      obj.result.eflag = eflag;
      obj.result.var = var;
      obj.result.Bestcost_pre = obj.result.bestcost;
      obj.result.bestcost = [fval;0];
      % obj.result.bestcost=obj.input.Bestcost_now ;
    end
    function fmincon_mpc(obj)
        %%fmincon
      obj.previous_input = repmat(obj.input.pre_u, 1, obj.param.H);%qp-mpc
      obj.options = optimoptions('fmincon');
      obj.options = optimoptions(obj.options,'MaxIterations',1.e+12); % 最大反復回数
      obj.options = optimoptions(obj.options,'ConstraintTolerance',1.e-4);     % 制約違反に対する許容誤差

      obj.options.Algorithm = 'sqp';  % 逐次二次計画法
      obj.options.Display = 'none';   % 計算結果の表示

      % conditions
      fun = @obj.objectivefmincon;
      % x0 = obj.previous_input;
      x0 = obj.input.var;
      A = []; b = [];
      Aeq = []; beq = [];
      lb = repmat(obj.param.input_min, 1,obj.param.H); % min
      ub = repmat(obj.param.input_max, 1,obj.param.H); % max
      nonlcon = [];
      [var, fval, eflag, ~, ~, ~, ~] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,obj.options);
      var(4*(1:obj.H))= 0;
      % fval
      obj.result.input =var(1:4, 1); % 算出された入力
      obj.result.eflag = eflag;
      obj.result.var = var;
      obj.result.Bestcost_pre = obj.result.bestcost;
      obj.result.bestcost = [fval;0];
      % obj.result.bestcost=obj.input.Bestcost_now ;
    end
    function [eval] = objectivefmincon(obj,x)   % obj.~とする
      % x(4*(1:obj.H)) = 0;
      U = reshape(x,4,[]);
      % X(:,1) = obj.current_state;
      % for L = 2:obj.param.H
      % X(:,L) = X(:,L-1) + obj.param.dt *obj.modelf(X(:,L-1),U(:,L-1), obj.P);
      % end
      n = size(obj.state.current,1); % number of observables
      X = obj.koopman.ExA*obj.state.current + obj.koopman.ExB*x;
      ids = [1:12]' + n*(0:obj.param.H-1);
      % tildeX = X(ids) - obj.state.ref(1:12,:);
      tildeX = reshape(X,n,[]) - [obj.state.ref(1:12,:);zeros(n-12,obj.param.H)];
      tildeUpre = U - reshape(obj.input.var,4,[]);
      tildeUref = U - obj.state.ref(13:16,:);

      stageState = tildeX(:,1:end-1)' * blkdiag(obj.weight.stagestate,0*eye(n-12))    * tildeX(:,1:end-1);
      stageInputPre  = tildeUpre(:,1:end-1)' * obj.weight.refinputdif * tildeUpre(:,1:end-1);
      stageInputRef  = tildeUref(:,1:end-1)' * obj.weight.input  * tildeUref(:,1:end-1);
      terminalState = tildeX(1:12,end)' * obj.weight.terminalstate * tildeX(1:12,end);

      eval = trace(stageState + stageInputPre + stageInputRef) + terminalState;
    end
    function [H,f] = gen_Hf(obj,A,B,x0,Q,R,Rp,Xr,Ur,Up)
      % calc H and f matrices for quadprog
      % x0: current state
      % Xn = A*x0+B*U % prediction in horizon
      % dX = Xn-Xr
      % dX'*Q*dX = U'*B'*Q*B*U + 2(A*x0-Xr)'*Q*B*U + (x0'*x0 term)
      % dU = U - Ur
      % dU'*R*dU = U'*R*U - 2*Ur*R*U
      % dpU = U - Up
      % U'*Rp*U - 2*Up*Rp*U

      H = 2*(B'*Q*B+R+Rp);
      H = (H+H')/2;
      f = (2*(A*x0 - Xr)'*Q*B - 2*Ur'*R - 2*Up'*Rp)';

    end

      function result = controller_HL(obj,varargin) % HLCそのままもってきた．もしアップデートされたら逐次更新
      model = obj.self.estimator.result;
      ref = obj.self.reference.result;
      xd = ref.state.xd;
      xd0 =xd;
      P = obj.P;
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
      end
      vf = Vfd(dt,x,xd',P,F1);
      vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
      tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
      % max,min are applied for the safty
      obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      %obj.result.bestcost = obj.result.Bestcost_now;
      result = obj.result;
      end
      
       function show(obj)
      % clc;
      % est_print = obj.self.estimator.result.state;
      est_print = obj.self.plant.state;
      fprintf("==================================================================\n")
      fprintf("==================================================================\n")
      fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
        est_print.p(1), est_print.p(2), est_print.p(3),...
        est_print.v(1), est_print.v(2), est_print.v(3),...
        est_print.q(1), est_print.q(2), est_print.q(3)); % s:state 現在状態
      % fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
      %   obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
      %   obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
      %   0, 0, obj.state.ref(6,1))                             % r:reference 目標状態
      % fprintf("t: %f \t input: %f %f %f %f \t J: %f \t sigma: %f", ...
      %   obj.param.t, obj.result.input(1), obj.result.input(2), obj.result.input(3), obj.result.input(4), obj.result.bestcost(1),obj.input.sigma(1));
      % fprintf("\n");
    end
  end
end
