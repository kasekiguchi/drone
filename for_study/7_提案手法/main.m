%% 提案手法 main
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%% データセット読み込み・下処理
cd makeData\output
load dataset.mat
cd ..\..
X = dlarray(X,'CT');
U = dlarray(U,'CT');
Xit = dlarray(Xit,'CT');
V = dlarray(V,'CT');
V1diff = dlarray(V1diff,'CT');
%% 下処理
% これはmodelLoss内に入れたほうがよさそう
% XU = [X;U];
% ZV = [Z;V];
%% 層
% x -> z
lgraph_rhod = layerGraph;
layers_rhod = [
    sequenceInputLayer(14,'Name','input')
    reluLayer
    fullyConnectedLayer(12,'Name','Hidden')
    reluLayer
    ];
lgraph_rhod = addLayers(lgraph_rhod,layers_rhod);
% plot(lgraph_rhod)
rhod = dlnetwork(lgraph_rhod);
rhod = initialize(rhod);

% z -> x
lgraph_rho = layerGraph;
layers_rho = [
    sequenceInputLayer(18,'Name','input') % 10に減っている
    reluLayer
    fullyConnectedLayer(16,'Name','Hidden')
    reluLayer
    ];
lgraph_rho = addLayers(lgraph_rho,layers_rho);
% plot(lgraph_rho)
rho = dlnetwork(lgraph_rho);
rho = initialize(rho);
%% 線形化後の行列A, B
Axy = [0 1 0 0;0 0 1 0;0 0 0 1;0 0 0 0];
Bxy = [0;0;0;1];
% Ay = Ax;
% By = Bx;

Az = [0 1;0 0];
Bz = [0;1];
%% 学習オプション
numEpochs = 100;
initialLearnRate1 = 0.00001;
initialLearnRate2 = 0.00001;
decay1 = 0.001;
decay2 = 0.001;
momentum1 = 0.01;
momentum2 = 0.01;
%% モニター
monitor = trainingProgressMonitor( ...
    Metrics=["Loss1",'Loss2'], ...
    Info=["Epoch","LearnRateRhoD","LearnRateRho",'Loss1','Loss2'], ...
    XLabel="Epoch");
%% モデルの学習
velocity1 = []; % パラメータ速度
velocity2 = [];
epoch = 0; % エポック初期化
numIterations = numEpochs;
LossAll1 = zeros(1,numEpochs); % loss記録
LossAll2 = zeros(1,numEpochs);
while epoch < numEpochs && ~monitor.Stop
    epoch = epoch + 1; % エポック更新
    iteration = epoch;
    % [loss1,loss2,gradients_rhod,gradients_rho] = dlfeval(@modelLoss,rhod,rho,X,U,Xit,V,V1diff,Ax,Bx,Ay,By,Az,Bz);
    [loss1,loss2,gradients_rhod,gradients_rho] = dlfeval(@modelLoss2,rhod,rho,X,U,Xit,V,V1diff,Axy,Bxy,Az,Bz);
    LossAll1(1,epoch) = loss1;
    LossAll2(1,epoch) = loss2;

    % 学習率更新
    learnRate1 = initialLearnRate1/(1 + decay1*iteration);
    learnRate2 = initialLearnRate2/(1 + decay2*iteration);
    [rhod,velocity1] = sgdmupdate(rhod,gradients_rhod,velocity1,learnRate1,momentum1);
    [rho,velocity2] = sgdmupdate(rho,gradients_rho,velocity2,learnRate2,momentum2);

    recordMetrics(monitor,iteration,Loss1=loss1,Loss2=loss2);
    % updateInfo(monitor,Epoch=epoch,LearnRateRhoD=learnRate1,LearnRateRho=learnRate2,GradRhoD=gradients_rhod.Value{1,1}(1,1),GradRho=gradients_rho.Value{1,1}(1,1),Loss=loss);
    updateInfo(monitor,Epoch=epoch,LearnRateRhoD=learnRate1,LearnRateRho=learnRate2,Loss1=loss1,Loss2=loss2);
    monitor.Progress = 100 * epoch/numEpochs;
end
%% loss描画
e = 1:numEpochs;
figure()
semilogy(e,LossAll1,'LineWidth',1.5)
grid on

figure()
semilogy(e,LossAll2,'LineWidth',1.5)
grid on




