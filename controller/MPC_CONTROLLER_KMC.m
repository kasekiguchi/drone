classdef MPC_CONTROLLER_KMC < handle
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
    P % drone parameter
    N % 現時刻のパーティクル数
    H % horizon
    Weight % ステージコストの重みQ
    WeightF % 終端コストの重みQf
    WeightR % 入力抑制項の重み
    WeightRp % 前時刻入力との誤差項
    A % 制御モデルのA行列
    B % 制御モデルのB行列
    C % 制御モデルのC行列
    qpparam % 二次計画法QPのパラメータ
    previous_input % 前時刻入力
  end

  methods
    function obj = MPC_CONTROLLER_KMC(self, param)
      %-- 変数定義
      obj.self = self; % agent
      obj.param = param; % param = Controller_MPC_HLMC.mで設定したパラメーター
      n = 12; % 状態数
      obj.input = param.input; %入力関連のみ
      
      obj.P = obj.self.parameter.get(); % ドローンのパラメータ（質量，ロータ間距離，慣性モーメントなど）
      obj.N = param.particle_num; % サンプル数
      obj.H = param.H; % ホライズン
      
      % 重みの配列サイズ変換
      weight = param.weight; % 重みを変数に保存
      obj.Weight = blkdiag(weight.P, weight.Q, weight.V, weight.W); % blkdiagで配列同士を結合
      obj.WeightF = blkdiag(weight.Pf, weight.Qf, weight.Vf, weight.Wf);
      obj.WeightR = weight.R;  % 目標入力
      obj.WeightRp = weight.RP; % 前ステップとの入力

      % MPCパラメータ初期化 = メモリの確保
      obj.result.bestx(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.besty(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.result.bestz(1, :) = repmat(obj.input.Bestcost_now(1), obj.param.H, 1); % - 制約外は前の評価値を引き継ぐ
      obj.state.state_data = zeros(n,obj.H, obj.N); 
      obj.input.Evaluationtra = zeros(obj.N, 2);
      obj.input.sigma = param.input.Initsigma;
      obj.input.mu = param.ref_input;

      % 入力の初期化
      obj.result.input = obj.param.ref_input; % 目標入力 初期時刻にresultを定義しておかないと実行時にエラー出る
      obj.input.pre_u = obj.result.input; % 前入力

      % A, B行列定義 z, x, y, yawの順番ベクトル化
      obj.model = ExtendedCoefficientMatrix({param.A,param.B,obj.H,param.state_size}); % 一括計算 2025/1/21確認
      obj.param.A = obj.model.A;
      obj.param.B = obj.model.B;
      C = repmat({obj.param.C}, 1, obj.H); 
      obj.param.C = blkdiag(C{:});

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
        time = varargin{1};
        phase = varargin{2};
        obj.param.t = time.t;
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
            result = obj.controller_KMC(varargin);
            disp('controller: MC  phase: f');
        end 
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
        result = obj.result;
    end

    function result = controller_KMC(obj,varargin)
      obj.param.t = varargin{1}{1}.t; % 現在時刻
      obj.param.te = varargin{1}{1}.te; % 終了時間(default : 10s)

      obj.current_state = obj.self.estimator.result.state.get(); % 現在状態の取得

      % obj.input.mu = obj.input.pre_u; % 採択入力を平均
      obj.input.mu = obj.param.ref_input; % 目標入力
      obj.generate_input(0.1);  % 入力生成
      obj.predict();            % 状態予測
      obj.objective();          % 評価計算
      obj.normalize();          % 評価値の正規化
      obj.Resampling_IS();      % リサンプリング
      obj.get_input();          % 最適入力の取得および標準偏差のリサンプリング

      %% 値の保存　実験時は取り出す変数に気を付ける->ファイルサイズが大きくなりすぎる
      obj.result.bestcostID = obj.input.BestcostID;
      obj.result.bestcost = obj.input.Bestcost_now;
      obj.result.sigma = obj.input.sigma;
      obj.result.Evaluationtra = obj.input.Evaluationtra;
      obj.result.path = [repmat(obj.current_state, 1,1,obj.N), obj.state.state_data];
      %%
      result = obj.result;
    end

    function show(obj)
        % clc;
        est_print = obj.self.estimator.result.state;
        fprintf("==================================================================\n")
        fprintf("==================================================================\n")
        fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
            est_print.p(1), est_print.p(2), est_print.p(3),...
            est_print.v(1), est_print.v(2), est_print.v(3),...
            est_print.q(1)*180/pi, est_print.q(2)*180/pi, est_print.q(3)*180/pi); % s:state 現在状態
        fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
            obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
            obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
            0, 0, obj.state.ref(6,1))                             % r:reference 目標状態
        fprintf("t: %f \t input: %f %f %f %f \t J: %f \t Ju: %f \t sigma: %f", ...
            obj.param.t, obj.result.input(1), obj.result.input(2), obj.result.input(3), obj.result.input(4), obj.result.bestcost(1), obj.result.bestcost(2), obj.input.sigma(1));
        fprintf("\n");
    end

    function generate_input(obj, si)
        % ksigma_max = si * obj.H;
        ksigma_max = 1;
        ksigma = linspace(1, ksigma_max, obj.H); % 1~1+ksigma_maxまでH個の配列を作成
        inputSigma = ksigma .* obj.input.sigma;

        % obj.input.u = randn(4,obj.H,obj.N) .* inputSigma + obj.input.mu; % 制約なし
        % obj.input.u = max(-obj.input.input_TH(:), min(obj.input.input_TH(:), randn(4,obj.H,obj.N) .* inputSigma + obj.input.mu)); 可変制約
        obj.input.u = max(obj.param.input.lb, min(obj.param.input.ub, randn(4,obj.H,obj.N) .* inputSigma + obj.input.mu));
    
        % 検証用
        if obj.param.test.input == 1
            obj.input.u(2:4,:,:) = zeros(3, obj.H, obj.N);
        elseif obj.param.test.input == 2
            % obj.input.u(1,:,:) = obj.param.ref_input(1) * ones(1, obj.H, obj.N); 
            % obj.input.u(2,:,:) = zeros(1, obj.H, obj.N); obj.input.u(4,:,:) = zeros(1, obj.H, obj.N);
            obj.input.u(3,:,:) = zeros(1, obj.H, obj.N); obj.input.u(4,:,:) = zeros(1, obj.H, obj.N);
        end
    end

    %% 状態予測
    function predict(obj)
        current = repmat(obj.param.F(obj.current_state), 1, 1, obj.N);
        tmp_z = pagemtimes(obj.param.A, current) + pagemtimes(obj.param.B, reshape(obj.input.u, [], 1, obj.N)); % 予測計算 12*Hx1xN
        tmp = pagemtimes(obj.param.C, tmp_z);
        obj.state.state_data = reshape(tmp, obj.param.state_size, obj.H, obj.N);
    end

    function objective(obj)
        U = obj.input.u;
        X = obj.state.state_data;

        %% ホライズンで重み大きく
        k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
        % k = ones(1, obj.param.H);

        %% 誤差計算
        tildeUpre = U - obj.input.pre_u;          % 前時刻入力
        tildeUref = U - obj.state.ref(13:16,:);  % 目標入力
        tildeX = X - obj.state.ref(1:12,:);

        %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
        stageInputPre  = k .* tildeUpre.*pagemtimes(obj.WeightR,tildeUpre);
        stageInputRef  = k .* tildeUref.*pagemtimes(obj.WeightRp,tildeUref);

        stageStateX =    k .* tildeX.*pagemtimes(obj.Weight,tildeX);
        terminalState = 0;

        %% 人工ポテンシャル場法
        % Jconst = Constraints(obj);
        % Jconst(:,1) = {zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N)};
        
        %% ステージコストとターミナルコストを合計
        costX = stageStateX + terminalState;

        obj.input.Evaluationtra(:,1) = reshape(sum(costX, [1,2]) + sum(stageInputPre,[1,2]) + sum(stageInputRef,[1,2]), obj.N, 1);
        obj.input.Evaluationtra(:,2) = reshape(sum(stageInputRef,[1,2]), obj.N, 1);
    
        %% 制約 STL
        % obj.constraints_STL(tildeX);
    end

    function constraints_STL(obj, tildeX)
        v1_min = 0.02;
        v1_max = 0.02;
        v2_min = 0.01;
        v2_max = 0.01;
        v1_weight = 1e4;
        v2_weight = 1e4;
        Vobs = tildeX(9,:,:);
        if obj.param.t >1 && obj.param.t <3 
            stageVobs = v1_weight.* ((v1_min-Vobs).^2+(Vobs-v1_max).^2);
            obj.input.Evaluationtra(:,1) = obj.input.Evaluationtra(:,1) + sum(reshape(stageVobs, obj.H, []))';
        end
        if obj.param.t > 5 && obj.param.t <7 
            stageVobs2 = v2_weight .*((v2_min-Vobs).^2+(Vobs-v2_max).^2);
            obj.input.Evaluationtra(:,1) = obj.input.Evaluationtra(:,1) + sum(reshape(stageVobs2, obj.H, []))';
        end
    end

    function normalize(obj)
      NP = obj.N;
      pw = obj.input.Evaluationtra(:,1); % 全評価値に対してのほうが性能よさそう
    
      pw = exp(-pw);
      sumw = sum(pw);
      if sumw~=0
        pw = (pw/sum(pw))';%正規化
      else
        pw = zeros(1,NP)+1/NP;
      end
      obj.input.EvalNorm = pw;
    end

    function Resampling_LVS(obj)
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
        obj.input.mu(4, 1:obj.param.H, 1:obj.N) = u4;
        obj.input.mu(3, 1:obj.param.H, 1:obj.N) = u3;
        obj.input.mu(2, 1:obj.param.H, 1:obj.N) = u2;
        obj.input.mu(1, 1:obj.param.H, 1:obj.N) = u1;
    end

    function Resampling_IS(obj)
        % 重点サンプリング
        % NP = obj.N;
        % pw = obj.input.EvalNorm; % 正規化された評価値
        % u = obj.input.u;

        obj.input.mu = repmat(reshape(reshape(sum(obj.input.u.*reshape(obj.input.EvalNorm,1,1,[]),2), 4,obj.N)...
            ./ sum(obj.input.EvalNorm), 4, 1, obj.N), 1, obj.param.H, 1);
    end

    function get_input(obj)
        [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
        tmp = obj.input.u(:,1,BestcostID(1));

        obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        obj.input.pre_u = obj.result.input;

        obj.input.Bestcost_pre = obj.input.Bestcost_now;
        obj.input.Bestcost_now = Bestcost;

        if obj.param.test.sigma ~= 1
            obj.input.sigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now(1)./obj.input.Bestcost_pre(1))));
        end
        % obj.input.input_TH = max(obj.param.input.range(:,2), min(obj.param.input.range(:,1), obj.input.input_TH .* (obj.input.Bestcost_now(1)./obj.input.Bestcost_pre(1))'));
        obj.input.BestcostID = BestcostID;
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
            xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
        end
    end
  end
end
