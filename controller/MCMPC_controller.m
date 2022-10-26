classdef MCMPC_controller <CONTROLLER_CLASS
    % MCMPC_CONTROLLER MCMPCのコントローラー
    
    properties
        options
        param
        previous_state
        input
        state
        reference
        model
        result
        self
    end
    
    methods
        function obj = MCMPC_controller(self, ~)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param.H  = 10;                % モデル予測制御のホライゾン
            obj.param.dt = 0.1;              % モデル予測制御の刻み時間
            obj.param.particle_num = 200;
            obj.param.subCheck = zeros(obj.param.particle_num, 1);
            obj.param.fRemove = 0;
            %重み%
            obj.param.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
            obj.param.V = diag([1.0; 1.0; 1.0]);    % 速度
            obj.param.Q = diag([1.0; 1.0; 1.0]);    % 姿勢角
            obj.param.W = diag([1.0; 1.0; 1.0]);    % 角速度
            obj.param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
            obj.param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差
            obj.param.QW = diag([1.0,; 1.0; 1.0; 1.0; 1.0; 1000.0]);  % 姿勢角、角速度
            obj.input.Initsigma = 0.01;
            obj.input.Evaluationtra = zeros(1, obj.param.particle_num);
            obj.input.ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]';
            obj.input.ref_v = [0; 0; 0.50];
            obj.model = self.model;
            %-- 全予測軌道のパラメータの格納変数を定義 repmat で短縮できるかも
            obj.state.p_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            obj.state.v_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.q_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.w_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
            obj.state.state_data = [obj.state.p_data; obj.state.q_data; obj.state.v_data; obj.state.w_data];  
        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
            idx = param{1};
            xr = param{2};
            obj.state.ref = xr;
            
            if idx == 1
                ave1 = 0.269*9.81/4;      % average
                ave2 = ave1;
                ave3 = ave1;
                ave4 = ave1;
                obj.input.sigma = obj.input.Initsigma;
            else
                ave1 = obj.self.input(1);    % リサンプリングとして前の入力を平均値とする
                ave2 = obj.self.input(2);
                ave3 = obj.self.input(3);
                ave4 = obj.self.input(4);
                if obj.input.nextsigma > 0.5
                    obj.input.nextsigma = 0.5;    % 上限
                elseif obj.input.nextsigma < 0.005
                    obj.input.nextsigma = 0.005;  % 下限
                end
                obj.input.sigma = obj.input.nextsigma;
            end
            obj.input.u1 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave1;
            obj.input.u2 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave2;
            obj.input.u3 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave3;
            obj.input.u4 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave4;
            obj.input.u1(obj.input.u1<0) = 0;   % 負の入力を阻止
            obj.input.u2(obj.input.u2<0) = 0;
            obj.input.u3(obj.input.u3<0) = 0;
            obj.input.u4(obj.input.u4<0) = 0;
            obj.input.u(4, 1:obj.param.H, 1:obj.param.particle_num) = obj.input.u4;   % reshape
            obj.input.u(3, :, :) = obj.input.u3;   
            obj.input.u(2, :, :) = obj.input.u2;
            obj.input.u(1, :, :) = obj.input.u1;
            obj.input.u_size = size(obj.input.u, 3);    % obj.param.particle_num
            obj.previous_state = obj.self.estimator.result.state.get();

            %-- 状態予測
            [obj.state.predict_state, obj.param.subCheck] = obj.predict();
            if obj.param.subCheck == 1
                obj.param.fRemove = 1;
            end
            %-- 評価値計算
            for m = 1:obj.input.u_size
                obj.input.eval = obj.objective(m);
                obj.input.Evaluationtra(1,m) = obj.input.eval;
            end
            [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
            %-- 入力への代入
            obj.result.input = obj.input.u(:, 1, BestcostID);     % 最適な入力の取得
            %-- resampling
            %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
            if idx == 1 || idx == 2 % - 最初は全時刻の評価値がないから現時刻/現時刻にしてる
                obj.input.Bestcost_pre = Bestcost;
                obj.input.Bestcost_now = Bestcost;
            else
                obj.input.Bestcost_pre = obj.input.Bestcost_now;
                obj.input.Bestcost_now = Bestcost;
            end
            obj.input.nextsigma = obj.input.sigma * (obj.input.Bestcost_now/obj.input.Bestcost_pre);
            obj.self.input = obj.result.input;
            obj.result.sigma = obj.input.nextsigma;
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.bestcost = Bestcost;
            result = obj.result;  
        end
        function show(obj)
            obj.result
        end

        function [predict_state, subCheck] = predict(obj)
            ts = 0;
            %-- 予測軌道計算
            for m = 1:obj.input.u_size
                x0 = obj.previous_state;
                obj.state.state_data(:, 1, m) = obj.previous_state;
                for h = 1:obj.param.H-1
                    [~,tmpx]=obj.self.model.solver(@(t,x) obj.self.model.method(x, obj.input.u(:, h, m),obj.self.parameter.get()),[ts ts+obj.param.dt],x0);
                    x0 = tmpx(end, :);
                    obj.state.state_data(:, h+1, m) = x0;

                    %##########2022/10/21#####################
%                     if x0(3) < 0.05
%                         obj.param.subCheck(m) = 1;    % 制約外なら flag = 1
%                         break;              % ホライズン途中でも制約外で終了
%                     end
                    %#########################################
                end
            end
            predict_state = obj.state.state_data;
            subCheck = obj.param.subCheck;
        end
        function [MCeval] = objective(obj, m)   % obj.~とする
            X = obj.state.state_data;       %12 * 10
            U = obj.input.u(:,:,m);         %12 * 10
            
            %-- 状態および入力に対する目標状態や目標入力との誤差計算
            tildeXp = X(1:3,:,m) - obj.state.ref(1:3, :);  % 位置   agent.refenrece.result.state.p
            tildeXv = X(7:9,:,m) - obj.input.ref_v;                           % 速度
            tildeXq = X(4:6,:,m);
            tildeXw = X(10:12,:,m); 
            tildeXqw = [tildeXq; tildeXw];
            tildeUpre = U - obj.self.input;       % agent.input
            tildeUref = U - obj.input.ref_input;

            %-- 状態及び入力のステージコストを計算
            stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
            stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
            stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
            stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
            stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = tildeXp(:, end)' * obj.param.P * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.V   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QW  * tildeXqw(:, end);
            %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef)...
                + terminalState;
        end

%         function xr = generate_reference(obj, t)
%             xr = zeros(3, obj.param.H);
%             rz = 1; % 目標
%             rz0 = 0;% スタート
%             T = 10; % かける時間
%             StartT = 0;
%             a = -2/T^3 * (rz-rz0);
%             b = 3/T^2 * (rz-rz0);
%         %     z = a*(t-StartT)^3+b*(t-StartT)^2+rz0;
%         %     X = subs(z, t, Tv);
%             %-- ホライゾンごとのreference
%             if t <= 10
%                 for h = 1:obj.param.H
%                     xr(:, h) = [0;0;a*((t-StartT)+obj.param.dt*h)^3+b*((t-StartT)+obj.param.dt*h)^2+rz0];
%                 end
%             else
%                 for h = 1:obj.param.H
%                     xr(:, h) = [0;0;1];
%                 end
%             end
%         end
    end
end

