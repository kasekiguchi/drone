%%%========================================================
%   main_ArnoldyArgolithm.m
%   データからクープマン固有値を求めるアーノルディ型アルゴリズム
%   作成者: 東京都市大学 高機能機械制御研究室 修士2年 磯部勇吉
%   lastUpdate: 2023/03/31
%%%=======================================================

%% 初期化
clear all; close all;

%% データ読み込み
% San Diego Blackout data Samplingtime = 35 sec
% dataFlowP = readmatrix('sd.dat.txt'); 
% 
% % UCTE Grid-Wide Disturbance data Sampling time = 30 sec
% dataFlowP = readmatrix('ucte.dat.txt'); 
% dataFlowP = dataFlowP(1:end,1:end-1); % 幻の9列目が読み込まれたため,とりあえず最後の1列を消去

% シミュレーションデータからデータフローを作成するテスト
F = @quaternions;
% dataFlowP = makeDataFlowFromSimulation('Data/simData_Koopman_rndP2O4',F);
% dataFlowP = makeDataFlowFromSimulation('sim_rndP4_1.mat');
% save('Data/simData_Koopman_rndP2O4/sim_rnd_P4_appendAll4KMD.mat','dataFlowP')
load('Data/simData_Koopman_rndP2O4/sim_rnd_P4_appendAll4KMD.mat')

% 元データは縦列が時系列なので横向きになるように転置
dataFlowP = dataFlowP';

%% 行列A,bの計算
% 元データ行列の次元を確認
[matrixSize.m, matrixSize.N] = size(dataFlowP);
% A
matrix.A = dataFlowP(1:end-1,1:end-1)'*dataFlowP(1:end-1,1:end-1);
% for i = 1 : matrixSize.N-1
%     for j = 1 : matrixSize.N-1
%         matrix.A(i,j) = dataFlowP(:,i)'*dataFlowP(:,j);
%     end
% end

% b
matrix.b = dataFlowP(1:end-1,1:end-1)'*dataFlowP(1:end-1,matrixSize.N);
% for i = 1 : matrixSize.N-1
%     matrix.b(i,1) = dataFlowP(:,i)'*dataFlowP(:,matrixSize.N);
% end

%% 行列Aのランクをチェックして定数行列cとCを計算
if rank(matrix.A) == size(matrix.A,1)
    disp('matrix A is FullRank')
    matrix.c = matrix.A\matrix.b;
    matrix.C = cat(2,[zeros(1,matrixSize.N-2);eye(matrixSize.N-2)],matrix.c);
else
    disp('matrix A is not FullRank')
    matrix.c = pinv(matrix.A)*matrix.b;
    matrix.C = cat(2,[zeros(1,matrixSize.N-2);eye(matrixSize.N-2)],matrix.c);
end

%% 求めた定数行列Cからヴァンデルモンド行列Tを計算
matrix.lambda = eig(matrix.C);
matrix.T = fliplr(vander(matrix.lambda));
% matrix.T = matrix.lambda.^0;
% for i = 1:matrixSize.N-2
%     matrix.T = [matrix.T,matrix.lambda.^(i)];
% end

%% 行列Vを計算
matrix.V = dataFlowP(:,1:matrixSize.N-1)/(matrix.T);
% for k = 1:matrixSize.N-1
%     for j = 1:matrixSize.N-1
%         P(:,k) = matrix.lambda(j)^k*matrix.V(:,j);
%     end
% end
P = matrix.V*matrix.T;

% r = dataFlowP(:,matrixSize.N);
% for j = 1:matrixSize.N-1
%     r = r-matrix.c(j)*dataFlowP(:,j);
% end
r = dataFlowP(:,matrixSize.N)-dataFlowP(:,1:matrixSize.N-1)*matrix.c;

%%
P(:,matrixSize.N-1) = P(:,matrixSize.N-1) + r;
% for j = 1:matrixSize.N-1
%     P(:,matrixSize.N-1) = P(:,matrixSize.N-1)+matrix.lambda(j)^(matrixSize.N-1)*matrix.V(:,j);
% end

% %% 論文の(D)
% 共役複素数を探す
% todo lambda_dashが対象行列になってない?
lambda_dash = matrix.lambda*transpose(matrix.lambda);
[row,col]=ind2sub(size(lambda_dash),find(abs(imag(lambda_dash))<0.001));
%% ISO = row<col;
ISO = find(row<col);
L1 = matrix.lambda(row(ISO(end-1)));
L2 = matrix.lambda(col(ISO(end-1)));
V1 = matrix.V(:,row(ISO(end-1)));
V2 = matrix.V(:,col(ISO(end-1)));

% P_Unstable = L1.*V1+L2.*V2;
for k  = 1:matrixSize.N
    P_Unstable(:,k) = L1.^k.*V1 + L2.^k.*V2;
end

%% 結果をplot
fnum = 1;
% %% データフロー
figure(fnum)
fnum = fnum+1;
plot(dataFlowP','Marker','.')
grid on


%% 複素平面
figure(fnum)
fnum = fnum+1;
plot(matrix.lambda,'o')
plotProperty = get(gca);
plotLength = abs(plotProperty.XLim(1));
if plotLength<abs(plotProperty.YLim(1))
    plotLength = abs(plotProperty.YLim(1));
end
if plotLength<abs(plotProperty.XLim(2))
    plotLength = abs(plotProperty.XLim(2));
end
if plotLength<abs(plotProperty.YLim(2))
    plotLength = abs(plotProperty.YLim(2));
end
plotLength = [-plotLength,plotLength];
xlim(plotLength);ylim(plotLength);
axis square
grid on
viscircles([0,0],1)
% % モード分解
figure(fnum)
fnum = fnum+1;
plot(real(P_Unstable)','Marker','.')
grid on
