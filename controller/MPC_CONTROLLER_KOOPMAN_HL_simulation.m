classdef MPC_CONTROLLER_KOOPMAN_HL_simulation < handle
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
        weight
        weightF
        weightR
        A
        B
        C
        H
        qpparam
    end

    properties
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_HL_simulation(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存
            obj.H = obj.param.H;

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.H);
            obj.weight = blkdiag(obj.param.weight.P, obj.param.weight.Q, obj.param.weight.V, obj.param.weight.W);
            obj.weightF = blkdiag(obj.param.weight.Pf, obj.param.weight.Qf, obj.param.weight.Vf, obj.param.weight.Wf);
            obj.weightR = obj.param.weight.R;

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
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            obj.param.t = varargin{1}{1}.t;
            rt = obj.param.t; %時間
            idx = round(rt/varargin{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            [obj.reference.xr, obj.reference.xr_HL] = obj.Reference(rt); %リファレンスの更新
 
            obj.previous_state = repmat(obj.current_state, 1, obj.H);

            %% HLによる入力計算
            obj.input.u_HL = obj.calculateHL(varargin);

            %% HLとの状態比較を初期値としたクープマンMPCの計算
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
            % problem.nonlcon   = @(x) obj.constraints(x);
            [var, fval, exitflag, ~, ~, ~, ~] = fmincon(problem);
                 
            %%
            obj.previous_input = var;
            obj.result.input = var(1:4, 1); % 印加する入力 4入力

            %% データ表示用
            obj.input.u = obj.result.input; 
            calT = toc
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存

            %% 情報表示
            % state_monte = obj.self.estimator.result.state;
            if idx == 1; state_monte = obj.self.estimator.result.state;
            else; state_monte = obj.self.plant.result; end
            
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
                    state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
                    obj.reference.xr(1,1), obj.reference.xr(2,1), obj.reference.xr(3,1),...
                    obj.reference.xr(7,1), obj.reference.xr(8,1), obj.reference.xr(9,1),...
                    obj.reference.xr(4,1), obj.reference.xr(5,1), obj.reference.xr(6,1), ...
                    obj.reference.xr(10,1), obj.reference.xr(11,1), obj.reference.xr(12,1))  % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
                rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            fprintf("\n");
            % profile viewer

            %% z < 0で終了
            if obj.self.estimator.result.state < 0
                warning("墜落しました")
            end
            
        end
        function show(obj)
            obj.result
        end

        function eval = objective(obj,u)
            %-- initialize
            z0 = quaternions_all(obj.current_state);
            Z = [z0, zeros(size(z0,1),obj.H-1)];
            for i = 1:obj.H-2
                Z(:,i+1) = obj.A*Z(:,i) + obj.B*u(:,i);
            end
            X = [obj.current_state,obj.C*Z]; % x[k] = Cz[k]
        
            tildeXp = X(1:3, :) - obj.reference.xr_HL(1:3, :);  % 位置
            tildeXq = X(4:6, :) - [0;0;0];
            tildeXv = X(7:9, :) - obj.reference.xr_HL(5:7, :);  % 速度
            tildeXw = X(10:12, :) - [0;0;0];
            % tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
            tildeUref = u(:, :) - [0;0;0;0];
            
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

        % function constraints(obj)
        % end

        function u_HL = calculateHL(obj, varargin)
            model = obj.self.estimator.result;
            % ref = obj.self.reference.result;
            % xd = ref.state.xd;
            xd = obj.reference.xr_HL;
            xd0 =xd;
            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

            % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
            % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            %if isfield(obj.param,'dt')
            if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
                dt = varargin{1}.dt;
            else
                dt = obj.param.dt;
                % vf = Vf(x,xd',P,F1);
                % vs = Vs(x,xd',vf,P,F2,F3,F4);
            end
            vf = Vfd(dt,x,xd',P,F1);
            vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
            %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            % max,min are applied for the safty
            u_HL = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        end

        % function xr_HL = Reference_HL(obj, T)
        %     ref = obj.reference.xr;
        %     xr_HL = [ref(1:3); 0; ref(7:9); 0;];
        %     %% ReferenceでのRefTimeはHLで必要なreferenceの構成になっているのでは？
        %     %% これを転用できるならすばらしい．
        % end

        function [xr, xr_HL] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.H);    % initialize
            xr_HL = zeros(16, 1);
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
            xr_HL(1:16, 1) = ref(1:16);
        end
    end
end
