%% 論文検証 main プログラム Ver. 2
% 「軌道の位相的性質を保証する非線形動的システム学習」
%% 
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 開始宣言
date.start = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 開始\n',date.start);
%% 定義
nn = NDSL; % クラス
rng(1) % 乱数固定
init_step = 30; % 取り出すステップ数
nn.t = 0:0.03:29.97; % シミュレーション時間
figf = 1;
% 第1ネットワーク(x→z)
nn.hiddenSize11 = 100; % 中間層1
% 第2ネットワーク(z→x)
nn.hiddenSize21 = 100; % 中間層1
%% データセット読込
load('Dataset.mat');
%% 学習時間計測開始
tic
%% AEの学習1
ae11 = nn.build_AE(nn.inputSize1,nn.hiddenSize11,x_train);
Xhidden11 = nn.calculate_Hidden(ae11,x_train);
ae12 = nn.build_AE(nn.hiddenSize11,nn.outputSize1,Xhidden11);
%% NN1(x→z)の学習
net1 = nn.build_3LNN(ae11,ae12,x_train,xt_train);
feat = net1(x_train);
%% AEの学習2
ae21 = nn.build_AE(nn.inputSize2,nn.hiddenSize21,feat);
Zhidden21 = nn.calculate_Hidden(ae21,feat);
ae22 = nn.build_AE(nn.hiddenSize21,nn.outputSize2,Zhidden21);
%% NN2(z→x)の学習
net2 = nn.build_3LNN(ae21,ae22,feat,xt_train);
fprintf('学習完了\n');
%% 学習時間計測終了
fprintf('学習する際の');
toc
%% 出力
output1 = net1(x_test);
output2 = net2(output1);
OUT = cell2mat(output2);

figure()
hold on
plot(OUT(1,:),OUT(2,:))
grid on
xlim([-2.5 2.5])
ylim([-2 2])
hold off