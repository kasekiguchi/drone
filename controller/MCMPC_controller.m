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
        function obj = MCMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
            obj.param.subCheck = zeros(obj.param.particle_num, 1);
            obj.param.fRemove = 0;

            %%
            obj.input.Initsigma = param.Initsigma;
            obj.input.Constsigma = param.Constsigma;
            obj.input.Evaluationtra = zeros(1, obj.param.particle_num);
%             obj.input.ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]';
%             obj.input.ref_v = [0; 0; 0.50];
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

            obj.param.fRemove = 0;
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
            rng ('shuffle');
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
            if obj.state.predict_state(3, 1, :) < 0
                obj.param.fRemove = 1;
            end
            
            %-- 評価値計算
            for m = 1:obj.input.u_size
                obj.input.eval = obj.objective(m);
                obj.input.Evaluationtra(1,m) = obj.input.eval;
            end
            [Bestcost, BestcostID] = min(obj.input.Evaluationtra);

            %-- 制約条件
%             [removeF] = obj.constraints();
            removeF = 1;
            
            if removeF ~= 0
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
            else
%                 obj.result.input = obj.self.input;
                ConstInput1 = obj.input.sigma.*randn() + obj.param.ref_input(1);
                ConstInput2 = obj.input.sigma.*randn() + obj.param.ref_input(2);
                ConstInput3 = obj.input.sigma.*randn() + obj.param.ref_input(3);
                ConstInput4 = obj.input.sigma.*randn() + obj.param.ref_input(4);
                obj.result.input = [ConstInput1; ConstInput2; ConstInput3; ConstInput4];
                obj.input.nextsigma = obj.input.Constsigma;
            end
            obj.result.removeF = removeF;
            
            obj.self.input = obj.result.input;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.sigma = obj.input.nextsigma;
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.bestcost = Bestcost;
            result = obj.result;  
        end
        function show(obj)
            obj.result
        end

        function [removeF] = constraints(obj)
%             NP = obj.param.particle_num;
            % 状態制約
            removeFe = (obj.state.state_data(2, 1, :) >= 0.2);
            % 棄却するサンプル番号を算出
            removeX = find(removeFe);
%             Fe_size = size(removeFe_check);
            % サンプル番号の重なりをなくす
%             removeX = unique(removeFe_check);
            % 制約違反の入力サンプル(入力列)を棄却
            obj.input.u(:,:,removeX) = NaN;
            obj.state.state_data(:, :, removeX) = NaN;
            % 全制約違反による分散リセットを確認するフラグ  
%             if isnan(obj.input.u(:, :, removeX)); obj.input.u(:, :, removeX) = []; end
%             if isnan(obj.state.state_data(:, :, removeX)); obj.state.state_data(:, :, removeX) = []; end
            removeF = obj.param.particle_num - size(removeX, 1); % 0 -> 全棄却
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
                end
            end
            predict_state = obj.state.state_data;
            subCheck = obj.param.subCheck;
        end
        function [MCeval] = objective(obj, m)   % obj.~とする
            X = obj.state.state_data;       %12 * 10
            U = obj.input.u(:,:,m);         %12 * 10

            %% xr
            tildeXp = X(1:3,:,m) - obj.state.ref(1:3, :);  % 位置   agent.refenrece.result.state.p
            tildeXq = X(4:6,:,m) - obj.state.ref(4:6, :);
            tildeXv = X(7:9,:,m) - obj.state.ref(7:9, :);  % 速度
            tildeXw = X(10:12,:,m) - obj.state.ref(10:12, :); 

            %%
            tildeXqw = [tildeXq; tildeXw];
            tildeUpre = U - obj.self.input;       % agent.input
            tildeUref = U - obj.state.ref(13:16, :);

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
    end
end

