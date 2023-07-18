%% 論文検証 データセット作成
% 「軌道の位相的性質を保証する非線形動的システム学習」
% 0.03刻み1000ステップ(時刻 0 - 29.97)
%% クリア
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
numTrain = 2400; % 学習データの要素数
numTest = 600; % テストデータの要素数
% 箱の用意
xt_all = cell(1,totalSnap); % 綺麗な全データ
x_train = cell(1,numTrain); % 学習データ
xt_train = cell(1,numTrain); % 教師データ
x_test = cell(1,numTest); % テストデータ
xt_test = cell(1,numTest); % テストデータ正解
%% 全データの格納
for i = 1:numTE % パターン数
    for j = 1:numStep % 1パターンあたりのスナップショット数
        if i <= length(state) % 半径2円周上の初期点
            xt_all{1,j+(i-1)*numStep}(1,1) = state{1,i}(j,1); % x1
            xt_all{1,j+(i-1)*numStep}(2,1) = state{1,i}(j,2); % x2
        else % 半径0.001円周上の初期点
            xt_all{1,j+(i-1)*numStep}(1,1) = state{2,1+(i-25)*6}(j,1); % x1
            xt_all{1,j+(i-1)*numStep}(2,1) = state{2,1+(i-25)*6}(j,2); % x2
        end
    end
end
%% 学習データとテストデータの要素抽出
p1 = sort(randperm(totalSnap,numTrain)); % 学習・教師
p2 = sort(randperm(totalSnap,numTest)); % テスト・正解
%% 学習データ・テストデータへの格納
% 各データはパターン数に対応
% pの値を参照し対応する要素番号の値を格納
k1 = 1; % p1の要素番号のカウント(初期化)
k2 = 1; % p2の要素番号のカウント(初期化)
for i = 1:totalSnap
    if k1 > numTrain
        break
    end
    if i == p1(k1)
        x_train{1,k1} = xt_all{1,i};
        xt_train{1,k1} = xt_all{1,i};
        k1 = k1 + 1;
    end
end
for i = 1:totalSnap
    if k2 > numTest
        break
    end
    if i == p2(k2)
        x_test{1,k2} = xt_all{1,i};
        xt_test{1,k2} = xt_all{1,i};
        k2 = k2 + 1;
    end
end
%% 描画
% 確認のため
All = cell2mat(xt_all); % 全データ
Train = cell2mat(x_train); % 学習データ
Test = cell2mat(x_test); % テストデータ

figure()
hold on
for i = 1:24
    s = 1 + (i-1) * 1000;
    e = i * 1000;
    plot(All(1,s:e),All(2,s:e),'b')
end
for i = 25:28
    s = 1 + (i-1) * 1000;
    e = i * 1000;
    plot(All(1,s:e),All(2,s:e),'b')
end
grid on
set(gca,'FontSize',12);
h1 = xlabel('$x_1$','fontsize',20);
h2 = ylabel('$x_2$','fontsize',20);
set(h1,'Interpreter','latex','fontsize',15)
set(h2,'Interpreter','latex','fontsize',15)
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

figure()
hold on
scatter(Train(1,:),Train(2,:),1.5)
grid on
set(gca,'FontSize',12);
h1 = xlabel('$x_1$','fontsize',20);
h2 = ylabel('$x_2$','fontsize',20);
set(h1,'Interpreter','latex','fontsize',15)
set(h2,'Interpreter','latex','fontsize',15)
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

figure()
hold on
scatter(Test(1,:),Test(2,:),1.5)
grid on
set(gca,'FontSize',12);
h1 = xlabel('$x_1$','fontsize',20);
h2 = ylabel('$x_2$','fontsize',20);
set(h1,'Interpreter','latex','fontsize',15)
set(h2,'Interpreter','latex','fontsize',15)
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off
%% データセット保存
% save('Dataset.mat','x_train','xt_train','x_test','xt_test','xt_all');










