%% データをチェックするプログラム
% データの形式・値が正しいか判別
% 必ずセクションごとに実行すること
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
%% 初期時刻付近の応答を入れたデータの確認
clc;
errcount = 0; % エラーのカウント
for i = 1:630000
    if i <= 300
        if((z_train_init{1,i} ~= s4.z_train{1,i}))
            fprintf('z_train_init{1, %d}でエラー\n', i);
            errcount = errcount + 1; % エラーカウント数+1
        elseif((xt_train_init{1,i} ~= s4.xt_train{1,i}))
            fprintf('xt_train_init{1, %d}でエラー\n', i);
            errcount = errcount + 1; % エラーカウント数+1
        end
        if errcount == 5
            fprintf('エラー過多により終了\n');
            break
        end
    elseif i >= 90001 && i <= 90300
        if((z_train_init{1,i} ~= s5.z_train{1,i-90000}))
            fprintf('z_train_init{1, %d}でエラー\n', i);
            errcount = errcount + 1; % エラーカウント数+1
        elseif((xt_train_init{1,i} ~= s5.xt_train{1,i-90000}))
            fprintf('xt_train_init{1, %d}でエラー\n', i);
            errcount = errcount + 1; % エラーカウント数+1
        end
        if errcount == 5
            fprintf('エラー過多により終了\n');
            break
        end
    end
end
if errcount == 0
    fprintf('正常に終了(エラーなし)\n');
else
    fprintf('エラー発生：%d 個\n発生個所はメッセージ参照\n', errcount);
end
