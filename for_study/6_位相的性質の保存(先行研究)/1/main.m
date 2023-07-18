%% 論文検証 main プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
%% 
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 定義
rng(0) % 乱数固定
numLayers_phi = 4;
unitSize_phi = 2;

numLayers_alpha = 3;
inputSize_alpha = unitSize_phi;
hiddenSize_alpha = 7;
outputSize_alpha = 1;
%% データセット読み込み
load('Dataset.mat');

%% ネットワーク構築
% 同相写像Φ
phi = feedforwardnet;
phi = network(1, ... % 入力の数(ユニット数ではなくブロック数(?)つまり1)
    numLayers_phi, ...
    [1;1;1;1], ... % バイアス
    [1;0;0;0], ... % 入力から繋がる層(普通に次の層)
    [0 0 0 0;1 0 0 0;0 1 0 0;0 0 1 0], ... % 層同士の結合(準伝播の全結合)
    [0 0 0 1]); % 出力が繋がる層(最後の中間層)
phi.inputs{1}.size = unitSize_phi;
phi.layers{1}.size = unitSize_phi;
phi.layers{2}.size = unitSize_phi;
phi.layers{3}.size = unitSize_phi;
phi.layers{4}.size = unitSize_phi;
phi.layers{1}.transferFcn = 'elliotsig';
phi.layers{2}.transferFcn = 'elliotsig';
phi.layers{3}.transferFcn = 'elliotsig';
phi.layers{4}.transferFcn = 'elliotsig';
phi.divideFcn = 'dividetrain';
phi.trainFcn = 'trainbr';
phi.trainParam.epochs = 10000;
net.trainParam.min_grad = 1.0e-10;
net.trainParam.mu_inc = 1;
[phi,tr_phi] = train(phi,x_train,xt_train);

xi = phi(x_test);
XI = cell2mat(xi);
figure(1)
plot(XI(1),XI(2))
%%
% スカラー関数α
% alpha = network(inputSize_alpha, ...
%     numLayers_alpha, ...
%     biasConnect, ...　% バイアス
%     inputConnect, ... % 入力から繋がる層(普通に次の層)
%     layerConnect, ... % 層同士の結合(準伝播の全結合)
%     outputConnect); % 出力が繋がる層(最後の中間層)


