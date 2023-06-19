function output = KL_biLinear(X,U,Y,F)
%KL_biLinear クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
%   output = KoopmanLinear(X,U,Y)
%   output
%       .ABE    観測量空間における線形アフィン系の係数行列 Z[k+1] = ABE'*[Z[k];U[k];reshape(kron(Z[k],U[k]),[],1)]
%       .C      観測量空間から状態空間に送る線形状態方程式の係数行列 X[k] = C*Z[k]
%   X, U, Y     状態Xに入力Uを与えた際の次時刻の状態Yを集めたデータセット Y[k] = X[k+1]
%               列：データ, 行：時系列
%   F           観測量 関数ハンドル形式 Z[k] = F(X[k])

%Xlift,Yliftを計算する
for i = 1:size(X,2)%1:Data.num
    Xlift(:,i) = F(X(:,i));
    Ylift(:,i) = F(Y(:,i));
end
[numX, ~] = size(Xlift);
[numU, ~] = size(U);

%% 係数行列ABE 新型
% F(Y) = AF(X) + (B + EF(X))U
% AA*[A';B';E1';E2';....;Em'] = BB
% AA = [F',U',F',F',...,F']
% BB = FY';
N = size(U,2);
ZU = zeros(numU*numX,N);
for i = 1:N
    ZU(:,i) = reshape(kron(Xlift(:,i),U(:,i)),[],1);
end
AA = [Xlift' U' ZU'];
BB = Ylift';
ABE = pinv(AA)*BB;

% Z+ = ABE'*[Z;U;reshape(kron(Z,U),[],1)];

%% 係数行列A,B,E 旧式
% M = Ylift * pinv([Xlift; U; Xlift*U]);
% A = M(1 : numX, 1 : numX);
% B = M(1 : numX, numX + 1:numX + numU);
% E = M(1 : numX, numX + numU + 1 : end);
% C = X*pinv(Xlift);

% roll = Xlift(4,:);
% pitch = Xlift(5,:);
% yaw = Xlift(6,:);
% R*ez
% R13 = ( 2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)) + 2.*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)));
% R23 = (-2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)) - 2.*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)));
% R33 =  (cos(pitch).*cos(roll));
% SumU=sum(U,1); % [1,1,1,1]*u
% RU = [R13.*SumU;R23.*SumU;R33.*SumU]; 
% % RU = [R13.*SumU;R23.*SumU;]; % R33CO
% XU = [Xlift ; U;RU];
% G = XU*XU';
% V = Ylift*XU';
% M = V * pinv(G);
% A = M(1:numX, 1:numX);
% B = M(1:numX, numX+1:numX+numU);
% E = M(1 : numX, numX + numU + 1 : end); % => E*R*ez*[1,1,1,1]*u
% dZ = A*Z + (B + E*R*ez*[1,1,1,1])*u

%% C
C = X*pinv(Xlift); % C: Z->X の厳密な求め方

%% output
output= struct('ABE',ABE,'C',C);
end

