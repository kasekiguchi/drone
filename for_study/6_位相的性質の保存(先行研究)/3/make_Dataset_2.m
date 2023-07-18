%% 論文検証 データセット作成
% 「軌道の位相的性質を保証する非線形動的システム学習」
% 0.03刻み1000ステップ(時刻 0 - 29.97)
% dlarray型で格納
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
%% double型配列への格納
x = [];
for i = 1:numVar
    for j = 1:numStep
    end
end







