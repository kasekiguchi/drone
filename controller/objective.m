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
    
    %% 入力の変化率
    %             rate_change = tildeUpre/U;
    
    %% 人口ポテンシャル場法
    % x-y
    %             apfLower = (X(1,end,m)-obj.param.obsX)^2 + (X(2,end,m)-obj.param.obsY)^2;   % 終端ホライズン
    
    %% 制約違反ソフト制約
    constraints = 0;
    
    
    %-- 状態及び入力のステージコストを計算
    %             stageStateP = arrayfun(@(L) tildeXp(:, L)' * obj.param.P * tildeXp(:, L), 1:obj.param.H-1);
    %             stageStateV = arrayfun(@(L) tildeXv(:, L)' * obj.param.V * tildeXv(:, L), 1:obj.param.H-1);
    %             stageStateQW = arrayfun(@(L) tildeXqw(:, L)' * obj.param.QW * tildeXqw(:, L), 1:obj.param.H-1);
    %             stageInputPre  = arrayfun(@(L) tildeUpre(:, L)' * obj.param.RP * tildeUpre(:, L), 1:obj.param.H-1);
    %             stageInputRef  = arrayfun(@(L) tildeUref(:, L)' * obj.param.R  * tildeUref(:, L), 1:obj.param.H-1);
    stageStateP =    sum(tildeXp' * obj.param.P   .* tildeXp',2);
    stageStateV =    sum(tildeXv' * obj.param.V   .* tildeXv',2);
    stageStateQW =   sum(tildeXqw' * obj.param.QW .* tildeXqw',2);
    stageInputPre  = sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
    stageInputRef  = sum(tildeUref' * obj.param.R .* tildeUref',2);
    
    %-- 状態の終端コストを計算 状態だけの終端コスト
    terminalState = tildeXp(:, end)' * obj.param.Pf * tildeXp(:, end)...
        +tildeXv(:, end)'   * obj.param.Vf   * tildeXv(:, end)...
        +tildeXqw(:, end)'  * obj.param.QWf  * tildeXqw(:, end);
    
    %-- 評価値計算
    MCeval = sum(stageStateP + stageStateV + stageStateQW + stageInputPre + stageInputRef,"all")...
        + terminalState + constraints;
    EachCost = [sum(stageStateP), sum(stageStateV), sum(stageStateQW)];
end