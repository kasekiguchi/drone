function [eval] = Objective(x, params) % x : p q v w input
%-- 評価計算をする関数
    
    tildeXp = x(1:3, :) - params.xr(1:3, :);  % 位置
    tildeXq = x(4:6, :) - params.xr(4:6, :);
    tildeXv = x(7:9, :) - params.xr(7:9, :);  % 速度
    tildeXw = x(10:12, :) - params.xr(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
%     tildeUpre = U - Agent.input;
    tildeUref = x(13:16, :) - params.xr(13:16,:);

%-- 状態及び入力のステージコストを計算 長くなるから分割

    stageStateP = tildeXp(:, 1:params.H-1)'*params.Weight.P*tildeXp(:, 1:params.H-1);
    stageStateV = tildeXv(:, 1:params.H-1)'*params.Weight.V*tildeXv(:, 1:params.H-1);
    stageStateQW = tildeXqw(:, 1:params.H-1)'*params.Weight.QW*tildeXqw(:, 1:params.H-1);
    stageInputR = tildeUref(:, 1:params.H-1)'*params.Weight.R*tildeUref(:, 1:params.H-1);
    
    stageStateP = diag(stageStateP);
    stageStateV = diag(stageStateV);
    stageStateQW = diag(stageStateQW);
    stageInputR = diag(stageInputR);
    
    stageState = stageStateP' + stageStateV' + stageStateQW' + stageInputR'; %ステージコスト

%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * params.Weight.Pf   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.V   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QWf  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end