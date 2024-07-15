classdef MPC_CONTROLLER_KOOPMAN_quadprog_simulation < handle
    % MCMPC_CONTROLLER MPCのコントローラー
    % Imai Case study 
    % 勾配MPCコントローラー

    properties % 特性
%         options
        param
        current_state
        previous_input
        previous_state
        input
        state
        const
        reference
        fRemove
        model
        result
        self
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_quadprog_simulation(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.param.H);
        end

        %-- main()的な
        function result = do(obj,varargin)
            %profile on 
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            obj.param.t = varargin{1}.t;
            rt = obj.param.t; %時間
            idx = round(rt/varargin{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            obj.state.ref = obj.Reference(rt); %リファレンスの更新
            Param = obj.param;
            Param.current = obj.current_state;
            Param.ref = obj.state.ref;        
            obj.previous_state = repmat(obj.current_state, 1, obj.param.H);
            
            % MPC設定(problem)
            options = optimoptions('quadprog');
            options = optimoptions(options,'MaxIterations',      1.e+9); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-5);     % 制約違反に対する許容誤差

            %-- quadprog設定
            options.Display = 'none';   % 計算結果の表示
            problem.solver = 'quadprog'; % solver

            [H, f] = change_equation(Param);
            A = [];
            b = [];
            Aeq = [];
            beq = [];
            lb = [];
            ub = [];
            x0 = [obj.previous_input(:)];

            [var, fval, exitflag, ~, ~] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options, problem); %最適化計算
             %%
%       BEGIN_ACADO;                                % 常に "BEGIN_ACADO "で始める。Always start with "BEGIN_ACADO". 
% 
%     acadoSet('problemname', 'QP_optimization');     % 問題名を設定します。これを省略すると、すべてのファイルの名前は "myAcadoProblem" になります。
%                                                     % Set your problemname. If you skip this, all files will be named "myAcadoProblem"                                            
% 
%     % DifferentialState       x;              % 微分状態　The differential states
%     % Control                 u;              % 制御　The controls
%     % Disturbance             w;              % ノイズ　The disturbances
%     % Parameter               p q;            % 自由パラメータ　The free parameters
% 
%                 %% MPC設定(problem)
%             options = optimoptions('quadprog');
%             options = optimoptions(options,'MaxIterations',      1.e+9); % 最大反復回数
%             options = optimoptions(options,'ConstraintTolerance',1.e-5);     % 制約違反に対する許容誤差
% 
%             %-- quadprog設定
%             options.Display = 'none';   % 計算結果の表示
%             problem.solver = 'quadprog'; % solver
% 
%             [H, f] = change_equation(Param);
%             A = [];
%             b = [];
%             Aeq = [];
%             beq = [];
%             lb = [];
%             ub = [];
%             x0 = [obj.previous_input(:)];
% 
%             [var, fval, exitflag, ~, ~] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options, problem); %最適化計算
%     %% Differential Equation　微分方程式
%     f = acado.DifferentialEquation();       % 微分方程式オブジェクトを設定するSet the differential equation object
% 
%     %f.add(dot(x) == -x*x + p + u*u + w);    % ODEを書き出してください。複数の状態がある場合、f.add()で複数のODEを追加することができます。ODEを画面に表示するには、f.differentialList{1}.toStringを使います。
%                                             % Write down your ODE. You can add multiple ODE's with f.add() when you have multiple states. To print an ODE to the screen, use　f.differentialList{1}.toString
% 
% 
%     %% Optimal Control Problem　最適制御問題
%     ocp = acado.OCP(0.0, 1.0, 20);          % 最適制御問題（OCP）の設定 Set up the Optimal Control Problem (OCP)
%                                             % 0秒でスタート、20秒でコントロール Start at 0s, control in 20
%                                             % 最大1秒間隔 intervals upto 1s
% 
%     %ocp.minimizeMayerTerm(x - p*p + q^2);   % メイヤー項の最小化 Minimize a Mayer term
% 
%     ocp.subjectTo( f );                     % OCPは常に微分方程式に従う。
%                                             % Your OCP is always subject to your differential equation
% 
%     % ocp.subjectTo( 'AT_START', x == 1.0 );  % 初期状態　Initial condition
%     % ocp.subjectTo(  0.1 <= p <= 2.0 );      % 限度　Bounds
%     % ocp.subjectTo(  0.1 <= u <= 2.0 );
%     % ocp.subjectTo( -0.1 <= w <= 2.1 );
% 
% 
%     %% Optimization Algorithm　最適化アルゴリズム
%     algo = acado.OptimizationAlgorithm(ocp); % 最適化アルゴリズムの設定　Set up the optimization algorithm
% 
%     algo.set('INTEGRATOR_TOLERANCE', 1e-5 ); % アルゴリズムのパラメーターを設定する　Set some parameters for the algorithm
% 
% 
% END_ACADO;           % 常に "END_ACADO "で終わる。Always end with "END_ACADO".
%                      % これでproblemname_ACADO.mが生成される。This will generate a file problemname_ACADO.m. 
%                      % このファイルを実行して結果を得る。Run this file to get your results. 
%                      % ファイルproblemname_ACADO.mは何度でも実行できる。を何度でも実行することができる。
%                      % You can run the file problemname_ACADO.m as many times as you want without having to compile again.
% 
% 
% 
% out = QP_optimization_RUN();                % テストを実行する。RUNファイルの名前はproblemname_RUNなので、この場合はget_started_RUNとなる。
%                                             % Run the test. The name of the RUN file is problemname_RUN, so in this case getting_started_RUN
% 
% %draw;
            %%
            obj.previous_input = var;
            obj.result.input = var(1:4, 1); % 印加する入力 4入力

            %% データ表示用
            obj.input.u = obj.result.input; 
            calT = toc
            % obj.result.t(1,idx) = calT; %計算時間保存したいときコメントイン

            %% 保存するデータ
            obj.result.weight = Param.weight; %重みの保存
            result = obj.result; % controllerの値の保存

            %% 情報表示
            state_monte = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
                    state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
                    obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
                    obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
                    obj.state.ref(4,1), obj.state.ref(5,1), obj.state.ref(6,1), ...
                    obj.state.ref(10,1), obj.state.ref(11,1), obj.state.ref(12,1))  % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
                rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
%             fprintf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            fprintf("\n");

            %% z < 0で終了
            if obj.self.estimator.result.state < 0
                warning("墜落しました")
            end
            %profile viewer
        end
        function show(obj)
            obj.result
        end

        function [xr] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.param.H);    % initialize
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
