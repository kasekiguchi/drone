classdef HLMPC_controller_ToKiyama <CONTROLLER_CLASS
  % 階層型線形化モデルを使用可能な状態

  properties
    options
    param %パラメータ
    current_state %現在状態
    model %モデル
    result %mainに値戻す
    self %classの通例
  end
  properties %階層型線形化部分？
    modelf
    modelp
    F1
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
      obj.modelf = obj.self.model.method;
      obj.modelp = obj.self.parameter.get();
      %% HL
      obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.dt);
      obj.N = param.particle_num;
      % HL. A, B行列定義
      % z, x, y, yawの順番
      A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
      B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
      sysd = c2d(ss(A,B,eye(12),0),param.dt); % 離散化
      obj.A = sysd.A;
      obj.B = sysd.B;
    end

    %-- main()的な
    function result = do(obj,~)
      % profile on
      ref = obj.self.reference.result;
      xd = ref.state.get();
      if isprop(ref.state,'xd')
        if ~isempty(ref.state.xd)
          xd = ref.state.xd; % 20次元の目標値に対応するよう
        end
      end

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

      %-- 状態予測
      % fmincon で最適入力の算出(fmincon:指定された問題で最小値を見つける関数)
      options = optimoptions('fmincon');
      options.Algorithm = 'sqp'; %逐次二次計画法
      options.Display = 'none'; %計算結果の表示
      problem.solver = 'fmincon';
      problem.options = options;

      %-- 評価値計算
      obj.input.Evaluationtra =  obj.objective();

      vf = 1; % z仮想入力 fminconの出力に合わせた値
      vs = 1; % x y yaw 仮想入力
      tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P); % 実入力変換
      obj.result.input = tmp(:); % agent.inputへの代入

      result = obj.result; %mainへ値を返す
    end
    function show(obj)
      obj.result
    end

    %------------------------------------------------------
    %======================================================
    %評価関数
    function [MCeval] = objective(obj, ~)   % obj.~とする
        %% 各変数が違うのでそろえてください
        %% 勾配のほうの評価算出参考に書き換えて
      X = obj.state.state_data(:,:);       % 12 * 10
      U = obj.input.u(:,:);                % 4  * 10
      Z = X;

      tildeUpre = U - obj.input.v;          % agent.input 　前時刻入力との誤差
      tildeUref = U - obj.param.ref_input;  % 目標入力との誤差

      %-- 状態及び入力のステージコストを計算
      % arrayfun(@(), input, 1:H-1) は遅い
      stageStateZ = sum(Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,1:end-1,:)),[1,2]);%
      stageInputPre  = sum(tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
      stageInputRef  = sum(tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);

      %-- 状態の終端コストを計算 状態だけの終端コスト
      terminalState = sum(Z(:,end,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,end,:)),[1,2]);
      MCeval = stageStateZ + stageInputPre + stageInputRef + terminalState;  % 全体の評価値
    end
    
    %勾配で必要な関数(最適な入力がモデル的に妥当なものかを確認する制約)
    function [cineq, ceq] = constraints(obj,x, params)
            % モデル予測制御の制約条件を計算するプログラム
            cineq  = zeros(params.state_size, 4*params.H);
            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:end, :);
            
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
            %TEMP_predictX = cell2mat(arrayfun(@(N) ode45(@(t,x) params.model(x,U(:,N),params.model_param),[params.dt*(N-2) params.dt*(N-1)],X(:,N-1)),2:params.Num,'UniformOutput',false));
            %PredictX = cell2mat(arrayfun(@(L) TEMP_predictX(L).y(:,end),1:params.H,'UniformOutput',false));
            PredictX = X+obj.param.dt*obj.self.model.method(X,U,obj.param.model_param);
            ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  -  PredictX(:,L-1), 2:params.Num, 'UniformOutput', false))];
    end

  end
end
