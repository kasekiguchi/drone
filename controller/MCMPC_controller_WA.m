classdef MCMPC_controller <CONTROLLER_CLASS
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
    
    methods
        function obj = MCMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
%             obj.param.subCheck = zeros(obj.param.particle_num, 1);
            obj.param.modelparam.modelparam = obj.self.parameter.get();
            obj.param.modelparam.modelmethod = obj.self.model.method;
            obj.param.modelparam.modelsolver = obj.self.model.solver;
            
            %%
            obj.input = param.input;
            obj.const = param.const;

%             obj.input.Evaluationtra = zeros(1, obj.param.particle_num);
            obj.model = self.model;
            %-- 全予測軌道のパラメータの格納変数を定義,　最大のサンプル数で定義

            obj.param.fRemove = 0;
        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
            idx = param{1};
            xr = param{2};
            rt = param{3};
            obj.state.ref = xr;


            if idx == 1
                obj.input.sigma = obj.input.Initsigma;
                obj.param.particle_num = obj.param.Mparticle_num;
            else
                if obj.input.nextsigma > obj.input.Maxsigma
                    obj.input.nextsigma = obj.input.Maxsigma;    % 上限
                elseif obj.input.nextsigma < obj.input.Minsigma
                    obj.input.nextsigma = obj.input.Minsigma;  % 下限
                end
                % サンプル数
                if obj.param.nextparticle_num > obj.param.Mparticle_num
                    obj.param.nextparticle_num = obj.param.Mparticle_num;    % 上限:サンプル数
                elseif obj.param.nextparticle_num < obj.param.MIparticle_num
                    obj.param.nextparticle_num = obj.param.MIparticle_num;  % 下限
                end
                obj.input.sigma = obj.input.nextsigma;
%                 obj.param.particle_num = obj.param.nextparticle_num;
            end

            if obj.param.particle_num ~= obj.param.Mparticle_num
                disp(obj.param.particle_num);
            end

            %-- 準最適化入力を格納（平均値(期待値)の設定）
            if idx == 1
                ave1 = repmat(obj.input.InitU, obj.param.H, obj.param.particle_num);
                ave2 = repmat(obj.input.InitU, obj.param.H, obj.param.particle_num);
                ave3 = repmat(obj.input.InitU, obj.param.H, obj.param.particle_num);
                ave4 = repmat(obj.input.InitU, obj.param.H, obj.param.particle_num);
            else
%                 obj.input.Ru1 = obj.input.Ru1(:, 1:obj.param.particle_num);
%                 obj.input.Ru2 = obj.input.Ru1(:, 1:obj.param.particle_num);
%                 obj.input.Ru3 = obj.input.Ru1(:, 1:obj.param.particle_num);
%                 obj.input.Ru4 = obj.input.Ru1(:, 1:obj.param.particle_num);
                ave1 = reshape(obj.input.Ru1, [obj.param.H, obj.param.particle_num]);
                ave2 = reshape(obj.input.Ru2, [obj.param.H, obj.param.particle_num]);
                ave3 = reshape(obj.input.Ru3, [obj.param.H, obj.param.particle_num]);
                ave4 = reshape(obj.input.Ru4, [obj.param.H, obj.param.particle_num]);
            end

            %-- 分散によるノイズを格納，入力の広がりを決定
            obj.input.n1 = normrnd(zeros(obj.param.H, obj.param.particle_num), obj.input.sigma);
            obj.input.n2 = normrnd(zeros(obj.param.H, obj.param.particle_num), obj.input.sigma);
            obj.input.n3 = normrnd(zeros(obj.param.H, obj.param.particle_num), obj.input.sigma);
            obj.input.n4 = normrnd(zeros(obj.param.H, obj.param.particle_num), obj.input.sigma);
            
            % サンプル数変更用
            obj.input.u = NaN(obj.param.H, obj.param.particle_num);
            obj.input.u = repmat(reshape(obj.input.u, [1, size(obj.input.u)]), 4, 1);

            %-- 各入力列を格納
            obj.input.u1 = ave1 + obj.input.n1;
            obj.input.u2 = ave2 + obj.input.n2;
            obj.input.u3 = ave3 + obj.input.n3;
            obj.input.u4 = ave4 + obj.input.n4;
            % 負の入力を阻止
            obj.input.u1(obj.input.u1<0) = 0;   
            obj.input.u2(obj.input.u2<0) = 0;
            obj.input.u3(obj.input.u3<0) = 0;
            obj.input.u4(obj.input.u4<0) = 0;
            % 次元変更
            obj.input.u(4, 1:obj.param.H, 1:obj.param.particle_num) = obj.input.u4;   % reshape
            obj.input.u(3, :, :) = obj.input.u3;   
            obj.input.u(2, :, :) = obj.input.u2;
            obj.input.u(1, :, :) = obj.input.u1;
            obj.input.u_size = size(obj.input.u, 3);    % obj.param.particle_num
            
            % 追加
            obj.state.p_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            obj.state.v_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.q_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.w_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
            obj.state.state_data = [obj.state.p_data; obj.state.q_data; obj.state.v_data; obj.state.w_data]; 
            
            % 評価列の初期化
            obj.input.Evaluationtra = NaN(1, obj.param.particle_num);
            % 現在状態の取得
            obj.previous_state = obj.self.estimator.result.state.get();

            %-- 状態予測
            [obj.state.predict_state] = obj.predict();
            if obj.state.predict_state(3, 1, :) < 0
                obj.param.fRemove = 1;
            end

            %-- 評価値計算
            for m = 1:obj.input.u_size
                obj.input.eval = obj.objective(m);
                obj.input.Evaluationtra(1,m) = obj.input.eval;
            end
            
            % 評価値の正規化
            obj.input.normE = obj.Normalize();

            %-- 制約条件
%             [removeF, removeX, survive] = obj.constraints();
            removeF = 0; removeX = []; survive = obj.param.particle_num;

            %-- リサンプリング
            [pu1, pu2, pu3, pu4, ~] = obj.Resampling();
            obj.input.Ru1 = pu1;
            obj.input.Ru2 = pu2;
            obj.input.Ru3 = pu3;
            obj.input.Ru4 = pu4;
            
            %-- 入力の取得，標準偏差の変更
            if removeF ~= obj.param.particle_num
                % 加重平均による入力算出
                [inputU, Bestcost, BestcostID] = obj.WeightedAverage();
                obj.result.input = inputU;
                %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
                if idx == 1 || idx == 2 % - 最初は全時刻の評価値がないから現時刻/現時刻にしてる
                    obj.input.Bestcost_pre = Bestcost;
                    obj.input.Bestcost_now = Bestcost;
                else
                    obj.input.Bestcost_pre = obj.input.Bestcost_now;
                    obj.input.Bestcost_now = Bestcost;
                end
                obj.input.nextsigma = obj.input.sigma * (obj.input.Bestcost_now/obj.input.Bestcost_pre);
                obj.param.nextparticle_num = ceil(obj.param.particle_num * (obj.input.Bestcost_now/obj.input.Bestcost_pre));
            elseif removeF == obj.param.particle_num    % 全棄却
                obj.result.input = obj.self.input;
                obj.input.nextsigma = obj.input.Constsigma;
                Bestcost = obj.param.ConstEval;
                BestcostID = 1;
                obj.param.nextparticle_num = obj.param.Mparticle_num;
            end
            obj.result.removeF = removeF;
            obj.result.removeX = removeX;
            obj.result.survive = survive;
%             obj.result.COG = obj.state.COG;
            obj.self.input = obj.result.input;
            obj.result.BestcostID = BestcostID;
            obj.result.bestcost = Bestcost;
            obj.result.contParam = obj.param;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.path = obj.state.state_data;
            obj.result.sigma = obj.input.sigma;
            obj.result.variable_N = obj.param.particle_num; % 追加
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.Evaluationtra_norm = obj.input.normE;
            
            result = obj.result;  
        end
        function show(obj)
            obj.result
        end

        function [pu1, pu2, pu3, pu4, J] = Resampling(obj)
            % resampling : Low Variance Sampling : LVS
            NP = obj.param.particle_num;
            J = obj.input.normE;
            U = obj.input.u;     
            u1 = reshape(U(1,:,:), [], NP);
            u2 = reshape(U(2,:,:), [], NP);
            u3 = reshape(U(3,:,:), [], NP);
            u4 = reshape(U(4,:,:), [], NP);
            
            wcum = cumsum(J);
            base = cumsum(J*0+1/NP) - 1/NP; % 乱数を加える前のbase
            resampleID = base + rand/NP;    % ルーレットを乱数分増やす
            % データ格納用
            pu1 = u1;
            pu2 = u2;
            pu3 = u3;
            pu4 = u4;
            ind = 1; % 新しいID
            for ip = 1:NP
                while(resampleID(ip) > wcum(ind))
                    ind = ind + 1;
                end
                % LVSで選ばれたパーティクルに置き換え
                pu1(1:end, ip) = [pu1(2:end, ind); pu1(end, ind)];
                pu2(1:end, ip) = [pu2(2:end, ind); pu2(end, ind)];
                pu3(1:end, ip) = [pu3(2:end, ind); pu3(end, ind)];
                pu4(1:end, ip) = [pu4(2:end, ind); pu4(end, ind)];
                J(ip) = 1/NP;
            end
        end

        function [Un, LsortAve, BestcostID] = WeightedAverage(obj)
            L = obj.input.Evaluationtra;
            U = obj.input.u;
            k = 10;
            % ソート後上から10個とってくる．
            Under = zeros(4,1);
            Upper = zeros(4,1);
            [Lsort, LsortI] = sort(L);  % LsortI : 対応するインデックス
            LsortK = repmat(Lsort(1:k), 4,1);
            LsortI = LsortI(1:k);
            UsortK = reshape(U(:, 1, LsortI), [4, k]); % 4, 1, 10
            % 分母
            Under(1) = sum(1 ./ LsortK(1, :));
            Under(2) = sum(1 ./ LsortK(2, :));
            Under(3) = sum(1 ./ LsortK(3, :));
            Under(4) = sum(1 ./ LsortK(4, :));
            % 分子
            Upper(1) = sum(UsortK(1,:) ./ LsortK(1,:));
            Upper(2) = sum(UsortK(2,:) ./ LsortK(2,:));
            Upper(3) = sum(UsortK(3,:) ./ LsortK(3,:));
            Upper(4) = sum(UsortK(4,:) ./ LsortK(4,:));
            % 加重平均
            Un = Upper ./ Under;
            LsortAve = mean(LsortK(1, :));
            [~, BestcostID] = min(L);
        end

        %-- 制約とその重心計算 --%
        function [removeF, removeX, survive] = constraints(obj)
            % 状態制約
%             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(1, end, :) < 0);
            removeFe = (obj.state.state_data(1, end, :) <= obj.const.X);
%             removeFe = (obj.state.state_data(1, end, :) <= obj.const.X | obj.state.state_data(2, end, :) <= obj.const.Y);
            removeX = find(removeFe);
            % 制約違反の入力サンプル(入力列)を棄却
            obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
            % 全制約違反による分散リセットを確認するフラグ  
            removeF = size(removeX, 1); % particle_num -> 全棄却
            sur = (obj.state.state_data(1, end, :) > obj.const.X);  % 生き残りサンプル
            survive = find(sur);
            if removeF == obj.param.particle_num
                obj.state.COG.g  = NaN;               % 制約内は無視
                obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
            elseif removeF == 0
                obj.state.COG.gc = NaN;               % 制約外は無視
                obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
            else
                obj.state.COG.g  = obj.COG(survive);  % 制約内の重心
                obj.state.COG.gc = obj.COG(removeX);  % 制約外の重心
            end
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
            %-- 予測軌道計算
            for m = 1:obj.input.u_size
                x0 = obj.previous_state;
                obj.state.state_data(:, 1, m) = obj.previous_state;
                for h = 1:obj.param.H-1
                    x0 = x0 + obj.param.dt * obj.param.modelparam.modelmethod(x0, obj.input.u(:, h, m), obj.param.modelparam.modelparam);
                    obj.state.state_data(:, h+1, m) = x0;
                end
            end
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


            %-- 状態及び入力のステージコストを計算
            stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
            stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
            stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
            stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
            stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);
            %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef)...
                + terminalState;
        end
        
        function [pw_new] = Normalize(obj)
            NP = obj.param.particle_num;
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

