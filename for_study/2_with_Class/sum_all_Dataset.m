%% 全てのデータセットを統合
% 1つのnetに続けざまに学習させるのではなく，全てのパターンを1つのデータセットにまとめる．
%%
clear; close all; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% クラス呼び出し
nn = NNHL;
%% データセット読込
s04 = load('Dataset_04.mat');
s05 = load('Dataset_05.mat');
s06 = load('Dataset_06.mat');
s07 = load('Dataset_07.mat');
s08 = load('Dataset_08.mat');
s09 = load('Dataset_09.mat');
s10 = load('Dataset_10.mat');
%% データ統合
tmp1 = nn.sum_data(s04, s05);
tmp2 = nn.sum_data(tmp1,s06);
tmp3 = nn.sum_data(tmp2,s07);
tmp4 = nn.sum_data(tmp3,s08);
tmp5 = nn.sum_data(tmp4,s09);
tmp6 = nn.sum_data(tmp5,s10);
%% 小分け(tmp6で保存したくないから)
reference = tmp6.reference;
x_test = tmp6.x_test;
x_train = tmp6.x_train;
xt_train = tmp6.xt_train;
z_test = tmp6.z_test;
z_train = tmp6.z_train;
zt_train = tmp6.zt_train;
%%
save('Dataset_04_10_all.mat','reference',...
    'x_test','x_train','xt_train',...
    'z_test','z_train','zt_train')



