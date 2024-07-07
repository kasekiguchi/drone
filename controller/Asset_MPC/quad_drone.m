function [var, fval, exitflag] = quad_drone(param)
%QUADPROG FOR DRONE mex化のためにqpの計算を関数化
%　パラメータの定義

    % QP設定
    opts = optimoptions('quadprog','Algorithm','active-set','OptimalityTolerance',1e-5);
    opts.Display = 'none';   % 計算結果の表示

    % opts = optimoptions('quadprog');
    % opts = optimoptions(opts,'MaxIterations',      1.e+2); % 最大反復回数
    % opts = optimoptions(opts,'ConstraintTolerance',1.e-5);     % 制約違反に対する許容誤差
    
    % Calculate the coefficient matrix of QP
    % Xc = quaternions_all(param.current_state); % for Koopman
    Xc = param.current_state; % for HL

    r  = param.ref(1:12,:);
    r = r(:); %目標値、列ベクトルに変換
    ur = param.ref(13:16,:);
    ur = ur(:); %目標入力、列ベクトルに変換

    H = param.qpH;
    f = [Xc', r', ur'] * param.qpF;
    % f = param.qpf(Xc, r, ur);

    % options, constraints, initial state
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = repmat(param.lb, param.H, 1); % 下限制約
    ub = repmat(param.ub, param.H, 1); % 上限制約
    x0 = [param.previous_input(:)];
      
    [var, fval, exitflag] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, opts); %最適化計算
end