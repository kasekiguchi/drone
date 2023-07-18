%% 論文検証 main プログラム
% 「軌道の位相的性質を保証する非線形動的システム学習」
% 作成したものの中ではVer. 3だが乱雑になったため整理
%% 
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 開始宣言
date.start = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 開始\n',date.start);
%% 定義
rng(1) % 乱数固定
n = NDSL2; % クラス
figf = 1; % 図番号フラグ(描画される毎に更新(+1))
%% データセット読込
load('Dataset.mat');
%% 学習時間計測開始
tic
%% ξ
% 材料AE
ae1_xi = n.buildAE(n.inputSize_xi,n.hiddenSize_xi,x_train);
internal_xi = n.calculateHidden(ae1_xi,x_train);
ae2_xi = n.buildAE(n.hiddenSize_xi,n.outputSize_xi,internal_xi);
% ξ
net_xi = n.buildXi(ae1_xi,ae2_xi,x_train,xt_train);
feat_xi = net_xi(x_train);
%% α
% 材料AE
ae1_alpha = n.buildAE(n.inputSize_alpha,n.hiddenSize_alpha,feat_xi);
internal_alpha = n.calculateHidden(ae1_alpha,feat_xi);
ae2_alpha = n.buildAE(n.hiddenSize_alpha,n.outputSize_alpha,internal_alpha);
% α
net_alpha = n.buildAlpha(ae1_alpha,ae2_alpha,feat_xi,xt_train);
feat_alpha = net_alpha(feat_xi);








