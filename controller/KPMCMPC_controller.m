classdef KPMCMPC_controller <CONTROLLER_CLASS
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
      flag
      KP
    end
    
    methods
        function obj = KPMCMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
            obj.modelp = obj.self.parameter.get();
            obj.modelf = obj.self.model.method; 
            %%
            obj.input = param.input;
            obj.input.nextsigma = param.input.Initsigma;  % 初期化
            obj.param.H = param.H + 1;
            % 追加
            obj.param.nextparticle_num = param.Maxparticle_num;   % 初期化
            obj.input.Bestcost_now = 1e2;% 十分大きい値にする  初期周期での比較用
            obj.model = self.model;
            obj.param.fRemove = 0;
            obj.input.AllRemove = 0;
            obj.N = param.particle_num;
            n = 12; % 状態数
            obj.state.state_data = zeros(n,obj.param.H, obj.N);
            obj.input.Evaluationtra = zeros(1, obj.N);
            obj.flag.vz = 0;
        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
%           profile on
            % idx = param{1};
            xr = param{2};
            rt = param{3};
            % phase = param{4};
            obj.state.ref = xr;
            obj.param.t = rt;
            obj.KP = param{6};
            
            ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
            ave2 = obj.input.u(2);    % 初期値はparamで定義
            ave3 = obj.input.u(3);
            ave4 = obj.input.u(4);
            
            % ave1 = 0.269*9.81/4;    % ホバリング入力を平均
            % ave2 = 0.269*9.81/4;    % 初期値はparamで定義
            % ave3 = 0.269*9.81/4;
            % ave4 = 0.269*9.81/4;
            
            % 標準偏差，サンプル数の更新
            obj.input.sigma = obj.input.nextsigma; % 4*1
            obj.N = obj.param.nextparticle_num;      

            %% yaw入力なくす　➡　安定化
            % obj.input.sigma(2) = 0;
            % obj.input.sigma(3) = 0;
            obj.input.sigma(4) = 0;

            %% each 4 inputs
            % obj.input.u1 = max(0,obj.input.sigma.*randn(obj.param.H, obj.N) + ave1); % 負入力の阻止
            % obj.input.u2 = max(0,obj.input.sigma.*randn(obj.param.H, obj.N) + ave2);
            % obj.input.u3 = max(0,obj.input.sigma.*randn(obj.param.H, obj.N) + ave3);
            % obj.input.u4 = max(0,obj.input.sigma.*randn(obj.param.H, obj.N) + ave4);

            %% total thrust, roll, pitch, yaw
            ave1 = obj.self.parameter.mass*9.81; ave2 = 0; ave3 = 0; ave4 = 0;
            obj.input.u1 = max(0,obj.input.sigma(1).*randn(obj.param.H, obj.N) + ave1);
            obj.input.u2 = obj.input.sigma(2).*randn(obj.param.H, obj.N)+ave2;    % すべて同じ入力、　確認用
            obj.input.u3 = obj.input.sigma(3).*randn(obj.param.H, obj.N)+ave3;
            obj.input.u4 = obj.input.sigma(4).*randn(obj.param.H, obj.N)+ave4;
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
            obj.param.fin = 0;
            eachCost = zeros(obj.N, 4);
%             tic
            for m = 1:obj.N
                [obj.input.eval(1,m), eachCost(m, :)] = objective(obj,m);
                % [Evaluationtra(1,m), eachCost] = objective(obj, m);
            end
%             toc
            obj.input.Evaluationtra = obj.input.eval(1, 1:obj.N); % サンプル数が小さくなった時に最小値を見失わないように
            % obj.input.eachcost = eachCost(1, 1:obj.N);

            % 評価値の上位50個の取り出し
            % obj.param.fin = 1;
            % [~, obj.input.bestNID] = mink(obj.input.Evaluationtra, 50);
            % % 姿勢角終端コストを変更させるため再計算
            % for m = obj.input.bestNID
            %     [eval, eachCost(m, :)] = obj.objective(m);
            %     obj.input.Evaluationtra(1,m) = eval;
            % end
            
            % 評価値の正規化
            obj.input.normE = obj.Normalize();

            %-- 制約条件
            removeF = 0; removeX = []; survive = obj.N; 
            % [removeF, removeX, survive] = obj.constraints();
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
%                     obj.input.AllRemove = 1;
                else
                    obj.input.nextsigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now./obj.input.Bestcost_pre)));
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
            obj.result.eachcost = eachCost(BestcostID, :);
            
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
            removeF = 0; removeX = []; survive = obj.N;
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
                x0 = [obj.previous_state; 1];
                obj.state.state_data(:, 1, m) = obj.previous_state;
                for h = 1:obj.param.H-1
                    x0 = obj.KP.A * x0 + obj.KP.B * u(:, h, m);
                    % [~,tmpx]=ode15s(@(t,x) obj.modelf(x, u(:, h, m),obj.modelp),[0 obj.param.dt], x0); % 非線形モデル
                    % x0 = tmpx(end, :);
                    obj.state.state_data(:, h+1, m) = x0(1:12,1);
                end
            end
            predict_state = obj.state.state_data;
        end

        %------------------------------------------------------
        %======================================================
        function [MCeval, EachCost] = objective(obj, m)   % obj.~とする
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

            %% ホライズンの先に係数下げる
            kJ = linspace(1, 0.2, obj.param.H);

            tildeXp = tildeXp(:,end-1) .* kJ; tildeXqw = tildeXqw(:,end-1) .* kJ;
            tildeXv = tildeXv(:,end-1) .* kJ; 
            tildeUpre = tildeUpre(:,end-1) .* kJ; tildeUref = tildeUref(:,end-1) .* kJ;
            stageStateP =    sum(tildeXp(:,end-1)' * obj.param.P   .* tildeXp(:,end-1)',2);
            stageStateV =    sum(tildeXv(:,end-1)' * obj.param.V   .* tildeXv(:,end-1)',2);
            stageStateQW =   sum(tildeXqw(:,end-1)' * obj.param.QW .* tildeXqw(:,end-1)',2);
            stageInputPre  = sum(tildeUpre(:,end-1)' * obj.param.RP.* tildeUpre(:,end-1)',2);
            stageInputRef  = sum(tildeUref(:,end-1)' * obj.param.R .* tildeUref(:,end-1)',2);
            terminalState = tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
                +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);

            %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
                + terminalState;
            EachCost = [sum(stageStateP), sum(stageStateV), sum(stageStateQW), terminalState];
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
