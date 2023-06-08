classdef MCMPC_controller <CONTROLLER_CLASS
    % MCMPC_CONTROLLER MCMPCのコントローラー
    
    properties%(新しい変数を追加する場合はここに書く)
        %-- 変数の構造体を宣言 --%
        options 
        param % パラメータ
        previous_state  % 前状態
        input   % 入力
        state   % 状態
        reference   % 目標軌道
        model   % モデル
        result  % mainに値戻す(agentへの保存)
        self    % classの通例
        A       %係数行列(クープマン)
        B       %出力ベクトル(クープマン)
        f       %観測量(クープマン)
    end
    
    methods
        function obj = MCMPC_controller(self, param)
            %---- 変数定義 ----%
            obj.self = self; %selfでagentに接続できる
            %--MPCパラメータ設定--%
            %~ SampleのController_MCMPCからパラメータの受け取り
            obj.param = param;
            obj.param.subCheck = zeros(obj.param.particle_num, 1);
            obj.param.fRemove = 0;
            obj.input.Initsigma = param.Initsigma;  % 初期標準偏差
            obj.input.ref_input = param.ref_input;  % 目標入力 (reference_input) 
            obj.input.Evaluationtra = zeros(1, obj.param.particle_num); % 評価値配列の初期化
            obj.model = self.model; % agent.model -> obj.model
            %-- 全予測軌道のパラメータの格納変数を定義 --%
            %-- ドローンの状態を格納するための配列を作成
            obj.state.p_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.p_data = repmat(reshape(obj.state.p_data, [1, size(obj.state.p_data)]), 3, 1);
            %(reshape(obj.state.p_data,[1,size(obj.state.p_data)],3,1)は[1,size(obj.state.p_data)]で1行とobj.state.p_dataの元の行列の行を列，列を高さに変換(3次元に変換している)
            obj.state.q_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.q_data = repmat(reshape(obj.state.q_data, [1, size(obj.state.q_data)]), 3, 1);
            obj.state.v_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.v_data = repmat(reshape(obj.state.v_data, [1, size(obj.state.v_data)]), 3, 1);
            obj.state.w_data = zeros(obj.param.H, obj.param.particle_num);
            obj.state.w_data = repmat(reshape(obj.state.w_data, [1, size(obj.state.w_data)]), 3, 1);
%             obj.A = obj.param.model.est.Ahat; %係数行列A, 複素数空間上での値
%             obj.B = obj.param.model.est.Bhat; %出力ベクトルB, 複素数空間上での値
%             obj.f %観測量


            % p , q, v, w
                %~ ホライズン×サンプル数の配列初期化
                %~ 状態数×ホライズン×サンプル数に次元変換
            obj.state.state_data = [obj.state.p_data;obj.state.q_data;obj.state.v_data;obj.state.w_data];  
        end%(ここまでは一回目のみ読み込まれる)
        
        %-- main()的な
        % u fFirst
        function result = do(obj,param)
            idx = param{1}; % mainから値の受け取り プログラムの周回数
            xr = param{2};
            obj.state.ref = xr; % 構造体に代入

            %-- 正規分布の標準偏差，平均の設定
%                 obj.input.sigma = 0.1;
%                 obj.input.average = 0.269*9.81/4;     

            if idx == 1 %プログラムの1周目では標準偏差，平均値を設定
                obj.input.sigma = 0.1;
                obj.input.average = 0.269*9.81/4;     
            else %2周目以降はリサンプリングで標準偏差と平均値を計算
                obj.input.sigma = obj.input.sigma * (obj.input.bestcost_now / obj.input.bestcost_befor);
                obj.input.average = obj.input.u1(:,1,obj.input.I);
                if obj.input.sigma >= 2 %sigmaの最大最小の設定
                    obj.input.sigma = 2;
                elseif obj.input.sigma <= 0.005
                    obj.input.sigma = 0.005;
                end
            end

            obj.input.u1 = obj.input.sigma * randn(4, obj.param.H, obj.param.particle_num) + obj.input.average;
             %(新しい入力の生成，σ×[入力数×ホライズン数×サンプル数]+平均値),randn:標準世紀分布から取り出された乱数スカラーを返す
               
            %-- 入力列の生成
            % 正規分布に従う．設定した標準偏差と平均に基づく
            % 負の入力の阻止(find()<0の部分)
            % 入力列の次元変換
            obj.input.u1(find(obj.input.u1 < 0)) = 0;

            %-- 現在状態の取得
            obj.previous_state.x0 = obj.self.estimator.result.state.get(); %12 * 1
            %(上の式の右辺はagent(どこからでもアクセスできる)から引っ張ってきている)
            % obj.self:agentにアクセス
            % estimator → result → state:agentの中のestimatorの中のresultの中のstateにアクセス，get()で中身をすべてobj.previous_state.x0に代入

            %-- 予測軌道算出
            obj.state.predict_state = obj.predict(); %関数呼び出し
            % プラスα　：　墜落したらプログラムを終了させる

            %-- 予測軌道に対する評価値計算
            for i = 1:obj.param.particle_num %1～サンプル数(obj.param.particle_num)分の評価値を計算
                obj.state.objective(i) = obj.objective(i); %評価値計算用関数の呼び出し
            end

            % 最小値を取得
            [bestcost,obj.input.I] = min(obj.state.objective);
            %min()で計算した評価値の中から最小な値を探し出し，obj.input.Iに最小値が入っている場所の配列番号を入力

            % 最適な入力をagentに代入
            obj.self.input = obj.input.u1(:,1,obj.input.I);

            %-- リサンプリング
            if idx == 1
                obj.input.bestcost_befor = bestcost;
                obj.input.bestcost_now = bestcost;
            else
                obj.input.bestcost_befor =  obj.input.bestcost_now;
                obj.input.bestcost_now = bestcost;
            end
               
            %-- (必要があれば)変数の保存(mainへ値を返す) 
            obj.result.bestcost = bestcost;
            obj.result.sigma = obj.input.sigma;
            obj.result.contParam = obj.param;
            result = obj.result;
            %(result = とすることで値がagentに保存される,agent内のデータはどこからでもアクセスできる)
            %ただし，シミュレーションを回すごとにagent内の内容は書き換えられる
            
        end

        % 今回は関係ないので無視
        function show(obj)
            obj.result
        end

        %-- 状態予測関数
        function [predict_state] = predict(obj) %function 戻り値 = 関数名(入力値)
            ts = 0; % 一応初期化, odeで用いる
            % 予測軌道計算
            for i = 1:obj.param.particle_num %サンプル数
            obj.state.y0 = obj.previous_state.x0; %現在状態x0を状態記憶配列y0に保存
            obj.state.state_data(:,1,i) = obj.state.y0; %y0を初期値に設定
                for j = 1:obj.param.H - 1 %ホライズン数分繰り返し
                    %モデルの計算
                    obj.state.y0 = obj.state.y0 + obj.param.dt * obj.self.model.method(obj.state.y0,obj.input.u1(:,j,i),obj.self.model.param);
%                     obj.state.y0 = obj.A*obj.state.y0 + obj.B*obj.input.u1(:,j,i); %クープマンモデル，複素数空間上での値
                    obj.state.state_data(:,j+1,i) = obj.state.y0; %j+1の理由：初期位置を除くから
                end
            end
            predict_state = obj.state.state_data; %戻り値predict_stateに予測した値を代入
        end

        %-- 評価関数の計算
        function [MCeval] = objective(obj, i)   %m=サンプル
            X = obj.state.state_data;       %12 * 10 = 12状態×10ホライズン
            U = obj.input.u1(:,:,i);         %4  * 10 = 4入力(プロペラの数)×10ホライズン

            %-- 予測状態と目標状態の誤差計算
            tildep = obj.state.ref(1:3,:) - X(1:3,:,i);
            tildeq = obj.state.ref(4:6,:) - X(4:6,:,i);
            tildev = obj.state.ref(7:9,:) - X(7:9,:,i);
            tildew = obj.state.ref(10:12,:) - X(10:12,:,i);
            %-- 予測入力と目標入力の誤差計算
            tildeu = obj.state.ref(13:16,:) - U;
            %-- 状態及び入力のステージコストを計算
            stagestateP = arrayfun(@(L) tildep(:,L)' * obj.param.P * tildep(:,L), 1:obj.param.H - 1);
            stagestateQ = arrayfun(@(L) tildeq(:,L)' * obj.param.Q * tildeq(:,L), 1:obj.param.H - 1);
            stagestateV = arrayfun(@(L) tildev(:,L)' * obj.param.V * tildev(:,L), 1:obj.param.H - 1);
            stagestateW = arrayfun(@(L) tildew(:,L)' * obj.param.W * tildew(:,L), 1:obj.param.H - 1);
            stagestateU = arrayfun(@(L) tildeu(:,L)' * obj.param.R * tildeu(:,L), 1:obj.param.H - 1);
            %-- 状態の終端コストを計算(重みは分離可能，controllerに追加する)
            terminalstatep = tildep(:,end)' * obj.param.Pf * tildep(:,end);
            terminalstateq = tildeq(:,end)' * obj.param.Q * tildeq(:,end);
            terminalstatev = tildev(:,end)' * obj.param.V * tildev(:,end);
            terminalstatew = tildew(:,end)' * obj.param.W * tildew(:,end);
            terminalstateu = tildeu(:,end)' * obj.param.R * tildeu(:,end);
            %-- 評価値計算
            MCeval = sum(stagestateP + stagestateQ + stagestateV + stagestateW + stagestateU ...
                 ) + terminalstatep + terminalstateq + terminalstatev + terminalstatew + terminalstateu;

            
        end
    end
end
