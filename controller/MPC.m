classdef MPC < handle
    % linear Model Predictive Control
    
    properties
        options
        param
        previous_input
        previous_state
        model
        result
        self

        H % horizon
        cost_func
    end
    
    methods
        function obj = MPC(self,param)
            obj.self = self;
            obj.options = optimoptions('fmincon');
            obj.options.UseParallel            = true;
            obj.options.Algorithm			   = 'sqp';
            % obj.options.Display                = 'none';
            obj.options.Diagnostics            = 'off';
            obj.options.MaxFunctionEvaluations = 1.e+12;%関数評価の最大回数
            obj.options.MaxIterations		   = 100;%反復の最大許容回数
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

            if isfield(param,'cost_func')
            obj.cost_func = param.cost_func;
            else
              obj.cost_func = obj.objective;
            end
        end
        
        function result = do(obj,varargin)
          param = struct(varargin{:});
          obj.result.input = [1;1;1;1];
          result = obj.result;
        end
        function show(obj)
            
        end
        function [eval] = objective(obj,x, params)
            % モデル予測制御の評価値を計算するプログラム

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:end, :);
            
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
        function trans_qp(A,B)
        end
    end
end

