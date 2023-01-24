function [A,B,C] = KoopmanLinear(X,U,Y,F)
%KOOPMANLINEAR クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
%   [A,B,C] = KoopmanLinear(X,U,Y)
%   A, B    観測量空間における線形アフィン系の係数行列 Z[k+1] = A*Z[k]+Bu[k]
%   C       観測量空間から状態空間に送る線形状態方程式の係数行列 X[k] = C*Z[k]
%   X, U, Y 観測する状態Xに入力Uを与えた際の出力Yを集めたデータセット
%             列：データ, 行：時系列
%   F       観測量 関数ハンドル

%Xlift,Yliftを計算する
for i = 1:size(X,2)%1:Data.num
    Xlift(:,i) = F(X(:,i));
    Ylift(:,i) = F(Y(:,i));
end
[numX, ~] = size(Xlift);
[numU, ~] = size(U);

% %ABをまとめて計算する 参考資料記載のやりかた
% M = Ylift * pinv([Xlift; U]);
% A = M(1 : numX, 1 : numX);
% B = M(1 : numX, numX + 1:numX + numU);
% C = X*pinv(Xlift);

% A,Bをまとめて計算するデータ数が多い場合のやりかた
G = [Xlift ; U]*[Xlift ; U]';
V = Ylift*[Xlift ; U]';
M = V * pinv(G);
A = M(1:numX, 1:numX);
B = M(1:numX, numX+1:numX+numU);
C = X*pinv(Xlift); % C: Z->X の厳密な求め方
end

