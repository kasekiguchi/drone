classdef HLMPC_controller_QP <CONTROLLER_CLASS
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
        expandA
        expandB
        expandC
        Q
        Qf
        R
    end

    methods
        function obj = HLMPC_controller_QP(self, param)
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
%             obj.param.H = param.H + 1;
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
%             options = optimoptions('fmincon');
            %     options = optimoptions(options,'Diagnostics','off');
            %     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
%             options = optimoptions(options,'MaxIterations',         1.e+12); % 最大反復回数
%             options = optimoptions(options,'ConstraintTolerance',1.e-4);     % 制約違反に対する許容誤差
            
            %-- fmincon設定
%             options.Algorithm = 'sqp';  % 逐次二次計画法
%             options.Display = 'none';   % 計算結果の表示
            options = optimset('Display', 'off');
            obj.param.options_fmin = options;

            obj.previous_input = repmat(obj.param.ref_input, 1, obj.param.H);

            %% expand coefficient
            [obj.expandA, obj.expandB] = ExpandState(obj);
            obj.expandC = eye(length(obj.expandA));

            %% 重み再定義
            obj.Q = repmat(obj.Weight, obj.param.H, obj.param.H);
            obj.Qf = repmat(obj.WeightF, obj.param.H, obj.param.H);
            obj.R = repmat(obj.param.R, obj.param.H, obj.param.H);
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
%             fun = @obj.objective;
%             x0 = obj.previous_input;
%             AA = []; b = []; Aeq = []; beq = []; 
%             lb = [zeros(1, obj.param.H); repmat(obj.param.input_min, 3,obj.param.H)]; % min
%             ub = [10 * ones(1, obj.param.H); repmat(obj.param.input_max, 3,obj.param.H)]; % max
%             nonlcon = [];

            %% QP : 周るけど評価関数的に目標値入れてない
%             T = 
%             H = obj.expandB' * obj.Q * obj.expandB + obj.R;
%             fb = [obj.current_state' * (obj.expandA' * obj.Q * obj.expandB); T * BB];
%             [var] = quadprog(H,f,AA,b,Aeq,beq,lb,ub,x0,obj.param.options_fmin);

            %% QP using mpc function. Create by hatenablog
            var = obj.mpc(obj.reference.xr);
            
            % var
            obj.previous_input = var(1:4);

            vf = var(1, 1);     % 最適な入力の取得
            vs = var(2:4, 1);     % 最適な入力の取得
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);  % 入力変換
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

        %% model predictive control
        function uopt = mpc(obj, ref)
            A_aug = obj.A;
            B_aug = obj.B;
            C_aug = eye(length(obj.A));
            
            QQ = obj.Weight;
            S  = obj.WeightF;
            RR = obj.WeightR;
            N  = obj.param.H;
            
            CQC = C_aug' * QQ * C_aug;
            CSC = C_aug' * S * C_aug;
            QC  = QQ * C_aug; 
            SC  = S * C_aug;
            
            Qdb = zeros(length(CQC(:,1))*N  ,length(CQC(1,:))*N);
            Tdb = zeros(length(QC(:,1))*N   ,length(QC(1,:))*N);
            Rdb = zeros(length(RR(:,1))*N   ,length(RR(1,:))*N);
            Cdb = zeros(length(B_aug(:,1))*N,length(B_aug(1,:))*N);
            Adc = zeros(length(A_aug(:,1))*N,length(A_aug(1,:)));
            
            % Filling in the matrices
            for i = 1:N
               if i == N
                   Qdb(1+length(CSC(:,1))*(i-1):length(CSC(:,1))*i,1+length(CSC(1,:))*(i-1):length(CSC(1,:))*i) = CSC;
                   Tdb(1+length(SC(:,1))*(i-1):length(SC(:,1))*i,1+length(SC(1,:))*(i-1):length(SC(1,:))*i) = SC;           
               else
                   Qdb(1+length(CQC(:,1))*(i-1):length(CQC(:,1))*i,1+length(CQC(1,:))*(i-1):length(CQC(1,:))*i) = CQC;
                   Tdb(1+length(QC(:,1))*(i-1):length(QC(:,1))*i,1+length(QC(1,:))*(i-1):length(QC(1,:))*i) = QC;
               end
               
               Rdb(1+length(RR(:,1))*(i-1):length(RR(:,1))*i,1+length(RR(1,:))*(i-1):length(RR(1,:))*i) = RR;
               
               for j = 1:N
                   if j<=i
                       Cdb(1+length(B_aug(:,1))*(i-1):length(B_aug(:,1))*i,1+length(B_aug(1,:))*(j-1):length(B_aug(1,:))*j) = A_aug.^(i-j)*B_aug;
                   end
               end
               Adc(1+length(A_aug(:,1))*(i-1):length(A_aug(:,1))*i,1:length(A_aug(1,:))) = A_aug^(i);
            end
            Hdb  = Cdb' * Qdb * Cdb + Rdb;
            Fdbt = [Adc' * Qdb * Cdb; -Tdb * Cdb];
            
            % Calling the optimizer (quadprog)
            % Cost function in quadprog: min(du)*1/2*du'Hdb*du+f'du
            ft = [obj.current_state', ref'] * Fdbt;
        
            % Call the solver (quadprog)
            AA   = [];
            b   = [];
            Aeq = [];
            beq = [];
            lb = [zeros(1, obj.param.H); repmat(obj.param.input_min, 3,obj.param.H)]; % min
            ub = [10 * ones(1, obj.param.H); repmat(obj.param.input_max, 3,obj.param.H)]; % max
            x0  = [];
            options_quad = optimset('Display', 'off');
            [du, ~] = quadprog(Hdb,ft,AA,b,Aeq,beq,lb,ub,x0,options_quad);
            uopt = du(1);
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

        function [expandA, expandB] = ExpandState(obj)
            H = obj.param.H;
            L = size(obj.A, 1);
            expandA = zeros(L*H, 12);
            expandB = zeros(L*H, 4*H);
            BB = zeros(12, 4*H);
            for n = 1:H
                BB(:, 4*(n-1)+1 : 4*n) = obj.A.^(n-1)*obj.B;
            end

            for n = 1:H
                expandA(L*(n-1)+1:L*n,:) = obj.A.^n;
                expandB(L*(n-1)+1:L*n,:) = [BB(:, 1:4*n), zeros(12, (H-n)*4)];
            end
        end
    end
end
