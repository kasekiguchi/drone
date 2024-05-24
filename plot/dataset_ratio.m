%% Importing data
% 結合されたデータを読み込む
clear
load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat');
X = Data.X;
Y = Data.Y;
U = Data.U;

%% データセットがどういう割合のデータなのか算出する
close all
T = 1:size(Data.X,2);
figure(1);
plot(T, Data.X(1:3,:)); ylabel("Position")
legend("$$x$$", "$$y$$", "$$z$$", "Interpreter", "latex")

%% 正負に分割　⇒　中央値を求める
Xplus_idx = find(X(1,:)>=0); Xminus_idx = find(X(1,:)<0);
Yplus_idx = find(X(2,:)>=0); Yminus_idx = find(X(2,:)<0);

Xplus_median = median(X(1,Xplus_idx)); Xminus_median = median(X(1,Xminus_idx));
Yplus_median = median(X(2,Yplus_idx)); Yminus_median = median(X(2,Yminus_idx));

result_median = [Xplus_median Xminus_median Yplus_median Yminus_median]

%% 座標の総移動距離の比較
error = Y(1:3,:) - X(1:3,:);
all_dis = sum(error,2)'

