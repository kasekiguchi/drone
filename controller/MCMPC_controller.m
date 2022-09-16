classdef MCMPC_controller <CONTROLLER_CLASS
    %MPC_CONTROLLER MPCのコントローラー
    %   fminiconで質点ベースのMPCをする
    %   詳細説明をここに記述
    
    properties
        % 変数名，構造体名をここで定義
        options
        param
        previous_input
        previous_state
        input
        state
        model
        result
        self
    end
    
    methods
        function obj = MCMPC_controller(self,param)
            %-- 変数定義
            obj.self = self;
            %options_setting
%             obj.options = optimoptions('fmincon');
%             obj.options.UseParallel            = false;
%             obj.options.Algorithm			   = 'sqp';
            % obj.options.Display                = 'none';
%             obj.options.Diagnostics            = 'off';
%             obj.options.MaxFunctionEvaluations = 1.e+12;%関数評価の最大回数
%             obj.options.MaxIterations		   = Inf;%反復の最大許容回数
            % obj.options.StepTolerance          = 1.e-12;%xに関する終了許容誤差
%             obj.options.ConstraintTolerance    = 1.e-3;%制約違反に対する許容誤差
            % obj.options.OptimalityTolerance    = 1.e-12;%1 次の最適性に関する終了許容誤差。
            % obj.options.PlotFcn                = [];
            %---MPCパラメータ設定---%
            obj.param.H  = 10;                % モデル予測制御のホライゾン
            obj.param.dt = 0.1;              % モデル予測制御の刻み時間
            obj.param.particle_num = 100;
            obj.param.input_size = self.model.dim(2);
            obj.param.state_size = self.model.dim(1);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %初期状態とホライゾン数の合計
            %重み%
            obj.param.P = diag(10*ones(1,obj.param.state_size));    % position
            obj.param.V = diag(10*ones(1,obj.param.input_size));    % velocity
            obj.param.QW = diag(10*ones(1,obj.param.state_size));   % Attitude and 
            obj.param.RP = diag(10*ones(1,obj.param.state_size));   % Difference of Previous input 
            obj.param.R = diag(10*ones(1,obj.param.input_size));    % Difference of origin input
            
            obj.previous_input = zeros(obj.param.input_size,obj.param.Num);

            obj.model = self.model;
        end
        
        %-- main()的な
        function u = do(obj,param,~)
            % param = {model, reference}
            % param{1}.state : 推定したstate構造体
            % param{2}.result.state : 参照状態の構造体 % n x Num :  n : number of state,  Num : horizon
            % param{3} : 構造体
            
            %state = state_copy(param{1}.state);
            %model = param{1};
            ref = obj.self.reference.result.state;  % reference
            if [obj.param.state_size,obj.param.Num] == size(ref)
                obj.param.Xr = ref.get();
            else
                obj.param.Xr = repmat(0*obj.self.model.state.get(),1,obj.param.Num);%repmat([eul2quat([0,0,0])';10;0;1;zeros(6,1)],1,obj.param.Num) ;
                obj.param.Xr(1:3,:) = repmat(ref.p,1,obj.param.Num);
            end
            
            %obj.param.t = t;
            obj.param.X0 = obj.self.model.state.get();%[state.p;state.q;state.v;state.w];   % 初期状態の取得
            obj.param.model = obj.self.model.method;    % ode15sのやつ
            obj.param.model_param = obj.self.model.param;   % DIATONE_PARAM
            
            %-- 入力行列作成
            ave1 = 0.269 * 9.81 / 4; ave2 = ave1; ave3 = ave1; ave4 = ave1;
            sigma = 0.01;
            obj.input.u1 = sigma.*randn(obj.param.H, obj.param.particle_num) + ave1;
            obj.input.u2 = sigma.*randn(obj.param.H, obj.param.particle_num) + ave2;
            obj.input.u3 = sigma.*randn(obj.param.H, obj.param.particle_num) + ave3;
            obj.input.u4 = sigma.*randn(obj.param.H, obj.param.particle_num) + ave4;
            obj.input.u1(u1<0) = 0;   % 負の入力を阻止
            obj.input.u2(u2<0) = 0;
            obj.input.u3(u3<0) = 0;
            obj.input.u4(u4<0) = 0;
            obj.input.u(4, 1:obj.param.H, 1:obj.param.particle_num) = u4;   % reshape
            obj.input.u(3, :, :) = u3;   
            obj.input.u(2, :, :) = u2;
            obj.input.u(1, :, :) = u1;
            obj.input.u_size = size(obj.input.u, 3);    % obj.param.particle_num
        %-- 全予測軌道のパラメータの格納変数を定義 repmat で短縮できるかも
            obj.state.p_data = zeros(obj.param.H, obj.obj.param.particle_num);
            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            obj.state.v_data = zeros(obj.param.H, obj.obj.param.particle_num);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.q_data = zeros(obj.param.H, obj.obj.param.particle_num);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.w_data = zeros(obj.param.H, obj.obj.param.particle_num);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
            obj.state.state_data = [obj.state.p_data; obj.state.q_data; obj.state.v_data; obj.state.w_data];
%             problem.solver    = 'fmincon';
%             problem.options   = obj.options;
%             problem.objective = @(x) obj.objective(x, obj.param);  % 評価関数
%             problem.nonlcon   = @(x) obj.constraints(x, obj.param);% 制約条件
%             problem.x0		  = [obj.previous_state;obj.previous_input]; % 初期状態
            %[var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
%             [var, ~,~,~,~,~,~] = fmincon(problem);
            %-- 状態予測
            obj.state.predict_state = obj.predict(x, obj.state, obj.param);
            %-- 評価値計算
            for m = 1:obj.input.u_size
                obj.input.eval = obj.objective(obj.param, obj.state, obj.input);
            end
%             obj.result.input = var(obj.param.state_size + 1:obj.param.total_size, 1);
            u = obj.result;
%             obj.previous_input = var(obj.param.state_size + 1:obj.param.total_size, :);             
            obj.previous_state = repmat(obj.param.X0,1,obj.param.Num);  % 前状態の取得
        end
        function show(obj)
            obj.result;
        end

        function [predict_state] = predict(obj, params, states, inputs)
            %-- 予測軌道計算
            for m = 1:inputs.u_size
                x0 = obj.previous_state;
                states.state_data(:, 1, m) = obj.previous_state;
                for h = 1:params.H-1
                    [~,tmpx]=obj.self.model.solver(@(t,x) obj.self.model.method(x, inputs.u(:, h, m),obj.selt.parameter.get()),[ts ts+params.dt],x0);
                    x0 = tmpx(end, :);
                    states.state_data(:, h+1, m) = x0;
                end
            end
            predict_state = states.state_data;
        end
        function [eval] = objective(obj, params, states, inputs)
            % モデル予測制御の評価値を計算するプログラム

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
%             X = x(1:params.state_size, :);
%             U = x(params.state_size+1:end, :);
            X = states.state_data;
            U = inputs.u;
            
            %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeX = X - params.Xr;
            %     tildeU = U - params.Ur;
            tildeU = U;
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
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:end, :);
            
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
            %TEMP_predictX = cell2mat(arrayfun(@(N) ode45(@(t,x) params.model(x,U(:,N),params.model_param),[params.dt*(N-2) params.dt*(N-1)],X(:,N-1)),2:params.Num,'UniformOutput',false));
            %PredictX = cell2mat(arrayfun(@(L) TEMP_predictX(L).y(:,end),1:params.H,'UniformOutput',false));
            PredictX = X+obj.param.dt*obj.self.model.method(X,U,obj.param.model_param);
            
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

