function [eval] = Objective_renew(x, params, input) % x : p q v w input
%-- 評価計算をする関数
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
%元の非線形等式制約を取り込んだ

    X = zeros(size(params.A,1), params.H-1);
    Xc = quaternions(params.X0); % 観測量＋１する関数
%     Xc = [params.X0;1];
    X(:,1) = params.A*Xc + params.B*x(:,1);
    for i = 2:params.H-1
        X(:,i) = params.A*X(:,i-1) + params.B*x(:,i);
    end
    Xn = [params.X0,X(1:12,:)];

    tildeXp = Xn(1:3, :) - params.xr(1:3, :);  % 位置
    tildeXq = Xn(4:6, :) - params.xr(4:6, :);
    tildeXv = Xn(7:9, :) - params.xr(7:9, :);  % 速度
    tildeXw = Xn(10:12, :) - params.xr(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUref = x - params.xr(13:16,:);
    tildeUpre = x - input;
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP = sum(tildeXp(:, 1:params.H-1)'*params.Weight.P .*tildeXp(:, 1:params.H-1)', 2);
    stageStateV = sum(tildeXv(:, 1:params.H-1)'*params.Weight.V .*tildeXv(:, 1:params.H-1)', 2);
    stageStateQW = sum(tildeXqw(:, 1:params.H-1)'*params.Weight.QW .*tildeXqw(:, 1:params.H-1)', 2);
    stageInputR = sum(tildeUref(:, 1:params.H-1)'*params.Weight.R .*tildeUref(:, 1:params.H-1)', 2);
    stageInputRP = sum(tildeUpre(:, 1:params.H-1)'*params.Weight.RP .*tildeUpre(:, 1:params.H-1)', 2);
    
    % stageStatePs = diag(tildeXp(:, 1:params.H-1)'*params.Weight.P *tildeXp(:, 1:params.H-1)); % 対角成分取り出し
    % stageStateVs = diag(tildeXv(:, 1:params.H-1)'*params.Weight.V *tildeXv(:, 1:params.H-1));
    % stageStateQWs = diag(tildeXqw(:, 1:params.H-1)'*params.Weight.QW *tildeXqw(:, 1:params.H-1));
    % stageInputRs = diag(tildeUref(:, 1:params.H-1)'*params.Weight.R *tildeUref(:, 1:params.H-1));
    % stageInputRPs = diag(tildeUpre(:, 1:params.H-1)'*params.Weight.RP *tildeUpre(:, 1:params.H-1));
    
    stageState = stageStateP + stageStateV + stageStateQW + stageInputR + stageInputRP; %ステージコスト
    
%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * params.Weight.Pf   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.Vf   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QWf  * tildeXqw(:, end);

    % 高度0未満に何か足す
    % Alt = sum(Xn(1, find(Xn(3,:) < 0)) + 1e4);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end