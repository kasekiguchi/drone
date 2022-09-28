function [MCeval] = EvaluationFunction_MC_reference(x, u, params, Agent, xr)
%UNTITLED この関数の概要をここに記述    ref, HLref_input
%   詳細説明をここに記述
   % 評価関数
   
   %-- モデル予測制御の評価値を計算するプログラム
        %-- MPCで用いる予測状態 Xと予測入力 Uを設定
%             Unorm = zeros(1,params.H);
            Xp = x(1:3, :, :);
            Xq = x(4:6, :, :);
            Xv = x(7:9, :, :);
            Xw = x(10:12, :, :);
            Xqw = [Xq; Xw];
            U = u;

%             H = 1:params.H;
            ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]';
            ref_v = [0; 0; 0.50];
%             P = Agent.estimator.result.state.p;
%             V = Agent.estimator.result.state.v;
            
            
%         for j = 1:params.H            
%             Unorm(1, j) = norm(U(:, j));            
%         end

        %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeXp = Xp - xr;  % 位置
            tildeXv = Xv - ref_v;                           % 速度
            tildeXqw = Xqw;                                 % 原点との差分ととらえる
            tildeUpre = U - Agent.input;
            tildeUref = U - ref_input;
            
        %-- 状態及び入力のステージコストを計算 長くなるから分割
            stageStateP  = arrayfun(@(L) tildeXp(:, L)'   * params.Weight.P         * tildeXp(:, L),   1:params.H-1);
            stageStateV  = arrayfun(@(L) tildeXv(:, L)'   * params.Weight.V         * tildeXv(:, L),   1:params.H-1);
            stageStateQW = arrayfun(@(L) tildeXqw(:, L)'  * params.Weight.QW  * tildeXqw(:, L),  1:params.H-1);
            stageInputP  = arrayfun(@(L) tildeUpre(:, L)' * params.Weight.RP      * tildeUpre(:, L), 1:params.H-1);
            stageInputR  = arrayfun(@(L) tildeUref(:, L)' * params.Weight.R        * tildeUref(:, L), 1:params.H-1);
            
            
        %-- 状態の終端コストを計算
            terminalState = tildeXp(:, end)' * params.Weight.P * tildeXp(:, end)...
                +tildeXv(:, end)'   * params.Weight.V   * tildeXv(:, end)...
                +tildeXqw(:, end)'  * params.Weight.QW  * tildeXqw(:, end);
            
%         if state.p(3) > 0.3  
        %-- 評価値計算
            MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputP + stageInputR)...
                + terminalState;
%         else
%             % Vzに対して評価値を変化させる
%             if 
%             verticleZ = 
%             MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputP + stageInputR + verticleZ)...
%                 + terminalState;
%         end
end

