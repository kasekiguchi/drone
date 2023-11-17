%% 提案手法 データ下処理
% 共通プログラム/mode/ML のデータをdataに移してから実行
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%% 定義
ts = 0;
dt = 0.01;
te = 5;
tspan = ts:dt:te-dt;
numStep = length(tspan);
% --------------
% numData = 100;
numData = 20;
% --------------
rootname = 'data';
extension = '.mat';
X = zeros(12,numStep*numData);
Xit = zeros(12,numStep*numData);
U = zeros(4,numStep*numData);
V = zeros(4,numStep*numData);
V1diff = zeros(4,numStep*numData);
%% データ下処理
cd data
for i = 1:numData
    n = num2str(i);
    filename = [rootname,n,extension];
    load(filename);
    for j = 1:numStep
        num = j + (i-1) * numStep;
        X(:,num) = x(:,j);
        Xit(:,num) = xi(:,j);
        U(:,num) = u(:,j);
        V(:,num) = v(:,j);
        V1diff(:,num) = v1diff(:,j);
    end
end
cd ..
%% 保存
cd output
save('dataset','X','Xit','U','V','V1diff')
cd ..










