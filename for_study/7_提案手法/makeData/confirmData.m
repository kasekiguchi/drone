%% データ確認
% 任意のデータを確認した後に実行
%% クリア
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%% 定義
tspan = 0:0.01:4.99;
%% 描画
figure()
plot(tspan,x,'LineWidth',1.5)
grid on

figure()
plot(tspan,z,'LineWidth',1.5)
grid on
