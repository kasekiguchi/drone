%% 論文検証 main プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
% カスタム学習ループ
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%% データセット読み込み
load('Dataset.mat')
%% 層の構成
lgraph_phi = layerGraph;
layers_phi = [
    sequenceInputLayer(2)
    fullyConnectedLayer(2,'Name','Hidden1')
    functionLayer(@(X) asinh(X),Name='asinh1')
    fullyConnectedLayer(2,'Name','Hidden2')
    functionLayer(@(X) asinh(X),Name='asinh2')
    fullyConnectedLayer(2,'Name','Hidden3')
    functionLayer(@(X) asinh(X),Name='asinh3')
    ];
lgraph_phi = addLayers(lgraph_phi,layers_phi);
% figure
% plot(lgraph_phi)

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

phi = dlnetwork(layers_phi);
% plot(net_xi)
alpha = dlnetwork(layers_alpha);
% plot(net_alpha)
%% 学習オプション
numEpochs = 20; % 最大エポック
initialLearnRate1 = 0.01; % 初期学習率
initialLearnRate2 = 0.015;
decay1 = 0.1; % 減衰
decay2 = 0.11;
momentum1 = 0.4; % モーメンタム
momentum2 = 0.4;
%% モニター
monitor = trainingProgressMonitor(Metrics="Loss",Info=["Epoch","LearnRatePhi","LearnRateAlpha",'GradPhi','GradAlpha','Loss'],XLabel="Epoch");
%% モデルの学習
velocity1 = []; % パラメータ速度
velocity2 = []; % パラメータ速度
epoch = 0; % エポック初期化
numIterations = numEpochs;
% 学習ループ
while epoch < numEpochs && ~monitor.Stop
    epoch = epoch + 1; % エポック更新
    iteration = epoch;
    [loss,gradients_phi,gradients_alpha] = dlfeval(@modelLoss,phi,alpha,X,dX);

    % y_dX = dlfeval(@modelLoss2,phi,alpha,X);
    % [loss,gradients_phi,gradients_alpha] = dlfeval(@modelLoss3,phi,alpha,y_dX,dX,X);

    % 学習率更新
    learnRate1 = initialLearnRate1/(1 + decay1*iteration);
    learnRate2 = initialLearnRate2/(1 + decay2*iteration);
    % [net_xi,velocity] = sgdmupdate(net_xi,gradients,velocity,learnRate,momentum);
    [phi,velocity1] = sgdmupdate(phi,gradients_phi,velocity1,learnRate1,momentum1);
    [alpha,velocity2] = sgdmupdate(alpha,gradients_alpha,velocity2,learnRate2,momentum2);

    recordMetrics(monitor,iteration,Loss=loss);
    updateInfo(monitor,Epoch=epoch,LearnRatePhi=learnRate1,LearnRateAlpha=learnRate2,GradPhi=gradients_phi.Value{1,1}(1,1),GradAlpha=gradients_alpha.Value{1,1}(1,1),Loss=loss);
    % monitor.Progress = 100 * iteration/numIterations;
    monitor.Progress = 100 * epoch/numEpochs;
end
%% テスト
output = modelPredictions(phi,XTest);

