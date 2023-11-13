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
        previous_input
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
            % obj.const = param.const;
            obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
            % obj.param.H = param.H + 1;
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

            %-- fmincon 設定
            options = optimoptions('fmincon');
            %     options = optimoptions(options,'Diagnostics','off');
            %     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
            options = optimoptions(options,'MaxIterations',         1.e+12); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-4);     % 制約違反に対する許容誤差
            
            %-- fmincon設定
            options.Algorithm = 'sqp';  % 逐次二次計画法
            options.Display = 'none';   % 計算結果の表示
            obj.param.options_fmin = options;

            obj.previous_input = repmat(obj.param.ref_input, 1, obj.param.H);
        end

        %-- main()的な
        function result = do(obj,param)
            % profile on
            % OB = obj;
            % xr = param{2};
            idx = param{1};
            xr = param{2};
            rt = param{3};

            obj.param.t = rt;
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
            % obj.reference.xr = ControllerReference(obj); % 12 * obj.param.H 仮想状態 * ホライズン
            % obj.reference.xr = xr;
            obj.reference.xr = [xr(3,:);xr(7,:);xr(1,:);xr(5,:);xr(9,:);xr(13,:);xr(2,:);xr(6,:);xr(10,:);xr(14,:);xr(4,:);xr(8,:)];

            %% MPC 設定
            fun = @obj.objective;
            x0 = obj.previous_input;
            AA = []; b = []; Aeq = []; beq = []; 
            lb = [zeros(1, obj.param.H); repmat(-obj.param.input_TH, 3,obj.param.H)]; % min
            ub = [obj.param.Z_max*ones(1, obj.param.H); repmat(obj.param.input_TH, 3,obj.param.H)]; % max
            nonlcon = [];
            [var] = fmincon(fun,x0,AA,b,Aeq,beq,lb,ub,nonlcon,obj.param.options_fmin);
            
            % var
            obj.previous_input = var;

            vf = var(1, 1);     % 最適な入力の取得
            vs = var(2:4, 1);     % 最適な入力の取得
            tmp = Uf_GUI(xn,xd',vf,P) + Us_GUI(xn,xd',[vf,0,0],vs(:),P);  % 入力変換
            obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
            obj.self.input = obj.result.input;  % agent.inputへの代入
            obj.input.u = obj.result.input;

            obj.result.input_v = [vf; vs];
            result = obj.result;
            % profile viewer
        end
        function show(obj)
            obj.result
        end

        %------------------------------------------------------
        %======================================================
        function [eval] = objective(obj, x)   % obj.~とする
            U = x;                % 4  * 10 * N
            X(:, 1) = obj.current_state;
            for L = 2:obj.param.H
                X(:,L) = obj.A * X(:,L-1) + obj.B * U(:,L-1);
            end
            Z = X;

            tildeUpre = U - obj.input.u;          % agent.input 　前時刻入力との誤差
            tildeUref = U - obj.param.ref_input;  % 目標入力との誤差 0　との誤差

            %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
            stageStateZ = diag(Z(:,1:end-1)'* obj.Weight * Z(:,1:end-1))';
            stageInputPre = diag(tildeUpre(:,1:end-1)'* obj.WeightRp * tildeUpre(:,1:end-1))';
            stageInputRef = diag(tildeUref(:,1:end-1)'* obj.WeightR  * tildeUref(:,1:end-1))';

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = Z(:, end)' * obj.Weight * Z(:,end);

            %-- 評価値計算
            eval = sum(stageStateZ+stageInputPre+stageInputRef) + terminalState;  % 全体の評価値
        end
    end
end
