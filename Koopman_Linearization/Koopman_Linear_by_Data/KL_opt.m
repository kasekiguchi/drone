function output = KL_opt(X,U,Y,F,maxEval)
%KL クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
% 最適化計算によって求める
%   output = KoopmanLinear(X,U,Y)
%   outuput.A .B  観測量空間における線形アフィン系の係数行列 Z[k+1] = A*Z[k]+Bu[k]
%          .C     観測量空間から状態空間に送る線形状態方程式の係数行列 X[k] = C*Z[k]
%   X, U, Y       観測する状態Xに入力Uを与えた際の出力Yを集めたデータセット
%                 列：データ, 行：時系列
%   F             観測量 関数ハンドル

%Xlift,Yliftを計算する
for i = 1:size(X,2)%1:Data.num
    Xlift(:,i) = F(X(:,i));
    Ylift(:,i) = F(Y(:,i));
end

[numX, ~] = size(Xlift); %[numX, ~]=size(Xlift): Xliftのサイズ=(A行,B列)のとき，A行の値をnumXに入れ，B列の値は使わない(~:notの意味)
[numU, ~] = size(U);

%% 最適化による算出
Q = [0.01, 1];
% 初期値を解析解に設定
load('Koopman_Linearization\EstimationResult\EstimationResult_2024-07-11_Exp_Kiyama_code08_not_optim_saddle.mat', 'est');
% x0_AB.A = eye(numX);
% x0_AB.B = zeros(numX, numU);
% x0_C.C = zeros(12, numX);
x0_AB.A = est.A;
x0_AB.B = est.B;
x0_C.C = est.C;
% optimization
options = optimoptions('fminunc','MaxFunctionEvaluations', maxEval, 'Display','iter', 'UseParallel',true);
% sol,fval,exitflag,output
tic
A = optimvar('A', numX, numX);
B = optimvar('B', numX, numU);
prob_AB = optimproblem;
prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + Q(1) * norm(Xlift,1) + Q(2) * norm(Xlift,2);
% prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + norm(Xlift,1);
% prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro");
[sol_AB, fval(1,1), ~, output_AB] = solve(prob_AB, x0_AB, 'Options', options);
time.ABtime = toc

tic
C = optimvar('C', 12, numX);
prob_C = optimproblem;
prob_C.Objective = norm(X - C*Xlift, "fro") + Q(1) * norm(Xlift,1) + Q(2) * norm(Xlift,2);
% prob_C.Objective = norm(X - C*Xlift, "fro") + norm(Xlift,1);
% prob_C.Objective = norm(X - C*Xlift, "fro");
[sol_C, fval(1,2), ~, output_C]  = solve(prob_C, x0_C, 'Options', options);
time.Ctime = toc

%% 複数回繰り返す
% 初期値を解析解に設定
% load('Koopman_Linearization\EstimationResult\EstimationResult_2024-07-11_Exp_Kiyama_code08_not_optim_saddle.mat', 'est');
% sol_AB.A = est.A;
% sol_AB.B = est.B;
% sol_C.C = est.C;
% options = optimoptions('fminunc','MaxFunctionEvaluations', maxEval,'UseParallel',true,'Display','iter');
% A = optimvar('A', numX, numX);
% B = optimvar('B', numX, numU);
% C = optimvar('C', 12, numX);
% prob_AB = optimproblem;
% prob_C = optimproblem;
% for i = 1:2
%     x0_AB.A = sol_AB.A;
%     x0_AB.B = sol_AB.B;
%     x0_C.C = sol_C.C;
% 
%     prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + Ql1  * norm(Xlift,1) + QL2 * norm(Xlift,2);
%     % prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + norm(Xlift,1);
%     % prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro");
%     [sol_AB, fval(1,1), ~, output_AB] = solve(prob_AB, x0_AB, 'Options', options);
% 
%     prob_C.Objective = norm(X - C*Xlift, "fro") + norm(Xlift,1) + norm(Xlift,2);
%     % prob_C.Objective = norm(X - C*Xlift, "fro") + norm(Xlift,1);
%     % prob_C.Objective = norm(X - C*Xlift, "fro");
%     [sol_C, fval(1,2), ~, output_C]  = solve(prob_C, x0_C, 'Options', options);
% end

%% logging
output.A = sol_AB.A;
output.B = sol_AB.B;
output.C = sol_C.C;
output.time = time;
output.output_AB = output_AB;
output.output_C  = output_C;
output.fval = fval;
end