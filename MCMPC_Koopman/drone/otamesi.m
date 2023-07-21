% 目的関数: f(x) = x1^2 + x2^2
fun = @(x) x(1)^2 + x(2)^2;

% 初期値
x0 = [0; 0];

% 不等式制約条件: A*x <= b
A = [-1, -1; 1, -2];
b = [-2; 2];

% 等式制約条件: Aeq*x = beq
Aeq = [];
beq = [];

% 最適化変数の下限と上限: lb <= x <= ub
lb = [-2; -2];
ub = [2; 2];

% 追加の非線形制約条件 (オプションで、空の行列 [] に設定します)
nonlcon = [];

% 制約付き最適化の実行
[x, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon);
disp(x);    % 最適な変数の値
disp(fval); % 目的関数の最適値
