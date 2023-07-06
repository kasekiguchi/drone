function [c, ceq] = constraints_HL(objHL_const, x)
    % モデル予測制御の制約条件を計算するプログラム
    c  = zeros(12, objHL_const.H);
    ceq_ode = zeros(12, objHL_const.H);

    X = x(1:12, :);          % 12 * Params.H
    U = x(13:16, :);   % 4 * Params.H

    for L = 2:objHL_const.H
        xx = X(:, L-1);
        xu = U(:, L-1);
        tmp = objHL_const.A * xx + objHL_const.B * xu;
        ceq_ode(:, L) = X(:, L) - tmp;   % tmpx : 縦ベクトル？
    end
    ceq = [X(:, 1) - objHL_const.current_state, ceq_ode];
end