classdef MCMPC_controller_par <CONTROLLER_CLASS
    % MCMPC_CONTROLLER MCMPCのコントローラー
    
    properties
        options
        param
        previous_state
        input
        state
        const
        reference
        model
        result
        self
    end
    properties
      modelf
      modelp
      N % 現時刻のパーティクル数
    end
    
    methods
        function obj = MCMPC_controller_par(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
%             obj.param.subCheck = zeros(obj.N, 1);
            obj.modelp = obj.self.parameter.get();
            obj.modelf = obj.self.model.method;
            
            %%
            obj.input = param.input;
            obj.const = param.const;
            obj.input.nextsigma = param.input.Initsigma;  % 初期化
            % 追加
            obj.param.nextparticle_num = param.Maxparticle_num;   % 初期化
            obj.input.Bestcost_now = 1e2;% 十分大きい値にする  初期周期での比較用

            %             obj.input.Evaluationtra = zeros(1, obj.N);
            obj.model = self.model;
            
            obj.param.fRemove = 0;
            obj.input.AllRemove = 0;

            obj.N = param.particle_num;
            n = 12; % 状態数
            obj.state.state_data = zeros(n,obj.param.H, obj.N);
            obj.input.Evaluationtra = zeros(1, obj.N);

        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
%           profile on
            idx = param{1};
            xr = param{2};
            rt = param{3};
            phase = param{4};
            obj.state.ref = xr;
            obj.param.t = rt;
% 
%             if phase == 1
%                 obj.param.QW = diag([1000; 1000; 100; 1; 1; 1]);
%             end

            ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
            ave2 = obj.input.u(2);    % 初期値はparamで定義
            ave3 = obj.input.u(3);
            ave4 = obj.input.u(4);
            % 標準偏差，サンプル数の更新
            obj.input.sigma = obj.input.nextsigma;
            obj.N = obj.param.nextparticle_num;         

            if obj.input.AllRemove == 1
                ave1 = 0.269*9.81/4;
                ave2 = ave1;
                ave3 = ave1;
                ave4 = ave1;
                obj.input.AllRemove = 0;
            end

            obj.input.u1 = max(0,obj.input.sigma(1).*randn(obj.param.H, obj.N) + ave1); % 負入力の阻止
            obj.input.u2 = max(0,obj.input.sigma(2).*randn(obj.param.H, obj.N) + ave2);
            obj.input.u3 = max(0,obj.input.sigma(3).*randn(obj.param.H, obj.N) + ave3);
            obj.input.u4 = max(0,obj.input.sigma(4).*randn(obj.param.H, obj.N) + ave4);
            obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
            obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;   
            obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
            obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

            obj.previous_state = obj.self.estimator.result.state.get();

            %-- 状態予測
            [obj.state.predict_state] = obj.predict();
            if obj.state.predict_state(3, 1, :) < 0
                obj.param.fRemove = 1;
            end

            %-- 評価値計算
            for m = 1:obj.N
                obj.input.eval(1,m) = obj.objective(m);
%                 obj.input.Evaluationtra(1,m) = obj.input.eval;
            end
            obj.input.Evaluationtra = obj.input.eval(1, 1:obj.N);
            
            % 評価値の正規化
            obj.input.normE = obj.Normalize();

            %-- 制約条件
            removeF = 0; removeX = []; survive = obj.N; 
%             if obj.self.estimator.result.state.p(3) < 0.3
%                 [removeF, removeX, survive] = obj.constraints();
%             end
            obj.state.COG.g = 0; obj.state.COG.gc = 0;
            

            if removeF ~= obj.N
                [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
                obj.result.input = obj.input.u(:, 1, BestcostID);     % 最適な入力の取得
                %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，
                % 評価が良くなったら標準偏差を狭めるようにしている
                obj.input.Bestcost_pre = obj.input.Bestcost_now;
                obj.input.Bestcost_now = Bestcost;
                
                % 棄却数がサンプル数の半分以上なら入力増やす
                if removeF > obj.N /2
                    obj.input.nextsigma = obj.input.Constsigma;
                    obj.param.nextparticle_num = obj.param.Maxparticle_num;
                    obj.input.AllRemove = 1;
                else
                    obj.input.nextsigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma * (obj.input.Bestcost_now/obj.input.Bestcost_pre)));
                    % 追加
                    obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now/obj.input.Bestcost_pre))));
                end

            elseif removeF == obj.N    % 全棄却
                obj.result.input = obj.self.input;
                obj.input.nextsigma = obj.input.Constsigma;
                Bestcost = obj.param.ConstEval;
                BestcostID = 1;
                obj.input.AllRemove = 1;

                % 追加
                obj.param.nextparticle_num = obj.param.Maxparticle_num;
            end
            obj.input.u = obj.result.input;

%             if Bestcost > obj.param.ConstEval; Bestcost = obj.param.ConstEval;  end
            obj.result.input_v = [0;0;0;0];
            obj.result.removeF = removeF;
            obj.result.removeX = removeX;
            obj.result.survive = survive;
            obj.result.COG = obj.state.COG;
            obj.self.input = obj.result.input;
            obj.result.BestcostID = BestcostID;
            obj.result.bestcost = Bestcost;
            obj.result.contParam = obj.param;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.path = obj.state.state_data;
            obj.result.sigma = obj.input.sigma;
            obj.result.variable_N = obj.N; % 追加
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.Evaluationtra_norm = obj.input.normE;
            
            result = obj.result;  
%             profile viewer
        end
        function show(obj)
            obj.result
%             view([2]);
        end

        %-- 制約とその重心計算 --%
        function [removeF, removeX, survive] = constraints(obj)
            % 状態制約
%             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(1, end, :) < 0);
%             removeFe = (obj.state.state_data(1, end, :) <= -0.5);
%             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(2, end, :) <= obj.const.Y);
            
            % 姿勢角
            removeFe = (obj.state.state_data(5, end, :) >= 0.3975 | obj.state.state_data(5, end, :) <= 0.1975);
            
            % ドローンの四隅の座標
            % drone = 四隅の座標 Particle_num * 2
%             drone = obj.state.state_data(1,end,:);
%             drone_1 = drone+obj.self.parameter.lx*cos(obj.state.state_data(9, end, :));
%             drone_2 = drone-obj.self.parameter.lx*cos(obj.state.state_data(9, end, :));         
%             drone_3 = drone_2;
%             drone_4 = drone_1;
%             d4edge = [drone_1, drone_2];

            % 高度
%             zx = 10;
%             zz = 3;
%             removeFe = (any(repmat(obj.state.state_data(3, end, :), 1, 2) <= zz/zx * d4edge(1,:, :)+0.1));
            
            
            removeX = find(removeFe);
            % 制約違反の入力サンプル(入力列)を棄却
            obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
            % 全制約違反による分散リセットを確認するフラグ  
            removeF = size(removeX, 1); % particle_num -> 全棄却
%             sur = (obj.state.state_data(1, end, :) > 0.5*sin(obj.param.t));  % 生き残りサンプル
%             survive = find(sur);
            survive = obj.N;

            %% ソフト制約
            % 棄却はしないが評価値を大きくする

            %% 重心計算
%             if removeF == obj.N
%                 obj.state.COG.g  = NaN;               % 制約内は無視
%                 obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
%             elseif removeF == 0
%                 obj.state.COG.gc = NaN;               % 制約外は無視
%                 obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
%             else
%                 obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
%                 obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
%             end
        end

        function cog = COG(obj, I)
            if size(I) == 1
                x = obj.state.state_data(1, end, I);
                y = obj.state.state_data(2, end, I);
                cog = [x, y];
            else
                x = reshape(obj.state.state_data(1, end, I), [size(I,1), 1]);
                y = reshape(obj.state.state_data(2, end, I), [size(I,1), 1]);
                cog = mean([x,y]);
            end
        end

        %%-- 連続；オイラー近似
        function [predict_state] = predict(obj)
            u = obj.input.u;
            %-- 予測軌道計算
            for m = 1:obj.N
                x0 = obj.previous_state;
                obj.state.state_data(:, 1, m) = obj.previous_state;
                for h = 1:obj.param.H-1
                    x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, h, m), obj.modelp);
                    obj.state.state_data(:, h+1, m) = x0;
                end
            end


            %ベクトル化：  input[4*obj.N, obj.param.H]
            % 無名関数@ cellには入れられた気がする
%             model_equ = {obj.N, 1};
%             for mk = 1:obj.N
%                 model_equ{mk, 1} = obj.modelf;
%             end
%             x0 = repmat(obj.previous_state, obj.N, 1);
%             obj.state.state_data(:, 1) = repmat(obj.previous_state, obj.N, 1);
%             for h = 1:obj.param.H-1
%                 x0 = x0 + obj.param.dt * model_equ{:, 1}(); cell配列の式に値を代入する方法
%             end
            predict_state = obj.state.state_data;
        end

        %------------------------------------------------------
        %======================================================
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

            %% 入力の変化率
%             rate_change = tildeUpre/U;

            %% 人口ポテンシャル場法
            % x-y
%             apfLower = (X(1,end,m)-obj.param.obsX)^2 + (X(2,end,m)-obj.param.obsY)^2;   % 終端ホライズン


            %-- 状態及び入力のステージコストを計算
%             stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
%             stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
%             stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
%             stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
%             stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);
            stageStateP =    sum(tildeXp' * obj.param.P   .* tildeXp',2);
            stageStateV =    sum(tildeXv' * obj.param.V   .* tildeXv',2);
            stageStateQW =   sum(tildeXqw' * obj.param.QW .* tildeXqw',2);
            stageInputPre  = sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
            stageInputRef  = sum(tildeUref' * obj.param.R .* tildeUref',2);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);

            %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
                + terminalState;
        end
        
        function [pw_new] = Normalize(obj)
            NP = obj.N;
            pw = obj.input.Evaluationtra;

            % 配列が空かどうかの判別/ pw=評価値
%             if isempty(pw(pw<=49))
%                 obj.reset_flag = 1;
%             end
            % 評価値は0未満にならず最小値を正規化した際の1と考えた場合，指数関数を
            % 使って正規化をすることによって上手いことリサンプリングできる．
            pw = exp(-pw);
            sumw = sum(pw);
            if sumw~=0
                pw = pw/sum(pw);%正規化
            else
                pw = zeros(1,NP)+1/NP;
            end
            pw_new = pw;
        end
    end
end
