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


output = QP_solve(X, Y, Xlift, Ylift, U, numX, numU); % 最適化による行列の算出

% output = A, B, C
end

function mat = QP_solve(X, Y, Xlift, Ylift, U, numX, numU)
    % Ylift - AXlift - BU
    % X - CXlift
    
    %% 一旦fminconで作ろう
    options = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter-detailed', ...
    'UseParallel', false, ... % 並列化を有効にするなら true
    'StepTolerance', 1e-6, ...
    'OptimalityTolerance', 1e-4, ...
    'ConstraintTolerance', 1e-12, ...
    'MaxFunctionEvaluations', 5e5, ...
    'MaxIterations', 100);


    %% A, B
    % fun = @(A, B) Ylift - A*Xlift - B*U;
    fun = @(AB) Ylift - AB(1:numX, 1:numX)*Xlift - AB(1:numX, numX+1:numX+numU)*U;
    x0 = [eye(numX), zeros(numX, numU)]; % 初期値
    A = []; b = []; % 線形不等式制約
    Aeq = []; beq = []; % 線形等式制約
    lb = []; ub = []; % 下限，上限
    nonlcon = @const; % 非線形制約
    sol = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);


end

function [c, ceq] = const(x)
end