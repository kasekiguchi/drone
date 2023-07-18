%% データセットの確認をするプログラム
% mainでデータセットを読み込んだ後に実行
% 学習データとテストデータで有効な要素数が正しいかカウントして確認
%%
clc;
%%
count_train = 0; % 学習の要素数
count_test = 0; % テストの要素数
l = length(x_train);
train = cell2mat(x_train);
test = cell2mat(x_test);
%%
for i = 1:l
    if x_train{1,i}(1,1) ~= 100
        count_train = count_train + 1;
    end
    if x_test{1,i}(1,1) ~= 10
        count_test = count_test + 1;
    end
end

count_train
count_test
