function[MCeval] = EvaluationFunction(x, u, params)

     %-- モデル予測制御の評価値を計算するプログラム
        %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            Unorm = zeros(1,params.H);
            X = x;
            U = u;
            H = 1:params.H;
            
        for j = 1:params.H            
            Unorm(1, j) = norm(U(:, j));            
        end

        %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeX = X - params.Xr;
            tildeU = U - params.Ur;
            
        %-- 状態及び入力のステージコストを計算
            stageState = arrayfun(@(L) tildeX(:, L)' * params.Weight.Q * tildeX(:, L), 1:params.H-1);
            stageInput = arrayfun(@(L) tildeU(:, L)' * params.Weight.R * tildeU(:, L), 1:params.H-1);
            
        %-- 西川先輩の充電量の項の名残、
            %指数関数で急激な変化
            %stageElectric = arrayfun(@(L) params.Weight.Re*exp(-(X(5, L) - 75)), 1:params.H-1);
            %ソフトプラス関数
            
%             ■ 充電量 ■
%             stageElectric = arrayfun(@(L) params.Weight.Re*log(1+exp(-(X(5, L) - 75)))^2, 1:params.H-1);
%             stageInput2 = arrayfun(@(L) params.Weight.Rs*log(1+exp(-(-Unorm(1, L) + 4)))^2, 1:params.H-1);
            
            stageInput2 = arrayfun(@(L) Unorm(1, L) - params.umax, 1:params.H-1);
            
            for i = 1:params.H-1
                if stageInput2(i) <= 0
                    stageInput2(i) = 0;                    
                else
                    stageInput2(i) = params.Weight.Rs * stageInput2(i)^2;                    
                end
            end
            
        %-- 状態の終端コストを計算
            terminalState = tildeX(:, end)' * params.Weight.Qf * tildeX(:, end);
            
        %-- 評価値計算
            MCeval = sum(stageState + stageInput + stageInput2) + terminalState;
%             MCeval = sum(stageState + stageInput + stageElectric) + terminalState;

end