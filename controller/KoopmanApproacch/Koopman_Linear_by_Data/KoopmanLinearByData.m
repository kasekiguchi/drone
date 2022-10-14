%% Koopman Linear by Data %%

% initialize
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename))

clc
clear
close all

%% load data
% 実験データから必要なものを抜き出す処理
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

Data = InportFromExpData();

%% Defining Koopman Operator
% クープマン作用素を定義
% F@(X) クープマン作用素 Xに関する無名関数として定義
F = @(x) x; % 状態そのまま


%% Koopman linear
%Xlift,Yliftを計算する
for i = 1:size(Data.X,2)%1:Data.num
    est.Xlift(:,i) = F(Data.X(:,i));
    est.Ylift(:,i) = F(Data.Y(:,i));
end
 
% 個別にA,Bを計算する
% est.Ahat = est.Ylift*pinv(est.Xlift);
% est.Bhat = est.Ylift*pinv(Data.U);
% est.Chat = Data.X*pinv(est.Xlift);

%ABをまとめて計算する 参考資料記載のやりかた
% est.ABhat = est.Ylift * pinv([est.Xlift; Data.U]);
% est.Ahat = est.ABhat(1:size(est.Xlift(:,1)),1:size(est.Xlift(:,1)));
% est.Bhat = est.ABhat(1:size(est.Ylift(:,1)),1:size(u));
% est.Chat = Data.X*pinv(est.Xlift);

%A,Bをまとめて計算するデータ数が多い場合のやりかた
est.G = [est.Xlift ; Data.U]*[est.Xlift ; Data.U]';
est.V = est.Ylift*[est.Xlift ; Data.U]';
est.M = est.V * pinv(est.G);
est.Ahat = est.M(1:size(est.Xlift(:,1)),1:size(est.Xlift(:,1)));
est.Bhat = est.M(1:size(est.Ylift(:,1)),1:size(Data.U));
est.Chat = Data.X*pinv(est.Xlift); % C: Z->X の厳密な求め方
% est.Chat = [eye(2),zeros(2,4)]; % 観測量の頭に元の状態が含まれているときの C: Z->X

disp('Estimation Finishd')

%% Simulation by Estimated model
simResult.Z(:,1) = F(Data.X(:,1));
simResult.X = Data.X;
simResult.Xhat(:,1) = Data.X(:,1);
simResult.U = Data.U;
simResult.T = Data.T;
for i = 1:1:Data.N-2
    simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + est.Bhat * simResult.U(:,i);
    simResult.Xhat(:,i+1) = est.Chat * simResult.Z(:,i);
end

%% Plot
figure(1)
p1 = plot(simResult.T , simResult.Xhat(1:3,:));
figure(2)
p2 = plot(Data.T,Data.X(1:3,:));

