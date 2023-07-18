%% データストアの作成
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 元データ読み込み
load('state.mat');
%% 形式の変形
states = cell(1,length(state));
for i = 1:length(state)
    states{1,i} = state{1,i};
end
for i = 1:4
    states{1,end+1} = state{1,1+(i-1)*6};
end
states = states';
%% データセット格納
data = datastore('state.mat','Type',);















