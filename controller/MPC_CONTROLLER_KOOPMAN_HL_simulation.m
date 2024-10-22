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

            classlist = ["TIME_VARYING_REFERENCE", "MY_POINT_REFERENCE", "MY_REFERENCE_KOMA2"];
            classname = class(obj.self.reference);
            obj.reference.classnum = find(strcmp(classname, classlist));

            % 1ステップ前の状態の保存
            % state = obj.self.estimator.result.state.get();
            % q p v w
            % value=Eul2Quat(state(4:6));
            % obj.state.previous.q = RodriguesQuaternion(Eul2Quat(state(4:6)));
            % obj.state.previous.pvw = [state(1:3);state(7:9);state(10:12)];
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            if size(varargin, 2) ~= 4
                %% 2コン l.109
                var = varargin{1};
            else 
                %% 1コン l.108
                var = varargin;
            end

            obj.param.t = var{1}.t;
            rt = obj.param.t; %時間
            idx = round(rt/var{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            [obj.reference.xr, obj.reference.xr_HL] = obj.Reference(rt); %リファレンスの更新

            %% HLによる入力計算
            if size(varargin, 2) ~= 4
                obj.input.u_HL = obj.self.controller.hlc.result.input; % 2コン
                % obj.input.u_HL = obj.self.controller.result.input; % 前の入力の取得 controller.resultに保存されてないからできない
                % obj.input.u_HL = var{3}.controller.hlc.result.input;
            else
                % state.p = obj.current_state(1:3); state.v = obj.current_state(7:9);
                % state.q = obj.current_state(4:6); state.w = obj.current_state(10:12);
                obj.input.u_HL = obj.calculateHL(var); % controllerで同時計算
            end

            % 次時刻状態の計算
            x = obj.current_state;
            u = obj.input.u_HL;
            P = obj.param.P;
            tspan = [0 0.025];
            x0 = x;
            [~,tmpx]=ode15s(@(t,x) obj.self.plant.method(x,u,P),tspan, x0); % 非線形モデル
            obj.state.HL = tmpx(end, :);

            %% HLとの状態比較を初期値としたクープマンMPCの計算
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
                 
            %%
            obj.previous_input = var;
            u = var(1:4,1) + obj.input.u_HL; % 印加する入力 4入力
            % u = var(1:4,1);

            %% 入力の封じ込め
            % obj.result.input = [max(0, min(10, u(1)));max(-1, min(1, u(2:4)))];
            obj.result.input = u;

            %% データ表示用
            obj.input.u = obj.result.input; 
            calT = toc;
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存
            % obj.self.input  = obj.result.input;

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
            % fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
            %     rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            fprintf("t: %f \t calT: %f \t fval: %f \t flag: %d \n", rt, calT, fval, exitflag);
            fprintf("u: %f %f %f %f \t diff_u: %f %f %f %f", obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), var(1,1), var(2,1), var(3,1), var(4,1));
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

        function u_HL = calculateHL(obj, var)
            % model = obj.self.estimator.result;
            model.q = RodriguesQuaternion(Eul2Quat(var{4}.state.get("q")));
            model.pvw = var{4}.state.get(["p","v","q"]); 
            % m:1時刻前のestimator
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
            x = [R2q(Rb0'*model.q);Rb0'*model.pvw(1:3);Rb0'*model.pvw(4:6);model.pvw(7:9)];
            % x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            %if isfield(obj.param,'dt')
            if isfield(var{1},'dt') && var{1}.dt <= obj.param.dt
                dt = var{1}.dt;
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

        function [xr, xr_HL] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.H);    % initialize
            xr_HL = zeros(16, 1);
       
            % 時間関数の取得→時間を代入してリファレンス生成
            % P2P等は値を持ってきてホライズン分拡張
            % 1:timevarying
            % 2:P2P
            % 3:9-order polynomial
            if obj.reference.classnum == 1 % time varying
                RefTime = obj.self.reference.func;
                for h = 0:obj.H-1
                t = T + obj.param.dt * h;
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0];
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input;
                end
            elseif obj.reference.classnum == 2 % P2P
                ref = repmat(obj.self.reference.result.state.get(),1,obj.H);
                xr(1:3,:) = ref(12:14,:);
                xr(4:6,:) = ref(15:17,:);
                xr(7:9,:) = ref( 9:11,:);
                xr(10:12,:)=zeros(3,obj.H);
                xr(13:16,:)=repmat(obj.param.ref_input,1,obj.H);
            elseif obj.reference.classnum == 3 % 9-order polynomial
                ref = repmat(obj.self.reference.result.state.get(),1,obj.H);
                xr(1:9,:) = ref(1:9,:);
                xr(10:12,:)=zeros(3,obj.H);
                xr(13:16,:)=repmat(obj.param.ref_input,1,obj.H);
            end
            xr_HL(1:16, 1) = xr(1:16, 1);
        end
    end
end
