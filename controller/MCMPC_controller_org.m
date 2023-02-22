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
    properties
      modelf
      modelp
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
%             obj.state.p_data = 10000 * ones(obj.param.H, obj.param.particle_num);
%             obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
%             obj.state.v_data = 10000 * ones(obj.param.H, obj.param.particle_num);
%             obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
%             obj.state.q_data = 10000 * ones(obj.param.H, obj.param.particle_num);
%             obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
%             obj.state.w_data = 10000 * ones(obj.param.H, obj.param.particle_num);
%             obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);

            obj.param.fRemove = 0;
            obj.input.AllRemove = 0;
            obj.modelf = obj.param.modelparam.modelmethod;
            obj.modelp = obj.param.modelparam.modelparam;

        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
          profile on
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
 
            if idx == 1
                ave1 = 0.269*9.81/4;      % average
                ave2 = ave1;
                ave3 = ave1;
                ave4 = ave1;
%                 ave1 = 0; ave2 = 0; ave3 = 0; ave4 = 0;
                obj.input.sigma = obj.input.Initsigma;
                % 追加
                obj.param.particle_num = obj.param.Mparticle_num;
            else
                ave1 = obj.self.input(1);    % リサンプリングとして前の入力を平均値とする
                ave2 = obj.self.input(2);
                ave3 = obj.self.input(3);
                ave4 = obj.self.input(4);
                % sigma
                if obj.input.nextsigma > obj.input.Maxsigma
                    obj.input.nextsigma = obj.input.Maxsigma;    % 上限
                elseif obj.input.nextsigma < obj.input.Minsigma
                    obj.input.nextsigma = obj.input.Minsigma;  % 下限
                end

                % particle_num 追加
                if obj.param.nextparticle_num > obj.param.Mparticle_num
                    obj.param.nextparticle_num = obj.param.Mparticle_num;    % 上限:サンプル数
                elseif obj.param.nextparticle_num < obj.param.MIparticle_num
                    obj.param.nextparticle_num = obj.param.MIparticle_num;  % 下限
                end

                obj.input.sigma = obj.input.nextsigma;
                obj.param.particle_num = obj.param.nextparticle_num;

                if obj.input.AllRemove == 1
                    ave1 = 0.269*9.81/4;
                    ave2 = ave1;
                    ave3 = ave1;
                    ave4 = ave1;
                    obj.input.AllRemove = 0;
                end
            end
%             rng ('shuffle');
            
            % 追加
            obj.state.p_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.v_data = zeros(obj.param.H, obj.param.particle_num);    
            obj.state.q_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.w_data = zeros(obj.param.H, obj.param.particle_num);

            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
            obj.state.state_data = [obj.state.p_data; obj.state.q_data; obj.state.v_data; obj.state.w_data]; 
            
            % 追加
            obj.input.Evaluationtra = NaN(1, obj.param.particle_num);

            % 追加
            obj.input.u = NaN(obj.param.H, obj.param.particle_num);
            obj.input.u = repmat(reshape(obj.input.u, [1, size(obj.input.u)]), 4, 1);

            obj.input.u1 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave1;
            obj.input.u2 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave2;
            obj.input.u3 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave3;
            obj.input.u4 = obj.input.sigma.*randn(obj.param.H, obj.param.particle_num) + ave4;
            obj.input.u1(obj.input.u1<0) = 0;   % 負の入力を阻止
            obj.input.u2(obj.input.u2<0) = 0;
            obj.input.u3(obj.input.u3<0) = 0;
            obj.input.u4(obj.input.u4<0) = 0;
%             obj.input.u1(obj.input.u1>obj.input.Maxinput) = obj.input.Maxinput; % 上限
%             obj.input.u2(obj.input.u2>obj.input.Maxinput) = obj.input.Maxinput;
%             obj.input.u3(obj.input.u3>obj.input.Maxinput) = obj.input.Maxinput;
%             obj.input.u4(obj.input.u4>obj.input.Maxinput) = obj.input.Maxinput;
            obj.input.u(4, 1:obj.param.H, 1:obj.param.particle_num) = obj.input.u4;   % reshape
            obj.input.u(3, :, :) = obj.input.u3;   
            obj.input.u(2, :, :) = obj.input.u2;
            obj.input.u(1, :, :) = obj.input.u1;
            obj.input.u_size = size(obj.input.u, 3);    % obj.param.particle_num

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
            removeF = 0; removeX = []; survive = obj.param.particle_num; 
%             if obj.self.estimator.result.state.p(3) < 0.3
%                 [removeF, removeX, survive] = obj.constraints();
%             end
            obj.state.COG.g = 0; obj.state.COG.gc = 0;
            

            if removeF ~= obj.param.particle_num
                [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
                obj.result.input = obj.input.u(:, 1, BestcostID);     % 最適な入力の取得
                %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
                if idx == 1 || idx == 2 % - 最初は全時刻の評価値がないから現時刻/現時刻にしてる
                    obj.input.Bestcost_pre = Bestcost;
                    obj.input.Bestcost_now = Bestcost;
                else
                    obj.input.Bestcost_pre = obj.input.Bestcost_now;
                    obj.input.Bestcost_now = Bestcost;
                end
                
                % 棄却数がサンプル数の半分以上なら入力増やす
                if removeF > obj.param.particle_num /2
                    obj.input.nextsigma = obj.input.Constsigma;
                    obj.param.nextparticle_num = obj.param.Mparticle_num;
                    obj.input.AllRemove = 1;
                else
                    obj.input.nextsigma = obj.input.sigma * (obj.input.Bestcost_now/obj.input.Bestcost_pre);
                    % 追加
                    obj.param.nextparticle_num = ceil(obj.param.particle_num * (obj.input.Bestcost_now/obj.input.Bestcost_pre));
                end

                
%                 if obj.param.nextparticle_num < obj.param.particle_num * 2
%                     obj.param.nextparticle_num = obj.param.particle_num * 2;
%                 end
                

            elseif removeF == obj.param.particle_num    % 全棄却
                obj.result.input = obj.self.input;
                obj.input.nextsigma = obj.input.Constsigma;
                Bestcost = obj.param.ConstEval;
                BestcostID = 1;
                obj.input.AllRemove = 1;

                % 追加
                obj.param.nextparticle_num = obj.param.Mparticle_num;
            end

%             if Bestcost > obj.param.ConstEval; Bestcost = obj.param.ConstEval;  end
           
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
            obj.result.variable_N = obj.param.particle_num; % 追加
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.Evaluationtra_norm = obj.input.normE;
            
            result = obj.result;  
            profile viewer
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
            survive = obj.param.particle_num;

            %% ソフト制約
            % 棄却はしないが評価値を大きくする

            %% 重心計算
%             if removeF == obj.param.particle_num
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
            for m = 1:obj.input.u_size
                x0 = obj.previous_state;
                obj.state.state_data(:, 1, m) = obj.previous_state;
%                 for h = 1:obj.param.H-1
%                     x0 = x0 + obj.param.dt * obj.param.modelparam.modelmethod(x0, obj.input.u(:, h, m), obj.param.modelparam.modelparam);
%                     obj.state.state_data(:, h+1, m) = x0;
%                 end
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 1, m), obj.modelp); obj.state.state_data(:, 2, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 2, m), obj.modelp); obj.state.state_data(:, 3, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 3, m), obj.modelp); obj.state.state_data(:, 4, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 4, m), obj.modelp); obj.state.state_data(:, 5, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 5, m), obj.modelp); obj.state.state_data(:, 6, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 6, m), obj.modelp); obj.state.state_data(:, 7, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 7, m), obj.modelp); obj.state.state_data(:, 8, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 8, m), obj.modelp); obj.state.state_data(:, 9, m) = x0;
x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, 9, m), obj.modelp); obj.state.state_data(:, 10, m) = x0;
            end


            %ベクトル化：  input[4*obj.param.particle_num, obj.param.H]
            % 無名関数@ cellには入れられた気がする
%             model_equ = {obj.param.particle_num, 1};
%             for mk = 1:obj.param.particle_num
%                 model_equ{mk, 1} = obj.param.modelparam.modelmethod;
%             end
%             x0 = repmat(obj.previous_state, obj.param.particle_num, 1);
%             obj.state.state_data(:, 1) = repmat(obj.previous_state, obj.param.particle_num, 1);
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

            obsX = repmat(obj.param.obsX, 1, obj.param.H);
            obsY = repmat(obj.param.obsY, 1, obj.param.H);
            Qapf = repmat(obj.param.Qapf, 1, obj.param.H);
            apfLower = (X(1,:,m)-obsX).^2 + (X(2,:,m)-obsY).^2;


            %-- 状態及び入力のステージコストを計算
%             stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
%             stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
%             stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
%             stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
%             stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);
stageStateP = sum(tildeXp' * obj.param.P   .* tildeXp',2);
stageStateV = sum(tildeXv' * obj.param.V   .* tildeXv',2);
stageStateQW = sum(tildeXqw' * obj.param.QW .* tildeXqw',2);
stageInputPre  = sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
stageInputRef  = sum(tildeUref' * obj.param.R .* tildeUref',2);
APF = sum(Qapf/apfLower);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);
%             APF = obj.param.Qapf/apfLower;
            %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
                + terminalState + APF;
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
