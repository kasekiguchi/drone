classdef HLMPC_controller <handle
    % MCMPC_CONTROLLER MCMPCのコントローラー

    properties
%         options
        param
        current_state
        previous_input
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
        C
        mpc
    end

    methods
        function obj = HLMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            obj.modelf = obj.self.plant.method;
            obj.modelp = obj.self.parameter.get();

            %%
            obj.input = obj.param.input;
            % obj.param.H = obj.param.H + 1;
            obj.model = self.plant;
            obj.param.fRemove = 0;

            %% HL
            obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,param.param.dt);
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
            obj.C = eye(12); 
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1);
            obj.previous_input = repmat(obj.input.u, 1, obj.param.H); 
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            obj.param.t = varargin{1}.t;

            ref = obj.self.reference.result;
            xd = ref.state.get();
            if isprop(ref.state,'xd')
                if ~isempty(ref.state.xd)
                    xd = ref.state.xd; % 20次元の目標値に対応するよう
                end
            end
            %
            %% Reference function
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

            %% Referenceの取得、ホライズンごと
            % 実状態の目標値
            xr_real = obj.Reference(); % 12 * obj.param.H 仮想状態 * ホライズン
            % 実状態の目標値を仮想状態的に並び替え
            xr_imag = [xr_real(3,:);xr_real(7,:);xr_real(1,:);xr_real(5,:);xr_real(9,:);xr_real(13,:);xr_real(2,:);xr_real(6,:);xr_real(10,:);xr_real(14,:);xr_real(4,:);xr_real(8,:)];
            obj.reference.xr = [xr_imag(:,1) - xr_imag; xr_real(13:end,:)];

            %% fmincon
            % %-- fmincon 設定
            % options = optimoptions('fmincon');
            % options = optimoptions(options,'MaxIterations',         1.e+12); % 最大反復回数
            % options = optimoptions(options,'ConstraintTolerance',1.e-4);     % 制約違反に対する許容誤差
            % 
            % options.Algorithm = 'sqp';  % 逐次二次計画法
            % options.Display = 'none';   % 計算結果の表示
            % %% conditions
            % fun = @obj.objective;
            % x0 = obj.previous_input;
            % A = []; b = []; Aeq = []; beq = []; 
            % lb = repmat(obj.param.input_min, 1,obj.param.H); % min
            % ub = repmat(obj.param.input_max, 1,obj.param.H); % max
            % nonlcon = [];
            % [var, ~, ~, ~, ~, ~, ~] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

            %% quadprog
            % MPC設定(problem)
            options = optimoptions('quadprog');
            options = optimoptions(options,'MaxIterations',      1.e+9); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-5);     % 制約違反に対する許容誤差

            %-- quadprog設定
            options.Display = 'none';   % 計算結果の表示
            problem.solver = 'quadprog'; % solver

            [H, f] = obj.change_equation();
            A = [];
            b = [];
            Aeq = [];
            beq = [];
            lb = [];
            ub = [];
            x0 = [obj.previous_input(:)];
              
            [var, ~, exitflag, ~, ~] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options, problem); %最適化計算

            obj.previous_input = var; % 最適化の初期値

            vf = var(1, 1);     % 最適な入力の取得
            vs = var(2:4, 1);     % 最適な入力の取得
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);  % 入力変換
            obj.result.input = tmp(:);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
            obj.input.u = obj.result.input; % 入力をcontroller内に保存

            obj.result.input_v = [vf; vs]; % 仮想入力の保存
            obj.result.xr = xr_real;

            %% 情報表示
            if exist("exitflag") ~= 1
                exitflag = NaN;
            end
            est_print = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                    est_print.p(1), est_print.p(2), est_print.p(3),...
                    est_print.v(1), est_print.v(2), est_print.v(3),...
                    est_print.q(1)*180/pi, est_print.q(2)*180/pi, est_print.q(3)*180/pi); % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                    xr_real(1,1), xr_real(2,1), xr_real(3,1),...
                    xr_real(7,1), xr_real(8,1), xr_real(9,1),...
                    xr_real(4,1)*180/pi, xr_real(5,1)*180/pi, xr_real(6,1)*180/pi)                             % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t flag: %d", ...
                obj.param.t, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), exitflag);
            fprintf("\n");
            
            % 結果の保存
            result = obj.result;
            % profile viewer
        end
        function show(obj)
            obj.result
        end

        function [eval] = objective(obj, x)   % obj.~とする
            U = x;
            X(:,1) = obj.current_state;
            for L = 2:obj.param.H
                X(:,L) = obj.A*X(:,L-1) + obj.B*U(:,L-1);
            end
            
            Xd = obj.reference.xr; % 目標値
            Z = X; % 状態

            tildeUpre = U - obj.input.u;          % 前時刻入力との誤差
            tildeUref = U - Xd(13:16,:);  % 目標入力との誤差

            %-- 状態及び入力のステージコストを計算
            stageStateZ = diag(Z(:,1:end-1)'* obj.Weight * Z(:,1:end-1))';
            stageInputPre = diag(tildeUpre(:,1:end-1)'* obj.WeightRp * tildeUpre(:,1:end-1))';
            stageInputRef = diag(tildeUref(:,1:end-1)'* obj.WeightR  * tildeUref(:,1:end-1))';

            %-- 状態だけの終端コスト
            terminalState = Z(:, end)' * obj.Weight * Z(:,end);

            %-- 評価値計算
            eval = sum(stageStateZ + stageInputPre + stageInputRef) + terminalState;  % 全体の評価値
        end

        function [H, f] = change_equation(obj)
            obj.A;
            obj.B;
            obj.C;
        
            Q = obj.Weight;
            R = obj.WeightR;
            Qf = obj.WeightF;

            Xc = obj.current_state; % 現在状態

            r  = obj.reference.xr(1:12,:);
            r = r(:); %目標値、列ベクトルに変換
            ur = obj.reference.xr(13:16,:);
            ur = ur(:); %目標入力、列ベクトルに変換
        
            CQC = obj.C' * Q * obj.C;
            CQfC = obj.C' * Qf * obj.C;
            QC = Q * obj.C;
            QfC = Qf * obj.C;
            
            Rm = blkdiag(R, R, R, R, R, R, R, R, R, zeros(4)); %R
            Am = [obj.A; obj.A^2; obj.A^3; obj.A^4; obj.A^5; obj.A^6; obj.A^7; obj.A^8; obj.A^9; obj.A^10]; %A
            Qm = blkdiag(CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQfC); %Q
            qm = blkdiag(QC, QC, QC, QC, QC, QC, QC, QC, QC, QfC); %Q'
        
            for i  = 1:obj.param.H
                for j = 1:obj.param.H
                    if j <= i
                        S(1+length(obj.B(:,1))*(i-1):length(obj.B(:,1))*i,1+length(obj.B(1,:))*(j-1):length(obj.B(1,:))*j) = obj.A^(i-j)*obj.B;
                    end
                end
            end
            
            H = S' * Qm * S + Rm;
            H = (H+H')/2;
            F = [Am' * Qm * S; -qm * S; -Rm];
            f = [Xc', r', ur'] * F;
        end

        function [xr] = Reference(obj, ~)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(19, obj.param.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.param.H-1
                t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3); % 位置
                xr(7:9, h+1) = ref(5:7); % 速度
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0]; % 姿勢角速度
                xr(13:16, h+1) = obj.param.ref_input; % 入力
                xr(17:19, h+1) = [0;0;0]; % 加速度
            end
        end
    end
end
