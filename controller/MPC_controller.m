classdef MPC_CONTROLLER <handle
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
        modelf
        modelp
    end

    methods
        function obj = MPC_CONTROLLER(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            obj.modelf = obj.self.plant.method;
            obj.modelp = obj.self.parameter.get();

            %%
            obj.input = obj.param.input;
            % obj.const = param.const;
            % obj.input.v = obj.modelp(1) * 9.81 / 4 * [1;0;0;0];   % 表示用
            obj.param.H = obj.param.H + 1;
            obj.model = self.plant;
            obj.param.fRemove = 0;
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合
            obj.param.Weight = blkdiag(obj.param.P, obj.param.Q, obj.param.V, obj.param.W);
            obj.param.Weightf = blkdiag(obj.param.P, obj.param.Qf, obj.param.Vf, obj.param.Wf);
            
            obj.previous_input = repmat(obj.input.u, 1, obj.param.H); 

            %% input transform
            % obj.input.IT = [1 1 1 1;-obj.self.parameter.ly, -obj.self.parameter.ly, (obj.self.parameter.Ly - obj.self.parameter.ly), (obj.self.parameter.Ly - obj.self.parameter.ly); obj.self.parameter.lx, -(obj.self.parameter.Lx-obj.self.parameter.lx), obj.self.parameter.lx, -(obj.self.parameter.Lx-obj.self.parameter.lx); obj.self.parameter.km1, -obj.self.parameter.km2, -obj.self.parameter.km3, obj.self.parameter.km4];
        end

        %-- main()的な
        function result = do(obj,varargin)
            % tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            obj.param.t = varargin{1}.t;
            rt = obj.param.t;

            obj.state.ref = obj.Reference(rt);
            obj.current_state = obj.self.estimator.result.state.get();

            % MPC設定(problem)
            %-- fmincon 設定
            options = optimoptions('fmincon');
            options = optimoptions(options,'MaxIterations',         1.e+12); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-4);     % 制約違反に対する許容誤差

            options.Algorithm = 'sqp';  % 逐次二次計画法
            options.Display = 'none';   % 計算結果の表示

            %% conditions
            fun = @obj.objective;
            x0 = obj.previous_input;
            A = []; b = []; Aeq = []; beq = []; 
            lb = repmat(obj.param.input_min, 1,obj.param.H); % min
            ub = repmat(obj.param.input_max, 1,obj.param.H); % max
            nonlcon = [];
            [var, ~, exitflag, ~, ~, ~, ~] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

            %%
            obj.previous_input = var;
            obj.result.input = var(:, 1); % 算出された入力

            %% データ表示用
            obj.input.u = obj.result.input; 
            % obj.input.v = obj.input.IT * obj.input.u; % トルク変換

            %% 保存するデータ
            result = obj.result; % controllerの値の保存

            %% 情報表示
            est_print = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                    est_print.p(1), est_print.p(2), est_print.p(3),...
                    est_print.v(1), est_print.v(2), est_print.v(3),...
                    est_print.q(1)*180/pi, est_print.q(2)*180/pi, est_print.q(3)*180/pi); % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                    obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
                    obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
                    obj.state.ref(4,1)*180/pi, obj.state.ref(5,1)*180/pi, obj.state.ref(6,1)*180/pi)                             % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t flag: %d", ...
                rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), exitflag);
            fprintf("\n");
            % toc

            %% z < 0で終了
            if obj.self.estimator.result.state.p(3) < 0
                warning("Z < 0")
            end
        end
        function show(obj)
            obj.result
        end

        function [eval] = objective(obj,x)   % obj.~とする
            U = x;
            X(:,1) = obj.current_state;
            for L = 2:obj.param.H
                X(:,L) = X(:,L-1) + obj.param.dt * obj.modelf(X(:,L-1), U(:,L-1), obj.modelp);
            end

            tildeX = X - obj.state.ref(1:12,:);
            tildeUpre = U - obj.input.u;
            tildeUref = U - obj.state.ref(13:16,:);

            stageState = tildeX(:,end-1)' * obj.param.Weight    * tildeX(:,end-1);
            stageInputPre  = tildeUpre(:,end-1)' * obj.param.RP * tildeUpre(:,end-1);
            stageInputRef  = tildeUref(:,end-1)' * obj.param.R  * tildeUref(:,end-1);
            terminalState = tildeX(:,end)' * obj.param.Weightf * tildeX(:,end);

            eval = stageState + stageInputPre + stageInputRef + terminalState;
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
