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
        Q
        Qf
        R
        Rp
        A
        B
        previous_input
        expandA
        expandB
        expandC
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
            obj.Q = blkdiag(obj.param.Z, obj.param.X, obj.param.Y, obj.param.PHI);
            obj.Qf = blkdiag(obj.param.Zf, obj.param.Xf, obj.param.Yf, obj.param.PHIf);
            obj.R = obj.param.R;  % 目標入力
            obj.Rp = obj.param.RP; % 前ステップとの入力
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
            options = optimoptions('quadprog');
            options = optimoptions(options,'MaxIterations',      1.e+9);     % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-5);%制約違反に対する許容誤差
            options.Display = 'none';
            obj.param.options_fmin = options;
            % problem.solver = 'quadprog';

            obj.previous_input = repmat(obj.param.ref_input, 1, obj.param.H);

            %% 重み再定義
            % obj.Q = repmat(obj.Weight, obj.param.H, obj.param.H);
            % obj.Qf = repmat(obj.WeightF, obj.param.H, obj.param.H);
            % obj.R = repmat(obj.param.R, obj.param.H, obj.param.H);
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
            % fun = @obj.objective;
            x0 = obj.previous_input;
            AA = []; b = []; Aeq = []; beq = []; 
            lb = [zeros(1, obj.param.H); repmat(-obj.param.input_TH, 3,obj.param.H)]; % min
            ub = [10 * ones(1, obj.param.H); repmat(obj.param.input_TH, 3,obj.param.H)]; % max
            % nonlcon = [];

            %% QP : 周るけど評価関数的に目標値入れてない
            [H, f] = obj.ExpandState();
            [var] = quadprog(H,f,AA,b,Aeq,beq,lb,ub,x0,obj.param.options_fmin);
            
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

        function [H, f] = ExpandState(obj)
            Aq = obj.A;
            Bq = obj.B;
            Cq = diag(ones(size(obj.A, 1), 1));

            Qq = obj.Q;
            Qfq = obj.Qf;
            Rq = obj.R;
            Hq = obj.param.H;

            X = obj.current_state;% + obj.reference.xr(1:12,1); % 実状態化しないといけない
            ref = ones(12*obj.param.H ,1);
            % ref = reshape(obj.reference.xr, 12*obj.param.H, []); % 12*10, 1
            uref = repmat(obj.param.ref_input, obj.param.H, 1); % 4*10,1

            CQC = Cq' * Qq * Cq;
            CQfC = Cq' * Qfq * Cq;
            QC = Qq * Cq;
            QfC = Qfq * Cq;

            Rm = blkdiag(Rq, Rq, Rq, Rq, Rq, Rq, Rq, Rq, Rq, zeros(4)); %R
            Am = [Aq; Aq^2; Aq^3; Aq^4; Aq^5; Aq^6; Aq^7; Aq^8; Aq^9; Aq^10]; %A
            Qm = blkdiag(CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQfC); %Q
            qm = blkdiag(QC, QC, QC, QC, QC, QC, QC, QC, QC, QfC); %Q'


            for i  = 1:Hq
                for j = 1:Hq
                    if j <= i
                        S(1+length(Bq(:,1))*(i-1):length(Bq(:,1))*i,1+length(Bq(1,:))*(j-1):length(Bq(1,:))*j) = Aq^(i-j)*Bq;
                    end
                end
            end
            H = S' * Qm * S + Rm;
            H = (H+H')/2;
            F = [Am' * Qm * S; -qm * S; -Rm];
            f = [X', ref', uref'] * F;
        end
    end
end
