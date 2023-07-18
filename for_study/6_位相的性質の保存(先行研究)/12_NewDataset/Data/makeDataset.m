%% 論文検証 データセット 作成
% 「軌道の位相的性質を保証する非線形動的システム学習」
% カスタム学習ループ
% 0.03刻み1000ステップ(時刻 0 - 29.97)
% dlarray型で格納
% 状態 × 時間 × 種類(時間発展数)
% x,dx
% 欠損は最後にまとめるのではなくその位置に混ぜる
% 欠損値は極小さい乱数生成の非零ノイズ
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%% 元データ読み込み
load('state.mat'); % xのみ
%% 定義
numStep = length(state{1,1}); % ステップ数
numX = min(size(state{1,1})); % 状態数x1,x2
numVar = 0; % 時間発展の数(初期化)
for i = 1:min(size(state)) % 時間発展のパターン数を算出
    for j = 1:length(state)
        if isempty(state{i,j}) == 0
            numVar = numVar + 1;
        end
    end
end
numTrain = 2400; % 学習用サンプル数
numTest = 600; % テスト用サンプル数
totalSnap = numVar * numStep; % スナップショット総数
%% 元データ下処理
% cell型 → double型3次元
% 変数s：2(状態)*1000(ステップ)*28(初期点) double型
s = zeros(numX,numStep,numVar);
for i = 1:numVar
    if i <= 24
        for j = 1:numStep
            for k = 1:2
                s(k,j,i) = state{1,i}(j,k);
            end
        end
    else
        for j = 1:numStep
            for k = 1:2
                s(k,j,i) = state{2,1+(i-25)*6}(j,k);
            end
        end
    end
end
%% 学習・テストデータで参照するインデックス
p1 = sort(randperm(totalSnap,numTrain)); % 学習・教師インデックス
p2 = sort(randperm(totalSnap,numTest)); % テスト・正解インデックス
% 種類*インデックスへ調整
pm1 = []; % 学習用インデックス(調整後)
pm2 = []; % テスト用インデックス(調整後)
row1 = 1; % 行数(学習)
row2 = 1; % 行数(テスト)
id1 = 1; % 格納先の列数(学習)
id2 = 1; % 格納先の列数(テスト)
% 学習
for i = 1:numel(p1) % 1 - 2400
    if p1(i) > row1*numStep
        row1 = row1 + 1;
        id1 = 1; % インデックス初期化
    end
    pm1(row1,id1) = p1(i);
    id1 = id1 + 1;
end
% テスト
for i = 1:numel(p2) % 1 - 600
    if p2(i) > row2*numStep
        row2 = row2 + 1;
        id2 = 1; % インデックス初期化
    end
    pm2(row2,id2) = p2(i);
    id2 = id2 + 1;
end
% 要素番号を各行1から始めるよう調整
for i = 1:numVar
    for j = 1:length(pm1)
        if pm1(i,j) ~= 0
            pm1(i,j) = pm1(i,j) - (i-1) * numStep;
        end
    end
end
for i = 1:numVar
    for j = 1:length(pm2)
        if pm2(i,j) ~= 0
            pm2(i,j) = pm2(i,j) - (i-1) * numStep;
        end
    end
end
%% 参照配列の作成
% サンプル抽出する要素には1，欠損には0を格納
idx1 = zeros(numVar,numStep);
idx2 = zeros(numVar,numStep);
% 学習
for i = 1:numVar
    for j = 1:length(pm1)
        if pm1(i,j) ~= 0
            idx1(i,pm1(i,j)) = 1;
        end
    end
end
% テスト
for i = 1:numVar
    for j = 1:length(pm2)
        if pm2(i,j) ~= 0
            idx2(i,pm2(i,j)) = 1;
        end
    end
end
%% 学習・テストデータへの格納(x)
X = zeros(numX,numStep,numVar);
XTest = zeros(numX,numStep,numVar);
% 学習
for i = 1:numVar
    for j = 1:numStep
        if idx1(i,j) == 1
            for k = 1:numX
                X(k,j,i) = s(k,j,i);
            end
        else
            miss = abs(wgn(2,1,0)) * 10^-6;
            for k = 1:numX
                X(k,j,i) = miss(k,1);
            end
        end
    end
end
% テスト
for i = 1:numVar
    for j = 1:numStep
        if idx2(i,j) == 1
            for k = 1:numX
                XTest(k,j,i) = s(k,j,i);
            end
        else
            miss = abs(wgn(2,1,0)) * 10^-6;
            for k = 1:numX
                XTest(k,j,i) = miss(k,1);
            end
        end
    end
end
%% 微分方程式
syms x1 x2
x = [x1;x2];
v1 = x2 + sin(x1) - 3*(x1^3);
v2 = -x1;
ode = exp(-norm(x)^2)*[v1;v2];
xdot = matlabFunction(ode);
%% dxの格納
dXall = zeros(numX,numStep,numVar);
dX = zeros(numX,numStep,numVar);
dXTest = zeros(numX,numStep,numVar);
% 全データ
for i = 1:numVar
    for j = 1:numStep
        a1 = s(1,j,i);
        a2 = s(2,j,i);
        dXall(:,j,i) = xdot(a1,a2);
    end
end
% 学習
for i = 1:numVar
    for j = 1:numStep
        if idx1(i,j) == 1
            for k = 1:numX
                dX(k,j,i) = dXall(k,j,i);
            end
        else
            miss = abs(wgn(2,1,0)) * 10^-6;
            for k = 1:numX
                dX(k,j,i) = miss(k,1);
            end
        end
    end
end
% テスト
for i = 1:numVar
    for j = 1:numStep
        if idx2(i,j) == 1
            for k = 1:numX
                dXTest(k,j,i) = dXall(k,j,i);
            end
        else
            miss = abs(wgn(2,1,0)) * 10^-6;
            for k = 1:numX
                dXTest(k,j,i) = miss(k,1);
            end
        end
    end
end
%% dlarray型へ変換
X = dlarray(X,'CBT');
dX = dlarray(dX,'CBT');
XTest = dlarray(XTest,'CBT');
dXTest = dlarray(dXTest,'CBT');
Xall = dlarray(s,'CBT');
dXall = dlarray(s,'CBT');
%% 保存
cd ..
save('Dataset.mat','X','dX','XTest','dXTest','Xall','dXall');
cd('Data')


