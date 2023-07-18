%% 論文検証 データセット作成プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
% 0.03刻み1000ステップ
%% 
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 元データ読み込み
% 名前は「state.mat」
load('state.mat');
%% 定義
rng(0) % 乱数固定
numStep = length(state{1,1}); % ステップ数
numX = min(size(state{1,1})); % 状態数x1,x2
numTE = 0; % 時間発展の数(初期化)
for i = 1:min(size(state)) % 時間発展のパターン数を算出
    for j = 1:length(state)
        if isempty(state{i,j}) == 0
            numTE = numTE + 1;
        end
    end
end
totalSnap = numTE * numStep; % 状態スナップショットの数(合計)
numTrain = 2400; % 訓練データの要素数
numTest = 600; % テストデータの要素数
% 箱
x_train = cell(1,totalSnap); % 訓練データ
xt_train = cell(1,totalSnap); % 教師データ
x_test = cell(1,totalSnap); % テストデータ
%% 教師データへの格納
for i = 1:numTE % パターン数
    for j = 1:numStep % 1パターンあたりのスナップショット数
        if i <= length(state) % 半径2円周上の初期点
            xt_train{1,j+(i-1)*numStep}(1,1) = state{1,i}(j,1); % x1
            xt_train{1,j+(i-1)*numStep}(2,1) = state{1,i}(j,2); % x2
        else % 半径0.001円周上の初期点
            xt_train{1,j+(i-1)*numStep}(1,1) = state{2,1+(i-25)*6}(j,1); % x1
            xt_train{1,j+(i-1)*numStep}(2,1) = state{2,1+(i-25)*6}(j,2); % x2
        end
    end
end
%% 訓練データとテストデータの生成
% 参照する要素を無作為に抽出
p1 = sort(randperm(totalSnap,numTrain)); % 訓練
p2 = sort(randperm(totalSnap,numTest)); % テスト
%% 欠損値の生成
mag_train = 0.1; % 倍率(訓練)
mag_test = 0.05; % 倍率(テスト)
miss_train = mag_train * randn(2,28000);
miss_test = mag_test * randn(2,28000);
%% 訓練データ・テストデータへの格納
% 最初に正常値を入れてそこへ全ての欠損値を入れる
% そして最後にサンプルの値だけ正常値を入れる
k1 = 1; % p1の要素番号のカウント
k2 = 1; % p2の要素番号のカウント
for i = 1:totalSnap
    x_train{1,i} = xt_train{1,i};
    x_test{1,i} = xt_train{1,i};
end


for i = 1:totalSnap
    x_train{1,i} = x_train{1,i} + miss_train(:,i); % 欠損
    x_test{1,i} = x_test{1,i} + miss_test(:,i); % 欠損
    if i == p1(k1) % 訓練データ
        x_train{1,i} = xt_train{1,i}; % 正常値
        if k1 < numTrain
            k1 = k1 + 1; % 要素番号の更新
        end
    end
    if i == p2(k2) % テストデータ
        x_test{1,i} = xt_train{1,i}; % 正常値
        if k2 < numTest
            k2 = k2 + 1; % 要素番号の更新
        end
    end
end

%% データセット保存
% save('Dataset.mat','x_train','xt_train','x_test');

% 確認の描画
Target = cell2mat(xt_train);
Train = cell2mat(x_train);
Test = cell2mat(x_test);

figure()
hold on
plot(Target(1,1:26000),Target(2,1:26000))
plot(Target(1,26001:28000),Target(2,26001:28000))
grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

figure()
hold on
scatter(Train(1,1:26000),Train(2,1:26000),0.5)
scatter(Train(1,26001:28000),Train(2,26001:28000),0.5)
grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

figure()
hold on
scatter(Test(1,1:26000),Test(2,1:26000),0.5)
scatter(Test(1,26001:28000),Test(2,26001:28000),0.5)
grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off


