function eval = objective_1sample(obj, X, U)
    % U = obj.input.u;
    % X = obj.state.state_data;
    % eval = zeros(obj.N, 2);

    X = repmat(X, 1, 1, 1);

    %% ホライズンで重み大きく
    k = linspace(1,1.2, obj.param.H); % これにより制約はいるとき滑らかになる
    % k = ones(1, obj.param.H);

    %% 誤差計算
    tildeUpre = U - obj.input.pre_u;          % 前時刻入力
    tildeUref = U - obj.param.ref_input;  % 目標入力

    %% -- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算
    stageInputPre  = k .* tildeUpre.*pagemtimes(obj.WeightR,tildeUpre);
    stageInputRef  = k .* tildeUref.*pagemtimes(obj.WeightRp,tildeUref);

    stageStateX =    k .* X.*pagemtimes(obj.Weight,X);
    terminalState = 0;

    %% 人工ポテンシャル場法
    % Jconst = Constraints(obj);
    % Jconst(:,1) = {zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N); zeros(1,1,obj.N)};
    %% ステージコストとターミナルコストを合計
    costX = stageStateX + terminalState;

    eval(1) = sum(costX, [1,2]) + sum(stageInputPre,[1,2]) + sum(stageInputRef,[1,2]);
    eval(2) = sum(stageInputRef,[1,2]);
    % 
end
        