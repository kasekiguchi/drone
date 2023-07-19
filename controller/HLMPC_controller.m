classdef HLMPC_controller <handle
    % MCMPC_CONTROLLER MCMPCのコントローラー

    properties
%         options
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
        Weight
        WeightF
        WeightR
        WeightRp
        A
        B
        mpc
    end

    methods
        function obj = HLMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            %             obj.param.subCheck = zeros(obj.N, 1);
            % obj.param.modelparam.modelparam = obj.self.parameter.get();
            % obj.param.modelparam.modelmethod = obj.self.plant.method;
            % obj.param.modelparam.modelsolver = obj.self.plant.solver;
            obj.modelf = obj.self.plant.method;
            obj.modelp = obj.self.parameter.get();

            %%
            obj.input = obj.param.input;
            % obj.const = param.const;
            obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
            obj.param.H = obj.param.H + 1;
            obj.model = self.plant;
            obj.param.fRemove = 0;

            %% HL
            obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.param.dt);
            n = 12; % 状態数
            % 重みの配列サイズ変換
            obj.Weight = blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI);
            obj.WeightF = blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf);
            obj.WeightR = obj.param.R;  % 目標入力
            obj.WeightRp = obj.param.RP; % 前ステップとの入力
            % HL. A, B行列定義
            % z, x, y, yawの順番
            A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
            B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
            sysd = c2d(ss(A,B,eye(12),0),param.param.dt); % 離散化
            obj.A = sysd.A;
            obj.B = sysd.B;
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1);
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            obj.param.t = varargin{1}.t;
            idx = obj.param.t/obj.param.dt+1;
%             xr = obj.Reference();

            %% HL 5/18 削除------------------------------------------------------------------------------------------------------------------------
            ref = obj.self.reference.result;
            xd = ref.state.get();
            if isprop(ref.state,'xd')
                if ~isempty(ref.state.xd)
                    xd = ref.state.xd; % 20次元の目標値に対応するよう
                end
            end
            %
            %% Reference function
            % xd = [xr(1:3)'; 0; xr(7:9)'; 0];

            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
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
            obj.reference.xr = obj.Reference(); % 12 * obj.param.H 仮想状態 * ホライズン

            if idx == 1
                initial_u1 = 0;   % 初期値
                initial_u2 = initial_u1;
                initial_u3 = initial_u1;
                initial_u4 = initial_u1;
            else
                initial_u1 = obj.input.u(1);
                initial_u2 = obj.input.u(2);
                initial_u3 = obj.input.u(3);
                initial_u4 = obj.input.u(4);
            end
            u0 = [initial_u1; initial_u2; initial_u3; initial_u4];% 初期値＝入力
%             x = obj.self.estimator.result.state.get();
            previous_state = repmat([obj.current_state; u0], 1, obj.param.H);
            % previous_state の1行目

            %                 previous_state(Params.state_size+1:Params.total_size, 1:Params.H) = repmat(x0, 1, Params.H);

            % MPC設定(problem)
            %-- fmincon 設定
            options = optimoptions('fmincon');
            %     options = optimoptions(options,'Diagnostics','off');
            %     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
            options = optimoptions(options,'MaxIterations',         1.e+9);     % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-4);%制約違反に対する許容誤差
            
            %-- fmincon設定
            options.Algorithm = 'sqp';  % 逐次二次計画法
            options.Display = 'none';   % 計算結果の表示
            problem.solver = 'fmincon'; % solver
            problem.options = options;  %

            obj_HL.input = obj.input.u;
            obj_HL.reference = obj.reference.xr;
            objHLrefinput = obj.param.ref_input;
            obj_HL.Weight = obj.Weight;
            obj_HL.WeightRp = obj.WeightRp;
            obj_HL.WeightR = obj.WeightR;

            objHL_const.H = obj.param.H;
            objHL_const.A = obj.A;
            objHL_const.B = obj.B;
            objHL_const.current_state = obj.current_state;
            obj.reference.state_xd = [xd(3);xd(7);xd(1);xd(5);xd(9);xd(13);xd(2);xd(6);xd(10);xd(14);xd(4);xd(8)]; % 実状態における目標値

            problem.x0		  = previous_state;                 % 状態，入力を初期値とする                                    % 現在状態
            % problem.objective = @(x) objective_HL_mex(obj_HL, x, objHLrefinput);            % 評価関数
            % problem.nonlcon   = @(x) constraints_HL_mex(objHL_const, x);          % 制約条件

            problem.objective = @(x) obj.objective(x); 
            problem.nonlcon   = @(x) obj.constraints(x);
            [var, ~, ~] = fmincon(problem);
            % 制御入力の決定
%             previous_state = var;   % 初期値の書き換え

            %TODO: 1列目のvarが一切変動しない問題に対処
            % if var(Params.state_size+1:Params.total_size, end) > 1.0
            %     var(Params.state_size+1:Params.total_size, end) = 1.0 * ones(4, 1);
            % end
            
            % obj.input.u = var(13:16, 1);
            vf = var(13, 1);     % 最適な入力の取得
            vs = var(14:16, 1);     % 最適な入力の取得
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);  % 入力変換
            obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
%             obj.self.input = obj.result.input;  % agent.inputへの代入
            obj.input.u = obj.result.input;

            % 座標として軌跡を保存するため　x = xd + state
            
            
            obj.result.inputv = [vf; vs];
            result = obj.result;
            % profile viewer
        end
        function show(obj)
            obj.result
        end

        %-- 制約とその重心計算 --%
        function [c, ceq] = constraints(obj, x)
            % モデル予測制御の制約条件を計算するプログラム
            c  = zeros(12, obj.param.H);
            ceq_ode = zeros(12, obj.param.H);

            xReal = obj.reference.xr(1:12,:) - x(1:12,:);

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:12, :);          % 12 * Params.H
            U = x(13:16, :);   % 4 * Params.H

            %- ダイナミクス拘束
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
            %-- 連続の式をダイナミクス拘束に使う
            for L = 2:obj.param.H
                xx = X(:, L-1);
                xu = U(:, L-1);
                tmp = obj.A * xx + obj.B * xu;
                ceq_ode(:, L) = X(:, L) - tmp;   % tmpx : 縦ベクトル？
            end
            ceq = [X(:, 1) - obj.current_state, ceq_ode];
            %% c(x) <= 0
            % c(1) = xReal(3, :); % x <= 0
            % c(2) = xReal(11, :)-0.1;% yawの抑制
        end

        %------------------------------------------------------
        %======================================================
        function [eval] = objective(obj, x)   % obj.~とする
            X = x(1:12, :);       % 12 * 10 * N
            U = x(13:16,:);                % 4  * 10 * N
            %% Referenceの取得、ホライズンごと
            Xd = obj.reference.xr;
            %       Z = X;% - obj.state.ref(1:12,:);
            %% ホライズンごとに実際の誤差に変換する（リファレンス(1)の値からの誤差）
%             Xh = X + Xd(1:12,:);
            %% それぞれのホライズンのリファレンスとの誤差を求める
%             Z = Xd(1:12,:) - Xh;
            Z = X;

            tildeUpre = U - obj.input.u;          % agent.input 　前時刻入力との誤差
            tildeUref = U - Xd(13:16,:);  % 目標入力との誤差 0　との誤差

            %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算

%             stageStateZ = arrayfun(@(L) Z(:,L)' * obj.Weight * Z(:,L), 1:obj.param.H-1);
%             stageInputPre = arrayfun(@(L) tildeUpre(:,L)' * obj.WeightR * tildeUpre(:,L), 1:obj.param.H-1);
%             stageInputRef = arrayfun(@(L) tildeUref(:,L)' * obj.WeightRp * tildeUref(:,L), 1:obj.param.H-1);

            stageStateZ = diag(Z(:,1:end-1)'* obj.Weight * Z(:,1:end-1))';
            stageInputPre = diag(tildeUpre(:,1:end-1)'* obj.WeightRp * tildeUpre(:,1:end-1))';
            stageInputRef = diag(tildeUref(:,1:end-1)'* obj.WeightR  * tildeUref(:,1:end-1))';

            % stageStateZ = sum(Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,1:end-1,:)),[1,2]);%
            % stageInputPre  = sum(tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
            % stageInputRef  = sum(tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = Z(:, end)' * obj.Weight * Z(:,end);
            % terminalState = sum(Z(:,end,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,end,:)),[1,2]);

            %-- 評価値計算
            eval = sum(stageStateZ, [1,2]) + sum(stageInputPre, [1,2]) + sum(stageInputRef, [1,2]) + terminalState;  % 全体の評価値
        end

        function [xr] = Reference(obj, ~)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(16, obj.param.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.param.H-1
                t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = 0.269*9.81/4 * [1;1;1;1]; % MC -> 0.6597,   HL -> 0
            end
        end
    end
end
