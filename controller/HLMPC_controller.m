classdef HLMPC_controller <CONTROLLER_CLASS
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
        Weight
        WeightF
        WeightR
        WeightRp
        A
        B
    end

    methods
        function obj = HLMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
            %             obj.param.subCheck = zeros(obj.N, 1);
            % obj.param.modelparam.modelparam = obj.self.parameter.get();
            % obj.param.modelparam.modelmethod = obj.self.model.method;
            % obj.param.modelparam.modelsolver = obj.self.model.solver;
            obj.modelf = obj.self.model.method;
            obj.modelp = obj.self.parameter.get();

            %%
            obj.input = param.input;
            obj.const = param.const;
            obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
            obj.param.H = param.H + 1;
            obj.model = self.model;
            obj.param.fRemove = 0;

            %% HL
            obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.dt);
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
            sysd = c2d(ss(A,B,eye(12),0),param.dt); % 離散化
            obj.A = sysd.A;
            obj.B = sysd.B;

           
        end

        %-- main()的な
        function result = do(obj,param)
%             profile on
            % OB = obj;
            % xr = param{2};
            rt = param{2};
            problem = param{4};
            %       obj.input.InputV = param{5};
            % obj.state.ref = xr;
            obj.param.t = rt;
            idx = rt/obj.self.model.dt+1;

            %% HL 5/18 削除------------------------------------------------------------------------------------------------------------------------
            ref = obj.self.reference.result;
            xd = ref.state.get();
            if isprop(ref.state,'xd')
                if ~isempty(ref.state.xd)
                    xd = ref.state.xd; % 20次元の目標値に対応するよう
                end
            end
            %
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
            obj.reference.xr = ControllerReference(obj); % 12 * obj.param.H 仮想状態 * ホライズン

            if idx == 1
                initial_u1 = 0;   % 初期値
                initial_u2 = initial_u1;
                initial_u3 = initial_u1;
                initial_u4 = initial_u1;
            else
                initial_u1 = obj.self.input(1);
                initial_u2 = obj.self.input(2);
                initial_u3 = obj.self.input(3);
                initial_u4 = obj.self.input(4);
            end
            u0 = [initial_u1; initial_u2; initial_u3; initial_u4];% 初期値＝入力
%             x = obj.self.estimator.result.state.get();
            previous_state = repmat([obj.current_state; u0], 1, obj.param.H);
            % previous_state の1行目

            %                 previous_state(Params.state_size+1:Params.total_size, 1:Params.H) = repmat(x0, 1, Params.H);

            % MPC設定(problem)
            

            problem.x0		  = previous_state;                 % 状態，入力を初期値とする                                    % 現在状態
            problem.objective = @(x) obj.objective(x);            % 評価関数
            problem.nonlcon   = @(x) obj.constraints(x);          % 制約条件
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
            obj.self.input = obj.result.input;  % agent.inputへの代入
            obj.input.u = obj.result.input;

            % 座標として軌跡を保存するため　x = xd + state
            % state_xd = [xd(3);xd(7);xd(1);xd(5);xd(9);xd(13);xd(2);xd(6);xd(10);xd(14);xd(4);xd(8)];

            result = obj.result;
%             profile viewer
        end
        function show(obj)
            obj.result
        end

        %-- 制約とその重心計算 --%
        function [c, ceq] = constraints(obj, x)
            % モデル予測制御の制約条件を計算するプログラム
            c  = zeros(12, obj.param.H);
            ceq_ode = zeros(12, obj.param.H);

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:12, :);          % 12 * Params.H
            U = x(13:16, :);   % 4 * Params.H

            %- ダイナミクス拘束
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
            %-- 連続の式をダイナミクス拘束に使う
            for L = 2:obj.param.H
                xx = X(:, L-1);
                xu = U(:, L-1);
%                 xp = obj.current_state; % 初期値
                %         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],params.X0);
                %         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],xp);
                % [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],xp);
                tmp = obj.A * xx + obj.B * xu;
                ceq_ode(:, L) = X(:, L) - tmp;   % tmpx : 縦ベクトル？
            end
            ceq = [X(:, 1) - obj.current_state, ceq_ode];
%             c = x(13:16, :);
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
            Xh = X + Xd;
            %% それぞれのホライズンのリファレンスとの誤差を求める
            Z = Xd - Xh;
            % Z = X;

            tildeUpre = U - obj.input.u;          % agent.input 　前時刻入力との誤差
            tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

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
    end
end
