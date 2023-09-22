classdef MCMPC_controller <handle
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
    end
    
    methods
        function obj = MCMPC_controller(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param.param;
            obj.modelp = obj.self.parameter.get();
            obj.modelf = obj.self.plant.method; 
            %%
%             param = param.param;
            obj.input = obj.param.input;
            obj.input.nextsigma = obj.param.input.Initsigma;  % 初期化
            obj.param.H = obj.param.H + 1;
            % 追加
            obj.param.nextparticle_num = obj.param.Maxparticle_num;   % 初期化
            obj.input.Bestcost_now = 1e2;% 十分大きい値にする  初期周期での比較用
%             obj.model = self.model;
            obj.param.fRemove = 0;
            obj.input.AllRemove = 0;
            obj.N = obj.param.particle_num;
            n = 12; % 状態数
            obj.state.state_data = zeros(n,obj.param.H, obj.N);
            obj.input.Evaluationtra = zeros(1, obj.N);
            obj.flag.vz = 0;
        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,varargin)
%           profile on
            rt = varargin{1}.t;
            xr = obj.Reference(rt);
            obj.state.ref = xr;
            obj.param.t = rt;

            %% 情報表示
            state_monte = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi); % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                    xr(1,1), xr(2,1), xr(3,1),...
                    xr(7,1), xr(8,1), xr(9,1),...
                    xr(4,1)*180/pi, xr(5,1)*180/pi, xr(6,1)*180/pi)                             % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t input_v: %f %f %f %f", ...
                rt, obj.input.v(1), obj.input.v(2), obj.input.v(3), obj.input.v(4));
            fprintf("\n");

            
            % 
            % ave1 = obj.input.u(1);    % リサンプリングとして前の入力を平均値とする
            % ave2 = obj.input.u(2);    % 初期値はparamで定義
            % ave3 = obj.input.u(3);
            % ave4 = obj.input.u(4);

            %% resampling
            % ave = obj.input.u;

            %% 
            ave = obj.param.ref_input;

            % ave1 = obj.param.ref_input(1);
            
            % 標準偏差，サンプル数の更新
            obj.input.sigma = obj.input.nextsigma; % 4*1
            obj.N = obj.param.nextparticle_num;   

            obj.input.sigma(4) = 0;

            % ave1 = obj.self.parameter.mass*9.81; ave2 = 0; ave3 = 0; ave4 = 0;
            obj.input.u1 = max(0,obj.input.sigma(1).*randn(obj.param.H, obj.N) + ave(1));
            obj.input.u2 = obj.input.sigma(2).*randn(obj.param.H, obj.N)+ave(2);    % すべて同じ入力、　確認用
            obj.input.u3 = obj.input.sigma(3).*randn(obj.param.H, obj.N)+ave(3);
            obj.input.u4 = obj.input.sigma(4).*randn(obj.param.H, obj.N)+ave(4);
            obj.input.u(4, 1:obj.param.H, 1:obj.N) = obj.input.u4;   % reshape
            obj.input.u(3, 1:obj.param.H, 1:obj.N) = obj.input.u3;   
            obj.input.u(2, 1:obj.param.H, 1:obj.N) = obj.input.u2;
            obj.input.u(1, 1:obj.param.H, 1:obj.N) = obj.input.u1;

            obj.previous_state = obj.self.estimator.result.state.get();

            %-- 状態予測
            [obj.state.predict_state] = obj.predict();

            %-- 評価値計算
            obj.param.fin = 0;
            eachCost = zeros(obj.N, 4);

            for m = 1:obj.N
                [obj.input.eval(1,m), eachCost(m, :)] = obj.objective(m);
            end

            % サンプル数が小さくなった時に最小値を見失わないように
            obj.input.Evaluationtra = obj.input.eval(1, 1:obj.N); 
            
            %% 最適な入力の取得
            [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
            obj.result.input = obj.input.u(:, 1, BestcostID);     
            

            %% Resampling
            obj.input.Bestcost_pre = obj.input.Bestcost_now;
            obj.input.Bestcost_now = Bestcost;
            obj.input.nextsigma = min(obj.input.Maxsigma,max( obj.input.Minsigma, obj.input.sigma .* (obj.input.Bestcost_now./obj.input.Bestcost_pre)));
            obj.param.nextparticle_num = min(obj.param.Maxparticle_num,max(obj.param.Minparticle_num,ceil(obj.N * (obj.input.Bestcost_now/obj.input.Bestcost_pre))));

            obj.input.u = obj.result.input;

            obj.input.v = obj.input.u;
            % obj.self.input = obj.result.input;
            obj.result.BestcostID = BestcostID;
            obj.result.bestcost = Bestcost;
            obj.result.contParam = obj.param;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.path = obj.state.state_data;
            obj.result.sigma = obj.input.sigma;
            obj.result.variable_N = obj.N; % 追加
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.eachcost = eachCost(BestcostID, :);
            
            result = obj.result;  
%             profile viewer
        end
        function show(obj)
            obj.result
%             view([2]);
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
            tildeUpre = U - obj.input.v;       % agent.input
            tildeUref = U - obj.state.ref(13:16, :);

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

        %% TimeVarying
        function [xr] = Reference(obj, T)
            xr = zeros(12, obj.param.H);
            RefTime = obj.self.reference.func;    % 時間関数の取得
            % TimeVarying
            for h = 0:obj.param.H-1
                t = T + obj.param.dt * h;
                Ref = RefTime(t); % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
                xr(1:3, h+1) = Ref(1:3);
                xr(7:9, h+1) = Ref(5:7);
                xr(4:6, h+1) =   [0;0;Ref(4)]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input;
            end
        end
    end
end
