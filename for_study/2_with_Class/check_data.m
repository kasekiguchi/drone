%% データの形式をチェックするプログラム
%% 
close all; clear; clc;
%% データ読込
m = load('Dataset_04_10_all.mat');
s4 = load('Dataset_04.mat');
s5 = load('Dataset_05.mat');
s6 = load('Dataset_06.mat');
s7 = load('Dataset_07.mat');
s8 = load('Dataset_08.mat');
s9 = load('Dataset_09.mat');
s10 = load('Dataset_10.mat');
%% 配列毎に値が正確かの確認
errcount = 0; % エラーのカウント
for i = 1:2102100
    if i <= 300300
        if((m.x_train{1,i} ~= s4.x_train{1,i}))
            fprintf('x_train{1, %d}でエラー\n', i);
            errcount = errcount + 1; % エラーカウント数+1
        end
        if errcount == 5
            fprintf('エラー過多により終了\n');
        end
    end
end



