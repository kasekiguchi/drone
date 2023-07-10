close all hidden;
clear all;
clc;

% サンプルデータの生成
x = 1:10;
y = x.^2;
% z = x.' * y;
% グラフのプロット
% surf(x, y);
plot(x,y);
xlabel('X軸');
ylabel('Y軸');
% zlabel('Z軸');
% アスペクト比を設定
daspect([1, 1, 1]); % 各軸のスケールを等しくする