%% 円周率を求める
clear; close all; clc;
N = 1000;
idx = 1:N;
% 乱数生成
sigma = 2;
mu = -1;
x = sigma.*rand(N,1)+mu;
y = sigma.*rand(N,1)+mu;
% 円の内側の判別
% inside = find((x.^2+y.^2)<=1); % index
% outside = idx(~ismember(idx, inside))';
% estimated_area = length(inside)/N*4;

% 他のコード
inside = (x.^2 + y.^2) <= 1; % logical
outside = ~inside;
estimated_area = sum(inside)/N*4;

% 結果
fprintf('推定された円の面積: %.4f\n', estimated_area);
fprintf('理論的な円の面積: %.4f\n', pi);
t = 0:0.01:2*pi;
figure(1);
plot(x(inside), y(inside), '.', 'MarkerSize', 5, 'Color', '#f42a41'); hold on;
plot(x(outside), y(outside), '.', 'MarkerSize', 5, 'Color', '	#006a4e');
plot(cos(t), sin(t), '-','LineWidth', 2, 'Color', 'black'); hold off;
daspect([1 1 1]); xlim([-1.1, 1.1]); ylim([-1.1 1.1]);

%% 円周率　収束性の確認 1/root(N)の誤差を示したいね．ちょっとまだ足りない
clear; close all; clc;
sigma = 2;
mu = -1;
calc_N = 4;
calc_pi = zeros(1,calc_N); N_idx = [];
for i = 0:calc_N
    N = 100^i;
    idx = 1:N;
    N_idx = [N_idx, N];
    x = sigma.*rand(N,1)+mu;
    y = sigma.*rand(N,1)+mu;
    inside = find((x.^2+y.^2)<=1);
    outside = idx(~ismember(idx, inside))';
    calc_pi(1,i+1) = length(inside)/N*4;
    if rem(i+1, 1) == 0
        fprintf('i:%d, pi:%f\n', i+1, calc_pi(1,i+1));
    end
end
figure(2);
loglog(N_idx, abs(pi-calc_pi)); xlabel('Number of samples'); ylabel('Error');

%% 関数の最小値、最大値を求める
clear; close all;
a = 0;
b = pi;

% サンプル点数
num_samples = 1000;

% ランダムな点を生成（[a, b]の範囲で）
x = a + (b - a) * rand(1, num_samples);

% 関数値を計算（f(x) = sin(x)）
f_x = sin(x);

% 積分の近似値（平均値 * 区間の長さ）
integral_estimate = (b - a) * mean(f_x);

% 結果の表示
fprintf('推定された積分値: %.4f\n', integral_estimate);
fprintf('理論的な積分値: %.4f\n', 2);  % ∫sin(x) dx from 0 to pi = 2





