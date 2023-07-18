%% 論文検証 main プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
% カスタム学習ループ
% ミニバッチを入れる
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
noise = 0.01;
for i = 1:length(xt)
    xt_train(1,i) = noise * xt(1,i);
    xt_train(2,i) = noise * xt(2,i);
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
numEpochs = 10; % 最大エポック
miniBatchSize = 100; % ミニバッチサイズ
initialLearnRate = 0.01; % 初期学習率
decay = 0.01; % 減衰
momentum = 0.9; % モーメンタム
%% モニター
monitor = trainingProgressMonitor(Metrics="Loss",Info=["Epoch","LearnRate"],XLabel="Iteration");
%% モデルの学習
mbq = minibatchqueue(x_train,...
    MiniBatchSize=miniBatchSize,...
    MiniBatchFcn=@preprocessMiniBatch,...
    MiniBatchFormat=["CT" ""]);

velocity = [];

numObservationsTrain = numel(x_train);
numIterationsPerEpoch = ceil(numObservationsTrain / miniBatchSize);
numIterations = numEpochs * numIterationsPerEpoch;

monitor = trainingProgressMonitor(Metrics="Loss",Info=["Epoch","LearnRate"],XLabel="Iteration");

epoch = 0;
iteration = 0;

% Loop over epochs.
while epoch < numEpochs && ~monitor.Stop
    
    epoch = epoch + 1;

    % Shuffle data.
    shuffle(mbq);
    
    % Loop over mini-batches.
    while hasdata(mbq) && ~monitor.Stop

        iteration = iteration + 1;
        
        % Read mini-batch of data.
        [X,T] = next(mbq);
        
        % Evaluate the model gradients, state, and loss using dlfeval and the
        % modelLoss function and update the network state.
        [loss,gradients,state] = dlfeval(@modelLoss,net,x_train,xt_trian);
        net.State = state;
        
        % Determine learning rate for time-based decay learning rate schedule.
        learnRate = initialLearnRate/(1 + decay*iteration);
        
        % Update the network parameters using the SGDM optimizer.
        [net,velocity] = sgdmupdate(net,gradients,velocity,learnRate,momentum);
        
        % Update the training progress monitor.
        recordMetrics(monitor,iteration,Loss=loss);
        updateInfo(monitor,Epoch=epoch,LearnRate=learnRate);
        monitor.Progress = 100 * iteration/numIterations;
    end
end
%% モデルのテスト
% numOutputs = 1;
% 
% mbqTest = minibatchqueue(augimdsValidation,numOutputs, ...
%     MiniBatchSize=miniBatchSize, ...
%     MiniBatchFcn=@preprocessMiniBatchPredictors, ...
%     MiniBatchFormat="SSCB");
% 
% YTest = modelPredictions(net,mbqTest,classes);
% 
% TTest = imdsValidation.Labels;
% accuracy = mean(TTest == YTest)
% 
% figure
% confusionchart(TTest,YTest)






