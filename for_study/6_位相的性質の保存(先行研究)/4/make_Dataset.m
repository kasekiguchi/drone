%% 論文検証 データセット作成
% 「軌道の位相的性質を保証する非線形動的システム学習」
% 0.03刻み1000ステップ(時刻 0 - 29.97)
% dlarray型で格納
% 状態 × 時間 × 種類(時間発展数)
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
%% 学習用・テスト用データ
traindata = [];
testdata = [];
p1 = sort(randperm(totalSnap,numTrain)); % 学習・教師インデックス
p2 = sort(randperm(totalSnap,numTest)); % テスト・正解インデックス
c1 = 1; % 要素数カウント(学習)
c2 = 1; % 要素数カウント(テスト)
for i = 1:numTrain % 学習
    idx = p1(i);
    % traindata() = ;
end
for i = 1:numTest % テスト
    idx = p2(i);
    % testdata() = ;
end
%% double型 → dlarray型
Xall = dlarray(s,'CBT');
X = dlarray(s,'CBT');
T = dlarray(s,'CBT');
XTest = dlarray(s,'CBT');
TTest = dlarray(s,'CBT');
%% 保存
save('Dataset.mat','Xall','X','T','XTest','TTest');





