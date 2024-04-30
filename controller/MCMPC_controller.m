classdef MCMPC_CONTROLLER < handle
    % MCMPC_CONTROLLER MCMPCのコントローラー
    
    properties
        options
        param
        previous_state
        input
        state
        const
        reference
        result
        self
    end
    properties
      modelf
      modelp
      N % 現時刻のパーティクル数
      flag
    end
    
    methods
        function obj = MCMPC_CONTROLLER(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            obj.modelp = obj.self.parameter.get();
            obj.modelf = obj.self.plant.method; 
            %%
            obj.input = param.param.input;
            obj.const = param.param.const;
            obj.input.nextsigma = param.param.input.Initsigma;  % 初期化
            obj.param.H = param.param.H + 1;

            obj.param.nextparticle_num = param.param.Maxparticle_num;   % 初期化
            obj.input.Bestcost_now = 1e2;% 十分大きい値にする  初期周期での比較用
            obj.param.fRemove = 0;
            obj.input.AllRemove = 0;
            obj.N = param.param.particle_num;
            n = 12; % 状態数
            obj.state.state_data = zeros(n,obj.param.H, obj.N);
            obj.input.Evaluationtra = zeros(1, obj.N);
            obj.flag.vz = 0;
            obj.result.input = zeros(self.estimator.model.dim(2),1);
        end
        
        %-- main()的な
        function result = do(obj,varargin)
%           profile on
            obj.param.t = varargin{1,1}.t;

            %% horizonごとではないリファレンス
%             ref_p = obj.self.reference.result.state.p;
%             ref_q = [0;0;0];
%             ref_v = obj.self.reference.result.state.xd(5:7);
%             ref_w = [0;0;0];
%             ref_input = obj.param.ref_input;
%             ref_MC = [ref_p; ref_q; ref_v; ref_w; ref_input];
%             xr = repmat(ref_MC, 1, obj.param.H);
            %%
            % xr = obj.Reference(); % mainでできなくなったのでcnotroller内で計算
            
            %%
            obj.state.ref = obj.Reference(); % 関数の受け渡し用
            
            mu(1) = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
            mu(2) = obj.input.u(2);    % 初期値はparamで定義
            mu(3) = obj.input.u(3);
            mu(4) = obj.input.u(4);
            
            % mu(1) = 0.269*9.81/4;    % ホバリング入力を平均
            % mu(2) = 0.269*9.81/4;    % 初期値はparamで定義
            % mu(3) = 0.269*9.81/4;
            % mu(4) = 0.269*9.81/4;
            
            % 標準偏差，サンプル数の更新
            obj.input.sigma = obj.input.nextsigma;
            obj.N = obj.param.nextparticle_num;         

            if obj.input.AllRemove == 1 % 全棄却回避用
                mu(1) = 0.269*9.81;
                mu(2) = mu(1);
                mu(3) = mu(1);
                mu(4) = mu(1);
                obj.input.AllRemove = 0;
            end

            obj.input.u1 = max(0,obj.input.sigma.*randn(obj.param.H, obj.N) + mu(1));
            obj.input.u2 = obj.input.sigma.*randn(obj.param.H, obj.N);    % すべて同じ入力、　確認用
            obj.input.u3 = obj.input.sigma.*randn(obj.param.H, obj.N);
            obj.input.u4 = obj.input.sigma.*randn(obj.param.H, obj.N);
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
            eachCost = zeros(obj.N, 3);
            for m = 1:obj.N
                [obj.input.eval(1,m), eachCost(m, :)] = objective(obj,m);
            end
            obj.input.Evaluationtra = obj.input.eval(1, 1:obj.N); % サンプル数が小さくなった時に最小値を見失わないように
            
            %-- 評価値の正規化
            obj.input.normE = obj.Normalize(); % ほぼ使わない

            %-- 制約条件
            removeF = 0; removeX = []; survive = obj.N; 
%             [removeF, removeX, survive] = obj.constraints();
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
                    obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now/obj.input.Bestcost_pre))));
                end

            elseif removeF == obj.N    % 全棄却
                obj.result.input = obj.input.u;
                obj.input.nextsigma = obj.input.Constsigma;
                Bestcost = obj.param.ConstEval;
                BestcostID = 1;
                obj.input.AllRemove = 1;

                obj.param.nextparticle_num = obj.param.Maxparticle_num;
            end
            obj.input.u = obj.result.input;

            obj.result.input_v = [0;0;0;0];
            obj.result.removeF = removeF;
            obj.result.removeX = removeX;
            obj.result.survive = survive;
            obj.result.COG = obj.state.COG;

            obj.result.BestcostID = BestcostID;
            obj.result.bestcost = Bestcost;
            obj.result.contParam = obj.param;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.path = obj.state.state_data;
            obj.result.sigma = obj.input.sigma;
            obj.result.variable_N = obj.N; 
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.Evaluationtra_norm = obj.input.normE;
            obj.result.eachcost = eachCost(BestcostID, :);
            
            %% 情報表示
            if exist("exitflag") ~= 1
                exitflag = NaN;
            end
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
                obj.param.t, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), exitflag);
            fprintf("\n");
            
            result = obj.result;  
%             profile viewer
        end
        function show(obj)
            obj.result
        end

        %-- 制約とその重心計算 --%
        function [removeF, removeX, survive] = constraints(obj)
            % 状態制約
            removeX = find(obj.state.predict_state(1, 1, 1:obj.N) < -0.5);
%             removeX = find(removeFe);
            obj.input.Evaluationtra(1,removeX) = obj.param.ConstEval;
            removeF = size(removeX, 1);
            removeX = []; survive = obj.N;
        end

        %-- 予測軌道の重心を求める　使っていない --%
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
                    x0 = x0 + obj.param.dt * obj.modelf(x0, u(:, h, m), obj.modelp); % オイラー近似
                    % [~,tmpx]=ode15s(@(t,x) obj.modelf(x, u(:, h, m),obj.modelp),[0 obj.param.dt], x0); % 非線形モデル
                    % x0 = tmpx(end, :);
                    obj.state.state_data(:, h+1, m) = x0;
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
%             tildeUpre = U - obj.self.input;       % agent.input
            tildeUpre = U - obj.input.u;
            tildeUref = U - obj.state.ref(13:16, :);

            %% ホライズンの先に係数下げる
            kJ = linspace(1, 0.2, obj.param.H);
            
            %% 制約違反ソフト制約
            constraints = 0;
            tildeXp = tildeXp .* kJ; tildeXqw = tildeXqw .* kJ;
            tildeXv = tildeXv .* kJ; 
            tildeUpre = tildeUpre .* kJ; tildeUref = tildeUref .* kJ;
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
                + terminalState + constraints;
            EachCost = [sum(stageStateP), sum(stageStateV), sum(stageStateQW)];
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

        function [xr] = Reference(obj, ~)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(16, obj.param.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.param.H-1
                t = obj.param.t + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = 0.269*9.81/4 * [1;1;1;1]; % MC -> 0.6597,   HL -> 0
            end
        end
    end
end
