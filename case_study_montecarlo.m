%% 円周率を求める
clear; close all;
N = 1000;
idx = 1:N;
sigma = 2;
mu = -1;
x = sigma.*rand(N,1)+mu;
y = sigma.*rand(N,1)+mu;
inside = find((x.^2+y.^2)<=1);
outside = idx(~ismember(idx, inside))';

% 結果
disp(length(inside)/N*4);
t = 0:0.01:2*pi;
figure(1);
plot(x(inside), y(inside), '.', 'MarkerSize', 5, 'Color', 'red'); hold on;
plot(x(outside), y(outside), '.', 'MarkerSize', 5, 'Color', 'blue');
plot(cos(t), sin(t), '-','LineWidth', 2, 'Color', 'black'); hold off;
daspect([1 1 1]);

%% 関数の最小値、最大値を求める
clear; close all;





