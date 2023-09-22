classdef MPC_controller_case <handle
    % MCMPC_CONTROLLER MPCのコントローラー
    % Imai Case study 
    % 勾配MPCコントローラー

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
    end

    methods
        function obj = MPC_controller_case(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            obj.modelf = obj.self.plant.method;
            obj.modelp = obj.self.parameter.get();

            %%
            obj.input = obj.param.input;
            % obj.const = param.const;
            obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
            obj.param.H = obj.param.H + 1;
            obj.model = self.plant;
            obj.param.fRemove = 0;
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            obj.param.t = varargin{1}.t;
            rt = obj.param.t;
            idx = obj.param.t/obj.param.dt+1;

            obj.state.ref = obj.Reference(rt);
            obj.current_state = obj.self.estimator.result.state.get();

            %% 情報表示
            state_monte = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi); % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                    obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
                    obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
                    obj.state.ref(4,1)*180/pi, obj.state.ref(5,1)*180/pi, obj.state.ref(6,1)*180/pi)                             % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t input_v: %f %f %f %f", ...
                rt, obj.input.v(1), obj.input.v(2), obj.input.v(3), obj.input.v(4));
%             fprintf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            fprintf("\n");

            % ---------------------------------------------------------------------------------------------
            % x = obj.current_state;
            u0 = obj.input.u;% 初期値＝入力
%             u0(4) = 0;
            previous_state = repmat([obj.current_state; u0], 1, obj.param.H);

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

            problem.x0		  = previous_state;                 % 状態，入力を初期値とする                                    % 現在状態

            problem.objective = @(x) obj.objective(x); 
            problem.nonlcon   = @(x) obj.constraints(x);
            [var, ~, ~] = fmincon(problem);

            %% MPC_controller_case が実行されていない
            %% 他のなにかしらのコントローラを通っている
            %%

            obj.result.input = var(13:16, 1);%[tmp(1);tmp(2);tmp(3);tmp(4)]; 実入力変換
%             obj.result.input = var(13:15, 1);
%             obj.result.input = [var(13:15, 1); 0];
            obj.input.u = obj.result.input;
            obj.input.v = obj.input.u;

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

            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:12, :);          % 12 * Params.H
            U = x(13:16, :);   % 4 * Params.H

            U(16, :) = zeros(1, obj.param.H);
            %- ダイナミクス拘束
            %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
            %-- 連続の式をダイナミクス拘束に使う
            for L = 2:obj.param.H
                xx = X(:, L-1);
                xu = U(:, L-1);
                tmp = xx + obj.param.dt * obj.modelf(xx, xu, obj.modelp);
                ceq_ode(:, L) = X(:, L) - tmp;   % tmpx : 縦ベクトル？
            end
            ceq = [X(:, 1) - obj.current_state, ceq_ode];
        end

        %------------------------------------------------------
        %======================================================
        function [eval] = objective(obj,x)   % obj.~とする
            Xp = x(1:3, :);
            Xq = x(4:6, :);
            Xv = x(7:9, :);  
            Xw = x(10:12, :);
            U = x(13:16, :);
            
        %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeXp = Xp - obj.state.ref(1:3, :);  % 位置
            tildeXq = Xq - obj.state.ref(4:6, :);
            tildeXv = Xv - obj.state.ref(7:9, :);  % 速度
            tildeXw = Xw - obj.state.ref(10:12,:);
            tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
            tildeUpre = U - obj.input.v;
            tildeUref = U - obj.state.ref(13:16,:);

            stageStateP =    sum(tildeXp(:,end-1)' * obj.param.P   .* tildeXp(:,end-1)',2);
            stageStateV =    sum(tildeXv(:,end-1)' * obj.param.V   .* tildeXv(:,end-1)',2);
            stageStateQW =   sum(tildeXqw(:,end-1)' * obj.param.QW .* tildeXqw(:,end-1)',2);
            stageInputPre  = sum(tildeUpre(:,end-1)' * obj.param.RP.* tildeUpre(:,end-1)',2);
            stageInputRef  = sum(tildeUref(:,end-1)' * obj.param.R .* tildeUref(:,end-1)',2);
            terminalState = ...
                tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);

            %-- 評価値計算
            eval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
                + terminalState;
        end

        function [xr] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(16, obj.param.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.param.H-1
                t = T + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            end
        end
    end
end
