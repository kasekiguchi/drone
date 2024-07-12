function output = KL_opt_MC(X,U,Y,F,maxEval)
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
% 初期値を解析解に設定
% x0_AB.A = eye(numX);
% x0_AB.B = zeros(numX, numU);
% x0_C.C = zeros(12, numX);
% x0_AB.A = est.A;
% x0_AB.B = est.B;
% x0_C.C = est.C;
% % optimization
% % sol,fval,exitflag,output
% tic
% A = optimvar('A', numX, numX);
% B = optimvar('B', numX, numU);
% prob_AB = optimproblem;
% prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + norm(Xlift,1) + norm(Xlift,2);
% % prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro") + norm(Xlift,1);
% % prob_AB.Objective = norm(Ylift - A*Xlift - B*U, "fro");
% [sol_AB, fval(1,1), ~, output_AB] = solve(prob_AB, x0_AB, 'Options', options);
% time.ABtime = toc
% 
% tic
% C = optimvar('C', 12, numX);
% prob_C = optimproblem;
% prob_C.Objective = norm(X - C*Xlift, "fro") + norm(Xlift,1) + norm(Xlift,2);
% % prob_C.Objective = norm(X - C*Xlift, "fro") + norm(Xlift,1);
% % prob_C.Objective = norm(X - C*Xlift, "fro");
% [sol_C, fval(1,2), ~, output_C]  = solve(prob_C, x0_C, 'Options', options);
% time.Ctime = toc

% optimization by Monte Carlo
N = 10000;
J_AB_old = gpuArray(1e10);
J_C_old  = gpuArray(1e10);
Xlift = gpuArray(Xlift);
Ylift = gpuArray(Ylift);
% maxEval = 10;
for i = 1:N
    A = gpuArray(rand(numX,numX));
    B = gpuArray(rand(numX,numU));
    C = gpuArray(rand(12,numX));
    J_AB = norm(Ylift - A*Xlift - B*U, "fro") + norm(Xlift,1) + norm(Xlift,2);
    J_C  = norm(X - C*Xlift, "fro") + norm(Xlift,1) + norm(Xlift,2);
    if lt(J_AB, J_AB_old) 
        J_AB_old = J_AB; 
        output_A = A; output_B = B; 
    end
    if lt(J_C,  J_C_old)  
        J_C_old  = J_C;  
        output_C = C; 
    end
    if rem(i, 5) == 0
        disp(["i: " + i]);
    end
end

%% logging
output.A = output_A;
output.B = output_B;
output.C = output_C;
% output.time = time;
% output.output_AB = output_AB;
% output.output_C  = output_C;
output.fval = [J_AB_old, J_C_old];
end