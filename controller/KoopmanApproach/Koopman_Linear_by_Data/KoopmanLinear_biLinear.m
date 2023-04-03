function [A,B,E,C] = KoopmanLinear_biLinear(X,U,Y,F)
%KOOPMANLINEAR_biLinear クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
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

% ABをまとめて計算する 参考資料記載のやりかた
% M = Ylift * pinv([Xlift; U; Xlift*U]);
% A = M(1 : numX, 1 : numX);
% B = M(1 : numX, numX + 1:numX + numU);
% E = M(1 : numX, numX + numU + 1 : end);
% C = X*pinv(Xlift);
% 
% A,Bをまとめて計算するデータ数が多い場合のやりかた
roll = Xlift(4,:);
pitch = Xlift(5,:);
yaw = Xlift(6,:);
% R*ez
R13 = ( 2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)) + 2.*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)));
R23 = (-2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)) - 2.*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)));
R33 =  (cos(pitch).*cos(roll));
SumU=sum(U,1); % [1,1,1,1]*u
RU = [R13.*SumU;R23.*SumU;R33.*SumU]; 
% RU = [R13.*SumU;R23.*SumU;]; % R33CO
XU = [Xlift ; U;RU];
G = XU*XU';
V = Ylift*XU';
M = V * pinv(G);
A = M(1:numX, 1:numX);
B = M(1:numX, numX+1:numX+numU);
E = M(1 : numX, numX + numU + 1 : end); % => E*R*ez*[1,1,1,1]*u
% dZ = A*Z + (B + E*R*ez*[1,1,1,1])*u
C = X*pinv(Xlift); % C: Z->X の厳密な求め方
end

