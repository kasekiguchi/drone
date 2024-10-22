classdef MPC_CONTROLLER_KOOPMAN_quadprog_experiment < handle
    % MCMPC_CONTROLLER MPCのコントローラー
    % Imai Case study 
    % 勾配MPCコントローラー

    properties
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

    properties
        A
        B
        C
        H
        weight
        weightF
        weightR
        qpparam
    end

    properties
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_quadprog_experiment(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存
            obj.H = obj.param.H;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.H);
            obj.weight = blkdiag(obj.param.weight.P, obj.param.weight.Q, obj.param.weight.V, obj.param.weight.W);
            obj.weightF = blkdiag(obj.param.weight.Pf, obj.param.weight.Qf, obj.param.weight.Vf, obj.param.weight.Wf);
            obj.weightR = obj.param.weight.R;

            %% A行列にxyzの位置を加えた拡張係数行列とする
            % A_1 = [eye(3), zeros(3), eye(3)*obj.param.dt, zeros(3, size(obj.A,1)-6)];
            % A_2 = [zeros(size(obj.A,2), 3), obj.A];
            % obj.param.A = [A_1; A_2];
            % obj.param.B = [zeros(3, 4); obj.B];
            % obj.param.C = blkdiag(eye(3), obj.C);

            %% QP change_equationの共通項をあらかじめ計算
            Param = struct('A',obj.param.A,'B',obj.param.B,'C',obj.param.C,'weight',obj.weight,'weightF',obj.weightF,'weightR',obj.weightR,'H',obj.H);
            [obj.qpparam.H, obj.qpparam.F] = change_equation_drone(Param);
            % H: 変数
            % F: fを生成するために必要な行列
            obj.result.setting.weight = struct('Q',obj.weight,'Qf',obj.weightF,'R',obj.weightR);
            obj.result.setting.A = obj.param.A;
            obj.result.setting.B = obj.param.B;
            obj.result.setting.C = obj.param.C;

            obj.param.P = [0.5 0.16	0.16 0.08 0.08 0.06	0.06 0.06 9.81 0.0301 0.0301 0.0301	0.0301 8.0e-06 8.0e-06 8.0e-06 8.0e-06];
            % obj.param.P = self.parameter.get(obj.parameter_name);

            classlist = ["TIME_VARYING_REFERENCE", "MY_POINT_REFERENCE", "MY_REFERENCE_KOMA2"];
            classname = class(obj.self.reference);
            obj.reference.classnum = find(strcmp(classname, classlist));

            % 誤差モデル
            obj.param.plant = @roll_pitch_yaw_thrust_torque_physical_parameter_model;
        end

        %-- main()的な
        function result = do(obj,varargin)
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            vara = varargin{1};
            obj.param.t = vara{1}.t;
            rt = obj.param.t; %時間
            % idx = round(rt/vara{1}.dt+1); %プログラムの周回数

            %各phaseでのリファレンスと現在状態の更新--------------------------------------------------
            % arming，take offではリファレンスと現在状態の値を固定することで計算破綻を防いでいる
            if vara{2} == 'a'
                obj.reference.xr = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input],1,obj.H);
                obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
            elseif vara{2} == 't'
                obj.reference.xr = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input],1,obj.H);
                obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
                % fprintf('take off\n')
            elseif vara{2} == 'f'
                obj.reference.xr = obj.Reference(rt); %リファレンスの更新
                obj.current_state = obj.self.estimator.result.state.get(); %現在状態
                % fprintf('flight\n')
            end

            %% ------------------------------------------------------------  
            % obj.previous_state = repmat(obj.current_state, 1, obj.H);
            % 
            % % 最適化部分の関数化とmex化
            % Param = struct('current_state',obj.current_state,'ref',obj.reference.xr,'qpH', obj.qpparam.H, 'qpF', obj.qpparam.F,'lb',obj.param.input.lb,'ub',obj.param.input.ub,'previous_input',obj.previous_input,'H',obj.H);
            % [var, fval, exitflag] = obj.param.quad_drone(Param); %自PCでcontroller:0.6ms, 全体:2.7ms
            % % [var, fval, exitflag] = quad_drone(Param);
            % u = var(1:4,1);

            %% 誤差モデル
            % 次時刻状態の計算
            obj.input.u_HL = obj.self.controller.hlc.result.input; % 2コン
            x = obj.current_state;
            u = obj.input.u_HL;
            P = obj.param.P;
            tspan = [0 0.025];
            x0 = x;
            [~,tmpx]=ode15s(@(t,x) obj.param.plant(x,u,P),tspan, x0); % 非線形モデル
            obj.state.HL = tmpx(end, :);

            % HLとの状態比較を初期値としたクープマンMPCの計算
            obj.previous_state = repmat(obj.current_state, 1, obj.H);
            %-- fmincon 設定
            options = optimoptions('fmincon');
            options = optimoptions(options,'MaxIterations',      1.e+12); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-4);  % 制約違反に対する許容誤差

            %-- fmincon設定
            options.Algorithm = 'sqp';  % 逐次二次計画法
            options.Display = 'none';   % 計算結果の表示
            problem.solver = 'fmincon'; % solver
            problem.options = options;  %
            % problem.x0		  = [obj.previous_state; obj.previous_input];
            problem.x0        = [obj.previous_input];

            %-- fmincon
            problem.objective = @(x) obj.objective(x); 
            problem.nonlcon   = @(x) obj.constraints(x);
            [var, fval, exitflag, ~, ~, ~, ~] = fmincon(problem);

            %
            obj.previous_input = var;
            u = var(1:4,1) + obj.input.u_HL; % 印加する入力 4入力
      
            %%
            obj.previous_input = var;
            if vara{2} == 'a'
                obj.result.input = [0;0;0;0]; % arming時には入力0で固定
            else
                obj.result.input = u; % 印加する入力 4入力
            end

            %% データ表示用
            calT = toc;
            obj.input.u = obj.result.input; 
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存

            %% 情報表示
            % state_monte = obj.self.estimator.result.state;
            % fprintf("==================================================================\n")
            % fprintf("==================================================================\n")
            % fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
            %         state_monte.p(1), state_monte.p(2), state_monte.p(3),...
            %         state_monte.v(1), state_monte.v(2), state_monte.v(3),...
            %         state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
            %         state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            % fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
            %         obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
            %         obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
            %         obj.state.ref(4,1), obj.state.ref(5,1), obj.state.ref(6,1), ...
            %         obj.state.ref(10,1), obj.state.ref(11,1), obj.state.ref(12,1))  % r:reference 目標状態
            % fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
            %     rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            % fprintf("\n");

            %% z < 0で終了
            if obj.self.estimator.result.state < 0
                warning("墜落しました")
            end
            
        end
        function show(obj)
            obj.result
        end

        function [c, ceq] = constraints(obj, U)
            uhl = obj.input.u_HL; % HLの入力
            % umin = obj.input.lb; 
            umax = obj.input.ub; % 最大最小
            % 最適化可能な入力の範囲を計算する
            able = umax - uhl; % 4x1
            % U < able
            c = [U-able];

            %defalut
            % % 不等式制約 c < 0
            % c = [U(1,:)-10; -U(1,:); U(2:4,:)-1; -(U(2:4,:)+1)];
            % 等式制約  ceq = 0
            ceq = [];
        end

        function eval = objective(obj,u)
            %-- initialize
            error_HL = obj.current_state - obj.state.HL'; % obj.state.HLにするとほぼHLでまわる
            z0 = quaternions_all(error_HL);
            Z = [z0, zeros(size(z0,1),obj.H-1)];
            for i = 1:obj.H-2
                Z(:,i+1) = obj.A*Z(:,i) + obj.B*u(:,i);
            end
            x = obj.C*Z; % x[k] = Cz[k] 

            % そのままのリファレンスで評価
            % X = obj.state.HL' + x; % ここの4つだとなんかKMPCが入る
            % Utmp = obj.input.u_HL + u;
            % U = [max(0,min(10,Utmp(1,:))); max(-1,min(1,Utmp(2:4,:)))];
            % ref = obj.reference.xr(1:16,:);

            % 誤差モデルのまま評価
            X = x;
            % U = [max(0,min(10,u(1,:))); max(-1,min(1,u(2:4,:)))];
            U = u;
            ref(1:12,:) = obj.reference.xr(1:12,:) - obj.state.HL';
            ref(13:16,:) = obj.reference.xr(13:16,:);

            % X = [error_HL, x]; % ここの三つだとほぼHL
            % U = u;
            % ref = obj.reference.xr(1:12,1) - obj.current_state; % 現在状態と目標状態の誤差
            % ref = obj.reference.xr(1:12,1) - obj.state.HL'; % 目標状態とHLの時間発展の誤差
        
            tildeXp = X(1:3, :) - ref(1:3,:);  % 位置
            tildeXq = X(4:6, :) - ref(4:6,:);
            tildeXv = X(7:9, :) - ref(7:9,:);  % 速度
            tildeXw = X(10:12, :) - ref(10:12,:);
            tildeUref = U(:, :) - ref(13:16,:);
            % tildeUref = U;
            
        %-- 状態及び入力のステージコストを計算 長くなるから分割
            stagestateP = tildeXp(:, 1:obj.H-1)'*obj.param.weight.P*tildeXp(:, 1:obj.H-1);
            stagestateV = tildeXv(:, 1:obj.H-1)'*obj.param.weight.V*tildeXv(:, 1:obj.H-1);
            stagestateQ = tildeXq(:, 1:obj.H-1)'*obj.param.weight.Q*tildeXq(:, 1:obj.H-1);
            stagestateW = tildeXw(:, 1:obj.H-1)'*obj.param.weight.W*tildeXw(:, 1:obj.H-1);
            stageinputR = tildeUref(:, 1:obj.H-1)'*obj.param.weight.R*tildeUref(:, 1:obj.H-1);
            
            stagestateP = diag(stagestateP);
            stagestateV = diag(stagestateV);
            stagestateQ = diag(stagestateQ);
            stagestateW = diag(stagestateW);
            stagestateX = stagestateP' + stagestateV' + stagestateQ' + stagestateW';
            stageinputR = diag(stageinputR);
            
            stagestate = stagestateX + stageinputR'; %ステージコスト
            
        %-- 状態の終端コストを計算
            terminalstate =  tildeXp(:, end)' * obj.param.weight.Pf * tildeXp(:, end)...
                            +tildeXv(:, end)' * obj.param.weight.Vf * tildeXv(:, end)...
                            +tildeXq(:, end)' * obj.param.weight.Qf * tildeXq(:, end)...
                            +tildeXw(:, end)' * obj.param.weight.Wf * tildeXw(:, end); 
        
        %-- 評価値計算
            eval = sum(stagestate) + terminalstate;
        end

        function [xr] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.H-1
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
