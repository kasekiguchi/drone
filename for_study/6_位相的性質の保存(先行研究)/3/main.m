%% 論文検証 main プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
% カスタム学習ループ
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% データセット読み込み
load('Dataset.mat')
x = x_train;
x = cell2mat(x);
x_train = zeros(2,length(x));
for i = 1:length(x)
    x_train(1,i) = x(1,i);
    x_train(2,i) = x(2,i);
end
xt = xt_train;
xt = cell2mat(xt);
xt_train = zeros(2,length(xt));
noise = 0.01 * randn;
for i = 1:length(xt)
    xt_train(1,i) = noise + xt(1,i);
    xt_train(2,i) = noise + xt(2,i);
end
%%
x_train = dlarray(x_train,'CT');
xt_train = dlarray(xt_train,'CT');
%% 層の構成
lgraph_xi = layerGraph;
layers_xi = [
    sequenceInputLayer(2)
    fullyConnectedLayer(2,'Name','Hidden1')
    functionLayer(@(X) asinh(X),Name='asinh1')
    fullyConnectedLayer(2,'Name','Hidden2')
    functionLayer(@(X) asinh(X),Name='asinh2')
    fullyConnectedLayer(2,'Name','Hidden3')
    functionLayer(@(X) asinh(X),Name='asinh3')
    fullyConnectedLayer(2,'Name','Output')
    ];
lgraph_xi = addLayers(lgraph_xi,layers_xi);
% figure
% plot(lgraph_xi)

lgraph_alpha = layerGraph;
layers_alpha = [
    sequenceInputLayer(2)
    leakyReluLayer(0.01,'Name','Leaky ReLU')
    fullyConnectedLayer(7,'Name','Hidden')
    sigmoidLayer('Name','Sigmoid')
    fullyConnectedLayer(1,'Name','Output')
    ];
lgraph_alpha = addLayers(lgraph_alpha,layers_alpha);
% figure
% plot(lgraph_alpha)

net_xi = dlnetwork(layers_xi);
% plot(net_xi)
net_alpha = dlnetwork(layers_alpha);
% plot(net_alpha)
%% 学習オプション
numEpochs = 100; % 最大エポック
initialLearnRate = 0.01; % 初期学習率
decay = 0.01; % 減衰
momentum = 0.09; % モーメンタム
%% モニター
monitor = trainingProgressMonitor(Metrics="Loss",Info=["Epoch","LearnRate"],XLabel="Epoch");
%% モデルの学習
velocity = []; % パラメータ速度
epoch = 0; % エポック初期化
numIterations = numEpochs;
% 学習ループ
while epoch < numEpochs && ~monitor.Stop
    epoch = epoch + 1; % エポック更新
    iteration = epoch;
    [loss,gradients,state] = dlfeval(@modelLoss,net_xi,x_train,xt_train);
    net_xi.State = state;
    % 学習率更新
    learnRate = initialLearnRate/(1 + decay*iteration);
    [net_xi,velocity] = sgdmupdate(net_xi,gradients,velocity,learnRate,momentum);
    % [net_xi,velocity] = sgdmupdate(net_xi,gradients,velocity);

    recordMetrics(monitor,iteration,Loss=loss);
    updateInfo(monitor,Epoch=epoch,LearnRate=learnRate);
    % monitor.Progress = 100 * iteration/numIterations;
    monitor.Progress = 100 * epoch/numEpochs;
end
%% モデルのテスト
numOutputs = 2; % 出力次数?

output = modelPredictions(net_xi,x_train);











