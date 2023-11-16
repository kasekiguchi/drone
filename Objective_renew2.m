function [eval] = Objective_renew2(x, params) % x : p q v w input
%-- 評価計算をする関数
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
%元の非線形等式制約を取り込んだ

    X = zeros(size(params.A,1), params.H-1);
    Xc = quaternions(params.X0);
%     Xc = [params.X0;1];
    X(:,1) = params.A*Xc + params.B*x(:,1);
    for i = 2:params.H-1
        X(:,i) = params.A*X(:,i-1) + params.B*x(:,i);
    end
    Xn = [params.X0,X(1:params.state_size,:)];
%     Xn = [Xc,X(:,:)]; %観測量の非線形項を評価項に導入

    tildeXp = Xn(1:3, :) - params.xr(1:3, :);  % 位置
    tildeXq = Xn(4:6, :) - params.xr(4:6, :);
    tildeXv = Xn(7:9, :) - params.xr(7:9, :);  % 速度
    tildeXw = Xn(10:12, :) - params.xr(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUref = x(:, :) - params.xr(13:16,:);
%     tildeA = Xn(17:26, :) - params.xr(17:26, :);
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP = tildeXp(:, 1:params.H-1)'*params.Weight.P*tildeXp(:, 1:params.H-1);
    stageStateV = tildeXv(:, 1:params.H-1)'*params.Weight.V*tildeXv(:, 1:params.H-1);
    stageStateQW = tildeXqw(:, 1:params.H-1)'*params.Weight.QW*tildeXqw(:, 1:params.H-1);
    stageInputR = tildeUref(:, 1:params.H-1)'*params.Weight.R*tildeUref(:, 1:params.H-1);
%     stageStateA = tildeA(:, 1:params.H-1)'*params.Weight.A*tildeA(:, 1:params.H-1);
    
    stageStateP = diag(stageStateP);
    stageStateV = diag(stageStateV);
    stageStateQW = diag(stageStateQW);
    stageInputR = diag(stageInputR);
%     stageStateA = diag(stageStateA);
    
    stageState = stageStateP' + stageStateV' + stageStateQW' + stageInputR'; %ステージコスト
    
%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * params.Weight.Pf   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.Vf   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QWf  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end