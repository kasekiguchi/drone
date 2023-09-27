clc
clear 
close all

% パラメータの設定
average = 0.5884*9.81/4; % 平均
% average = 0;
sigma = 0.01; % 標準偏差
H = 10;
particle_num = 100;
% num_samples = 1000; % 生成するデータの数

% 正規分布に従うランダムなデータの生成
% data = normrnd(average, sigma, 1, particle_num);
u2 = sigma * randn(4, H, particle_num) + average;
u1 = u2(1, 1, 1:particle_num);
u1 = reshape(u1, [1,particle_num]);
% ヒストグラムの表示
% histogram(u1, 'Normalization', 'probability');
% title('正規分布に従うランダムデータのヒストグラム');

% 理論的な正規分布の確率密度関数をプロット
% x = linspace(min(u1), max(u1),100);
x = u1;
y = normpdf(u1, average, sigma);
% y = u1;
% 
scatter(x,y)
hold on;
grid on;
% scatter(x,y)
% x1 = linspace(min(data),max(data),100);
x1 = linspace(min(u1),max(u1),1000);
y1 = normpdf(x1, average, sigma);
plot(x1, y1, 'r', 'LineWidth', 2);
legend('データ', '理論的な正規分布');
hold off;
