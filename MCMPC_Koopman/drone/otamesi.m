close all
clc
% % Step 1: データ生成
% average = 0.5884*9.81/4;   % 平均値
% sigma = 0.1;      % 標準偏差
% % num_samples = 1000; % データの数
% H = 10;
% particle = 1000;
% % for i = 1:particle
% %     for j = 1:H
% % 
% %     end
% % end
% 
% 
input = sigma * randn(1,1000)+average; % 正規分布に従うランダムなデータを生成
% 
% % Step 2: ランダムに生成された値をグラフに出力
% plot(input, 'o'); % ランダムなデータをプロット
% title('ランダムに生成された値のグラフ');
% xlabel('サンプル');
% ylabel('値');
% grid on; % グリッドを表示

% Step 1: データ生成
average = 0.5884*9.81/4;   % 平均値
sigma = 0.1;      % 標準偏差
num_samples = 1000; % データの数

data = average + sigma * randn(1, num_samples); % 正規分布に従うランダムなデータを生成

% Step 2: ヒストグラムとPDFの重ね合わせ
% histogram(data, 'Normalization', 'pdf'); % ヒストグラムを描画
% hold on; % プロットを重ねる

x = linspace(min(data), max(data), 1000); % x軸の範囲を設定
pdf = (1/(sigma*sqrt(2*pi))) * exp(-(x-mean_value).^2/(2*sigma^2)); % 正規分布の確率密度関数を計算
plot(x, pdf, 'r', 'LineWidth', 2); % プロットを赤色で描画
hold on; % プロットを重ねる
plot(input,pdf)
hold off; % プロットを終了

% グラフの装飾
title('ランダムに生成した値と正規分布の確率密度関数');
xlabel('値');
ylabel('確率密度');
legend('ランダムデータ', '正規分布', 'Location', 'Best');
grid on; % グリッドを表示

