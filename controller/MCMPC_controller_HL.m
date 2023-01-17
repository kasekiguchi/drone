classdef MCMPC_controller_HL <CONTROLLER_CLASS
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
        linearmodel
        result
        self
    end
    
    methods
        function obj = MCMPC_controller_HL(self, param)
            %-- 変数定義
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param = param;
            obj.param.modelparam.modelparam = obj.self.parameter.get();
            obj.param.modelparam.modelmethod = obj.self.model.method;
            obj.param.modelparam.modelsolver = obj.self.model.solver;
            %%
            obj.input = param.input;
            obj.const = param.const;

            obj.input.Evaluationtra = zeros(1, obj.param.particle_num);
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

            obj.state.p_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            obj.state.v_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.q_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.w_data = NaN(obj.param.H, obj.param.particle_num);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
            obj.state.state_data = [obj.state.p_data; obj.state.q_data; obj.state.v_data; obj.state.w_data];  

            obj.param.fRemove = 0;

            %-- 階層型線形化のゲイン
            obj.param.P = param.P;
            obj.param.F1 = param.F1;%z
            obj.param.F2 = param.F2;%x
            obj.param.F3 = param.F3;%y
            obj.param.F4 = param.F4;%yaw

            %% Model Setting
            %model state : virtual state 2nd layor h2 h3  MPC内状態方程式
            A23 = diag([1,1,1],1);
            B23 = [0;0;0;1];
            C=ones(8,8);
            D=zeros(8,2);
            A=blkdiag(A23,A23);
            B=blkdiag(B23,B23);
            sys=ss(A,B,C,D);
            sysd = c2d(sys,obj.param.dt);   % 離散化

            obj.param.input_size = size(sysd.B,2);
            obj.param.state_size = size(sysd.A,2);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;

%             obj.param.Pdata=param.Pdata;
            
            obj.model = self.model;
            obj.linearmodel.A = sysd.A; % A行列
            obj.linearmodel.B = sysd.B; % B行列
        end
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
            idx = param{1};
            xr = param{2};
            obj.state.ref = xr;

            %===== HL
%             modelstate = state_copy(obj.self.estimator.result.state);
%             modelstate.q=(eul2quat(modelstate.q','XYZ'))';%オイラーからクォータニオンへの変換
% %             x = modelstate.get; % [q, p, v, w]に並べ替え
%             x = [modelstate.q;modelstate.p;modelstate.v;modelstate.w];
%             xd = obj.self.reference.result.state.get();
%             xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める． 座標，速度，加速度のあの配列
%             
%             % 階層型線形化
%             if isfield(obj.param,'dt')  % dtがobj.paramの構造体に含まれるか
%                 dt = obj.param.dt;
%                 vf = Vfd(dt,x,xd',obj.param.P,obj.param.F1);
%             else
%                 vf = Vf(x,xd',obj.param.P,obj.param.F1);
%             end
%             vs = Vs(x,xd',vf,obj.param.P,obj.param.F2,obj.param.F3,obj.param.F4);
%             v4 = vs(3);
%             %実状態を仮想状態に変換
%             h2 = Z2(x,zeros(20,1)',vf,obj.param.P);   %x方向の仮想状態
%             h3 = Z3(x,zeros(20,1)',vf,obj.param.P);   %y方向
%             %h2とh3を状態にしたMPC
%             
%             %ループの中で変動するパラメータを設定
%             obj.param.X0 = [h2;h3];
%             obj.param.Xd = xd;
%             %===== 階層型線形化
 
            if idx == 1
                ave1 = 0.269*9.81/4;      % average
                ave2 = ave1;
                ave3 = ave1;
                ave4 = ave1;
                obj.input.sigma = obj.input.Initsigma;
                % 追加
%                 obj.param.particle_num = obj.param.Mparticle_num;
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
%                 if obj.param.nextparticle_num > obj.param.Mparticle_num
%                     obj.param.nextparticle_num = obj.param.Mparticle_num;    % 上限:サンプル数
%                 elseif obj.param.nextparticle_num < obj.param.MIparticle_num
%                     obj.param.nextparticle_num = obj.param.MIparticle_num;  % 下限
%                 end

                obj.input.sigma = obj.input.nextsigma;

                % 追加
%                 obj.param.particle_num = obj.param.nextparticle_num;
            end
%             rng ('shuffle');
            % 追加
%             obj.input.u = NaN(obj.param.H, obj.param.particle_num);
%             obj.input.u = repmat(reshape(obj.input.u, [1, size(obj.input.u)]), 4, 1);

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
%             [removeF, removeX] = obj.constraints();
            removeF = 0; removeX = [];
%             [Bestcost, BestcostID] = min(obj.input.normE);

            if removeF ~= 0
                fprintf("aaaaaa")
            end

            if removeF ~= obj.param.particle_num
                [Bestcost, BestcostID] = min(obj.input.Evaluationtra);
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

                % 追加
                obj.param.nextparticle_num = ceil(obj.param.particle_num * (obj.input.Bestcost_now/obj.input.Bestcost_pre));

            elseif removeF == obj.param.particle_num    % 全棄却
                obj.result.input = obj.self.input;
                obj.input.nextsigma = obj.input.Constsigma;
                Bestcost = 10000;
                BestcostID = 1;

                % 追加
                obj.param.nextparticle_num = obj.param.Mparticle_num;
            end
            obj.result.removeF = removeF;
            obj.result.removeX = removeX;
            obj.self.input = obj.result.input;
            obj.result.BestcostID = BestcostID;
            obj.result.bestcost = Bestcost;
            obj.result.contParam = obj.param;
            obj.result.fRemove = obj.param.fRemove;
            obj.result.path = obj.state.state_data;
            obj.result.sigma = obj.input.nextsigma;
%             obj.result.variable_N = obj.param.nextparticle_num; % 追加
            obj.result.Evaluationtra = obj.input.Evaluationtra;
            obj.result.Evaluationtra_norm = obj.input.normE;
            
            result = obj.result;  
        end
        function show(obj)
            obj.result
        end

        function [removeF, removeX] = constraints(obj)
            % 状態制約
            removeFe = (obj.state.state_data(1, end, :) <= obj.const.X);
            % サンプル番号の重なりをなくす
%             removeX = unique(removeFe_check);
            removeX = find(removeFe);
            % 制約違反の入力サンプル(入力列)を棄却
            obj.input.Evaluationtra(removeX) = obj.param.ConstEval;   % 制約違反は評価値を大きく設定
            % 全制約違反による分散リセットを確認するフラグ  
            removeF = size(removeX, 1); % particle_num -> 全棄却
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

