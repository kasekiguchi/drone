classdef MPC_controller <CONTROLLER_CLASS
    %MPC_CONTROLLER MPCのコントローラー
    %   fminiconで質点ベースのMPCをする
    %   詳細説明をここに記述
    
    properties
        options
        param
        previous_input
        previous_state
        model
        result
        self
        A
        B
        F1
        current_state
    end
    
    methods
        function obj = MPC_controller(self,~)
            obj.self = self;
            %options_setting
            obj.options = optimoptions('fmincon');
            obj.options.UseParallel            = false;
            obj.options.Algorithm			   = 'sqp';
            % obj.options.Display                = 'none';
            obj.options.Diagnostics            = 'off';
            obj.options.MaxFunctionEvaluations = 1.e+12;%関数評価の最大回数
            obj.options.MaxIterations		   = Inf;%反復の最大許容回数
            % obj.options.StepTolerance          = 1.e-12;%xに関する終了許容誤差
            obj.options.ConstraintTolerance    = 1.e-3;%制約違反に対する許容誤差
            % obj.options.OptimalityTolerance    = 1.e-12;%1 次の最適性に関する終了許容誤差。
            % obj.options.PlotFcn                = [];
            %---MPCパラメータ設定---%
            obj.param.H  = 10;                % モデル予測制御のホライゾン
            obj.param.dt = 0.25;              % モデル予測制御の刻み時間
            obj.param.input_size = self.model.dim(2);
            obj.param.state_size = self.model.dim(1);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %初期状態とホライゾン数の合計
            %重み%
            obj.param.Q = diag(10*ones(1,obj.param.state_size));
            obj.param.R = diag(10*ones(1,obj.param.input_size));
            obj.param.Qf = diag(10*ones(1,obj.param.state_size));
            
            obj.previous_input = zeros(obj.param.input_size,obj.param.Num);

            obj.model = self.model;

            %% HL
            obj.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.1,obj.param.dt);
            A = blkdiag([0,1;0,0],diag([1,1,1],1),diag([1,1,1],1),[0,1;0,0]);
            B = blkdiag([0;1],[0;0;0;1],[0;0;0;1],[0;1]);
            sysd = c2d(ss(A,B,eye(12),0),obj.param.dt); % 離散化
            obj.A = sysd.A;
            obj.B = sysd.B;
        end
        
        function u = do(obj,~,~)
            % param = {model, reference}
            % param{1}.state : 推定したstate構造体
            % param{2}.result.state : 参照状態の構造体 % n x Num :  n : number of state,  Num : horizon
            % param{3} : 構造体
            
            %state = state_copy(param{1}.state);
            %model = param{1};
%             ref = obj.self.reference.result.state;
%             if [obj.param.state_size,obj.param.Num] == size(ref)
%                 obj.param.Xr = ref.get();
%             else
%                 obj.param.Xr = repmat(0*obj.self.model.state.get(),1,obj.param.Num);%repmat([eul2quat([0,0,0])';10;0;1;zeros(6,1)],1,obj.param.Num) ;
%                 obj.param.Xr(1:3,:) = repmat(ref.p,1,obj.param.Num);
%             end

            %% HL
            ref = obj.self.reference.result;
            xd = ref.state.get();
            if isprop(ref.state,'xd')
                if ~isempty(ref.state.xd)
                    % ref.state から p を抜く　xd=[28x1]
                    xd = ref.state.xd; % 20次元の目標値に対応するよう
                end
            end
            model_HL = obj.self.estimator.result;
            %       xn = [model_HL.state.getq('compact');model_HL.state.p;model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            xn = [R2q(Rb0'*model_HL.state.getq("rotmat"));Rb0'*model_HL.state.p;Rb0'*model_HL.state.v;model_HL.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            P = obj.self.model.param;
            vfn = Vf(xn,xd',P,obj.F1); %v1 
            z1n = Z1(xn,xd',P);
            z2n = Z2(xn,xd',vfn,P);
            z3n = Z3(xn,xd',vfn,P);
            z4n = Z4(xn,xd',vfn,P);
            obj.current_state = [z1n(1:2);z2n(1:4);z3n(1:4);z4n(1:2)];  % 仮想状態の算出

            %%
            %obj.param.t = t;
%             obj.param.X0 = obj.self.model.state.get();%[state.p;state.q;state.v;state.w];
            obj.param.X0 = obj.current_state;   % HLの現在状態
            obj.param.model = obj.self.model.method;
            obj.param.model_param = obj.self.model.param;
            obj.previous_state = repmat(obj.param.X0,1,obj.param.Num);
            problem.solver    = 'fmincon';
            problem.options   = obj.options;
            problem.objective = @(x) obj.objective(x, obj.param);  % 評価関数
            problem.nonlcon   = @(x) obj.constraints(x, obj.param);% 制約条件
            problem.x0		  = [obj.previous_state;obj.previous_input]; % 初期状態
            %[var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
            [var, ~,~,~,~,~,~] = fmincon(problem);
            % obj.result.input = var(obj.param.state_size + 1:obj.param.total_size, 1);
            vf = var(13,1);     
            vs = var(14:16,1);     
            tmp = Uf(xn,xd',vf,P) + Us(xn,xd',[vf,0,0],vs(:),P);
            obj.result.input = tmp(:);
            u = obj.result;
            obj.previous_input = var(obj.param.state_size + 1:obj.param.total_size, :);
        end
        function show(obj)
            
        end
        function [eval] = objective(obj,x, params)
            % モデル予測制御の評価値を計算するプログラム

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :); 
%             Z = X;
            U = x(params.state_size+1:end, :);
            
            %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
%             tildeX = X - params.Xr;
            tildeX = X;
            %     tildeU = U - params.Ur;
            tildeU = U; % 抑制項
            %-- 状態及び入力のステージコストを計算
            stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
            stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
            %-- 状態の終端コストを計算
            terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
            %-- 評価値計算
            eval = sum(stageState + stageInput) + terminalState;
        end
        function [cineq, ceq] = constraints(obj,x, params)
            % モデル予測制御の制約条件を計算するプログラム
            cineq  = zeros(params.state_size, 4*params.H);
            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);  % HL:誤差項
            U = x(params.state_size+1:end, :);
            
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
            %TEMP_predictX = cell2mat(arrayfun(@(N) ode45(@(t,x) params.model(x,U(:,N),params.model_param),[params.dt*(N-2) params.dt*(N-1)],X(:,N-1)),2:params.Num,'UniformOutput',false));
            %PredictX = cell2mat(arrayfun(@(L) TEMP_predictX(L).y(:,end),1:params.H,'UniformOutput',false));
%             PredictX = X+obj.param.dt*obj.self.model.method(X,U,obj.param.model_param);
            PredictX = obj.A*X+obj.B*U;
            
            ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  -  PredictX(:,L-1), 2:params.Num, 'UniformOutput', false))];
            %-- 予測入力が入力の上下限制約に従うことを設定
            %     cineq(:, 1: params.H)	        = cell2mat(arrayfun(@(L) params.U(:, 1) - U(:, L), 1:params.H, 'UniformOutput', false));
            %     cineq(:, params.H+1: 2*params.H)= cell2mat(arrayfun(@(L) U(:, L) - params.U(:, 2), 1:params.H, 'UniformOutput', false));
            %     %-- 予測入力間での変化量が変化量制約以下となることを設定
            %     cineq(:, 2*params.H+1: 3*params.H) = [cell2mat(arrayfun(@(L) -params.S - (U(:, L) - U(:, L-1)) , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
            %     cineq(:, 3*params.H+1: 4*params.H) = [cell2mat(arrayfun(@(L) (U(:, L) - U(:, L-1)) - params.S  , 2:params.H, 'UniformOutput', false)),  zeros(2,1)];
        end
    end
end

