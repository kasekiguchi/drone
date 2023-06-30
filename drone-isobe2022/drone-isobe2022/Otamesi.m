opengl software
close all hidden;
clear all;
clc;

%% データのインポート
load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
% load("circle_6_26_sim_Log(26-Jun-2023_22_10_30).mat")
disp('load finished')

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);
end