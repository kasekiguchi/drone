%% クープマンモデルを最適化から解く方法
function output = KL_optimization(X,U,Y,F,flg)
%KL クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
%   output = KoopmanLinear(X,U,Y)
%   outuput.A .B  観測量空間における線形アフィン系の係数行列 Z[k+1] = A*Z[k]+Bu[k]
%          .C     観測量空間から状態空間に送る線形状態方程式の係数行列 X[k] = C*Z[k]
%   X, U, Y       観測する状態Xに入力Uを与えた際の出力Yを集めたデータセット
%                 列：データ, 行：時系列
%   F             観測量 関数ハンドル
tic
%Xlift,Yliftを計算する
remi = round(size(X,2) / 5); j = 0;
for i = 1:size(X,2)%1:Data.num
    if flg.hermite
        dx = [X(:,i);U(:,i)]; % hermite
        dy = [Y(:,i);U(:,i)];
    else
        dx = X(:,i); % ふつう
        dy = Y(:,i);
    end
    Xlift(:,i) = F(dx); 
    Ylift(:,i) = F(dy);
    if rem(i, remi) == 0
        j = j+1;
        fprintf('convert %d times observables \n', remi*j);
        toc
    end
end

[numX, ~] = size(Xlift); %[numX, ~]=size(Xlift): Xliftのサイズ=(A行,B列)のとき，A行の値をnumXに入れ，B列の値は使わない(~:notの意味)
[numU, ~] = size(U);

% output = A, B, C
% II = linspace(1, 1e-5, 100);
% for i = 1:length(II)
%     lambda_AB = II(i);
%     try
%         tmp = QP_solve(X, Y, Xlift, Ylift, U, numX, numU, lambda_AB); % 最適化による行列の算出
%     catch
%         output = tmp;
%         break
%     end
% end
lambda_AB = 1e-5;
output = QP_solve(X, Y, Xlift, Ylift, U, numX, numU, lambda_AB); % 最適化による行列の算出
end

function mat = QP_solve(X, Y, Xlift, Ylift, U, numX, numU, lambda_AB)
    % Ylift - AXlift - BU
    % X - CXlift
    
    %% PART1: 一旦fminconで作ろう
    options = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter-detailed', ...
    'UseParallel', true, ... % 並列化を有効にするなら true
    'StepTolerance', 1e-6, ...
    'OptimalityTolerance', 1e-4, ...
    'ConstraintTolerance', 1e-12, ...
    'MaxFunctionEvaluations', 5e5, ...
    'MaxIterations', 10);

    %-- A, B :fun = @(A, B) Ylift - A*Xlift - B*U;
    fun = @(AB) norm(Ylift - AB(1:numX, 1:numX)*Xlift - AB(1:numX, numX+1:numX+numU)*U, "fro") + norm(AB) + norm(AB,2); 
    x0 = [eye(numX), zeros(numX, numU)]; % 初期値
    A = []; b = []; % 線形不等式制約
    Aeq = []; beq = []; % 線形等式制約
    lb = []; ub = []; % 下限，上限
    nonlcon = @const_AB_fmincon; % 非線形制約
    % [A,b,Aeq,beq,lb,ub] = const_AB(Xlift, Ylift, U, numX, numU, lambda_AB);
    sol = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);
    mat.A = sol(1:numX, 1:numX);
    mat.B = sol(1:numX, numX+1:numX+numU);

    %-- C: 
    % fun =  @(C) norm(X - C*Xlift, "fro"); % frobenius norm
    %  x0 = [eye(12), zeros(12,numX-12)];
    % A = []; b = []; % 線形不等式制約
    % Aeq = []; beq = []; % 線形等式制約
    % lb = []; ub = []; % 下限，上限
    % nonlcon = @const_C; % 非線形制約
    % sol = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, [], options);
    % mat.C = sol;

    %% PART2: QPに変換しよう
    options = optimoptions('quadprog','Display','iter');
    % % A = []; b = []; % 線形不等式制約
    % % Aeq = []; beq = []; % 線形等式制約
    % % lb = []; ub = []; % 下限，上限
    % x0A = eye(numX); x0B = zeros(numX, numU); 
    % %-- A, B
    % [A,b,Aeq,beq,lb,ub] = const_AB(Xlift, Ylift, U, numX, numU, lambda_AB);
    % % A = []; b = []; Aeq = []; beq = []; lb = []; ub = [];
    % H = [Xlift*Xlift', Xlift*U'; U*Xlift', U*U'];
    % H = kron(H, eye(numX));
    % H = (H + H') / 2;
    % f = -[Xlift*Ylift'; U*Ylift'];
    % f = f(:);
    % x0 = [x0A(:); x0B(:)]; %zeros(numX*numX+numX*numU, 1);
    % opt = quadprog(H, f, A, b, Aeq, beq,lb, ub, x0, options);
    % mat.A = reshape(opt(1:numX*numX), numX, numX);
    % mat.B = reshape(opt(numX*numX+1:end), numX, numU);
    % 
    %-- C
    % [A,b,Aeq,beq,lb,ub] = const_C(Xlift, Ylift, U, numX, numU);
    A = []; b = []; Aeq = []; beq = []; lb = []; ub = [];
    x0C = [eye(12), zeros(12,numX-12)];
    H = kron(Xlift * Xlift', eye(12));
    H = (H + H') / 2;
    f = -(X * Xlift');
    f = f(:);
    x0 = [x0C(:)];
    opt = quadprog(H, f, A, b, Aeq, beq,lb, ub, x0, options);
    mat.C = reshape(opt, 12, numX);
end

function [c, ceq] = const_AB_fmincon(x)
% c(x) <= 0
% ceq(x) = 0
% x = [A, B]
dt = 0.025;
c = [];
ceq = [];
for i = 1:12
    ceq = [ceq, x(i,i)-1];
end
ceq = [ceq, x(1, 7)-dt, x(2, 8)-dt, x(3, 9)-dt]; % vel -> pos
ceq = [ceq, x(4,10)-dt, x(5,11)-dt, x(6,12)-dt]; % ang vel -> ang
end

%% 制約（拘束）
% Aeq*x = beq
% A*x  <= b
function [A,b,Aeq,beq,lb,ub] = const_AB(x, y, u, numX, numU, lambda_AB)
    lb = [];
    ub = [];
    g = 9.81;
    dt = 0.025; % control cycle

    % 状態次元とリフト次元
    n_state = 12;   % 状態（p, q, v, w）→ 12次元
    n_lift = numX;    % 観測量（リフト状態）→ 20次元
    m_input = numU;    % 入力（総推力 T + トルク τx, τy, τz）→ 4次元
    
    % 変数の総数
    num_A_vars = n_lift * n_lift; % 26*26個
    num_B_vars = n_lift * m_input; % 26*4個
    num_vars = num_A_vars + num_B_vars; % 26*26 + 26*4個

    %-- L1正則化のためのスラック変数 
    % % lambda_AB = 10;
    % s_A = ones(num_A_vars, 1); 
    % s_B = ones(num_B_vars, 1); % 不等式制約（L1ノルムの正則化） 
    % A = [eye(num_A_vars), zeros(num_A_vars, num_vars - num_A_vars); 
    %     -eye(num_A_vars), zeros(num_A_vars, num_vars - num_A_vars); 
    %     zeros(num_B_vars, num_A_vars), eye(num_B_vars), zeros(num_B_vars, num_vars - num_A_vars - num_B_vars); 
    %     zeros(num_B_vars, num_A_vars), -eye(num_B_vars), zeros(num_B_vars, num_vars - num_A_vars - num_B_vars)]; 
    % b = lambda_AB * [s_A; s_A; s_B; s_B];
    % 
    % % 制約部分は0にして除外
    % for j = 1:12
    %     A(:,26*(j-1)+1:26*(j-1)+12) = zeros(size(A,1), 12);
    % end
    A = []; b = [];
    
    %-- Aeq（物理法則の制約: A行列のみに適用）
    Aeq = zeros(n_state, num_vars);  
    for i = 1:3
        % A行列の適切な要素に 1 を設定
        row_idx_p = i; % 位置
        row_idx_q = i + 3; % 姿勢
        row_idx_v = i + 6; % 速度
        row_idx_w = i + 9; % 角速度
    
        Aeq(row_idx_p, i + (i-1) * n_lift) = 1;
        Aeq(row_idx_p, (i+6) + (i+6-1) * n_lift) = dt;
    
        Aeq(row_idx_q, i+3 + (i+3-1) * n_lift) = 1;
        Aeq(row_idx_q, (i+9) + (i+9-1) * n_lift) = dt;
    
        Aeq(row_idx_v, i+6 + (i+6-1) * n_lift) = 1;
        Aeq(row_idx_w, i+9 + (i+9-1) * n_lift) = 1;
    end
    
    % beq（物理法則に従うべき値）
    beq = ones(n_state, 1);  % 仮の制約値（必要に応じて調整）

    % Aeq = [];
    % beq = [];

    % %% Aeq
    % Ae_A = [I z d z;
    %       z I z d;
    %       z z I z;
    %       z z z I]; % 12x12
    % 
    % Ae_A = [I z d z]; % only position 
    % 
    % Aeq_A = zeros(size(Ae_A,1), numX*numX);
    % for i = 1:size(Ae_A,1)
    %     tmp1 = Ae_A(i,:);
    %     tmp2 = [tmp1, zeros(1,numX-12); zeros(numX-1, numX)];
    %     Aeq_A(i,:) = tmp2(:)';
    % end
    % Aeq_B = zeros(size(Ae_A,1), numX*numU);
    % Aeq = [Aeq_A, Aeq_B];
    % 
    % %% beq
    % bA = [ones(size(Ae_A,1),1)];
    % % bB = 
    % beq = bA;
    % 
end

function [A,b,Aeq,beq,lb,ub] = const_C(x, y, u, numX, numU)
    Ae_C = [eye(12), zeros(12, numX-12)];
    Aeq_C = zeros(12, 12*numX);
    for i = 1:12
        tmp1 = Ae_C(i,:);
        tmp2 = [tmp1; zeros(12-1, numX)];
        Aeq_C(i,:) = tmp2(:)';
    end
    Aeq = Aeq_C;
    beq = ones(12,1);
    A = []; b = [];
    lb = []; ub = [];
end