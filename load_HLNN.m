close all hidden; clear ; clc;

F = 0.5*[1.0 1.0, 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0];
ref = 0.1*ones([12,1]);

HLNN1 = importNetworkFromONNX("./Data/HLNN_model_tmp1.onnx");
HLNN1.Initialized
HLNN2 = importNetworkFromONNX("./Data/HLNN_model_tmp2.onnx");
HLNN2.Initialized
load("./Data/Ad_Bd.mat");

layer =inputLayer([12 1], "SC");
HLNN1 = addInputLayer(HLNN1,layer);
layer =inputLayer([25 1], "SC");
HLNN2 = addInputLayer(HLNN2,layer);

% dammy = random('Stable',2,0,1,0,[12,1]);
dammy = ones([12,1]);

xi = predict(HLNN1,dammy)' - ref;

v = F*xi;
xi_plus = Ad*xi - Bd*v;
x = [xi;xi_plus;v];

prob = predict(HLNN2,x)';