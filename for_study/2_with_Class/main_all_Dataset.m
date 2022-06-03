%% mainプログラム
% 種々の訓練データをまとめたデータセットで1回で一気に学習
% 関数はクラスから呼び出し
%%
clear; close all; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 開始宣言
date.start = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 開始\n',date.start);
%% クラス呼び出し
nn = NNHL;
%% 普遍的な変数の定義
rng(1) % 乱数固定
nn.t = 0:0.01:10; % シミュレーション時間
figf = 1;
% 第1ネットワーク(x→z)
% inputSize1 = 32; % 入力層ユニット数
nn.hiddenSize11 = 100; % 中間層1
% outputSize1 = 12; % 出力層ユニット数
% 第2ネットワーク(z→x)
% inputSize2 = 32; % 入力層ユニット数
nn.hiddenSize21 = 100; % 中間層1
% hiddenSize22 = 50; % 中間層2
% hiddenSize23 = 24; % 中間層3
% hiddenSize24 = 12;
% outputSize2 = 12;
% extension = '.mat';
%% データセット読込
load('Dataset_04_10_all.mat');
%% 学習時間計測開始
tic
%% AEの学習1-1
ae11 = nn.build_AE(nn.inputSize1,nn.hiddenSize11,x_train);
Xhidden11 = nn.calculate_Hidden(ae11,x_train);
ae12 = nn.build_AE(nn.hiddenSize11,nn.outputSize1,Xhidden11);
%% NN1(x→z)の学習
net1 = nn.build_3LNN(ae11,ae12,x_train,zt_train);
%% AEの学習2
ae21 = nn.build_AE(nn.inputSize2,nn.hiddenSize21,z_train);
Zhidden21 = nn.calculate_Hidden(ae21,z_train);
ae22 = nn.build_AE(nn.hiddenSize21,nn.outputSize2,Zhidden21);
%% NN2(z→x)の学習
net2 = nn.build_3LNN(ae21,ae22,z_train,xt_train);
fprintf('学習完了\n');
%% 微調整(2022/05/20~) あまり良い結果は得られず
% 本学習と同じ形式で学習
% net1 = train(net1,x_train,zt_train);
% net2 = train(net2,z_train,xt_train);
% fprintf('微調整完了\n');
%% 微調整(2022/05/27~) NEW
% 立ち上がり部分のみ(0 s ~ 3 s)を取り出して学習
z_train_init = {};
xt_train_init = {};
for i = 1:7 % 飛行周期
    for j = 1:300
        for k = 1:300
            for l = 1:32
                z_train_init{1,}(,1) = z_train{1,}(,1);
                xt_train_init{1,}(,1) = xt_train{1,}(,1);
            end
        end
    end
end
fprintf('微調整完了\n');
%% 学習時間計測終了
fprintf('学習する際の');
toc
%% 出力1(訓練に含まれる場合)
load('Dataset_08.mat');
tic % 出力時間計測開始
output1 = net1(x_test);
fprintf('出力(適用)する際の');
toc % 出力(適用)時間計測終了
output2 = net2(z_test);
z_test_tmp1 = nn.total_data(output1, reference);
output3 = net2(z_test_tmp1);

date.FinishOut1 = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 出力1が完了\n',date.FinishOut1);

for i = 1:7
    result1.state{1,i} = zeros(length(nn.t),length(xt_train{1,1}));
end
result1.xz_in_x = 1;
result1.xz_t = 2;
result1.xz_out_z = 3;
result1.zx_in_z = 4;
result1.zx_t = 5;
result1.zx_out_x = 6;
result1.xzx_out_x = 7;

for i = 1:length(nn.t)
    for j = 1:length(zt_train{1,1})
        result1.state{1,1}(i,j) = x_test{1,i}(j,1); % 入力x(x→z)
        result1.state{1,2}(i,j) = zt_train{1,i}(j,1); % 教師zt(x→z)
        result1.state{1,3}(i,j) = output1{1,i}(j,1); % 出力z(x→z)
        result1.state{1,4}(i,j) = z_test{1,i}(j,1); % 入力z(z→x)
        result1.state{1,5}(i,j) = xt_train{1,i}(j,1); % 教師xt(z→x)
        result1.state{1,6}(i,j) = output2{1,i}(j,1); % 出力x(z→x)
        result1.state{1,7}(i,j) = output3{1,i}(j,1); % 出力x(x→z→x)
    end
end

result1.xz_error = immse(result1.state{1,3},result1.state{1,2});
result1.zx_error = immse(result1.state{1,6},result1.state{1,5});
result1.xzx_error = immse(result1.state{1,7},result1.state{1,5});
%% 出力2(訓練に含まれない場合)
load('Dataset_085.mat');
output4 = net1(x_test);
output5 = net2(z_test);
z_test_tmp2 = nn.total_data(output4, reference);
output6 = net2(z_test_tmp2);

date.FinishOut2 = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 出力2が完了\n',date.FinishOut2);

for i = 1:7
    result2.state{1,i} = zeros(length(nn.t),length(xt_train{1,1}));
end
result2.xz_in_x = 1;
result2.xz_t = 2;
result2.xz_out_z = 3;
result2.zx_in_z = 4;
result2.zx_t = 5;
result2.zx_out_x = 6;
result2.xzx_out_x = 7;

for i = 1:length(nn.t)
    for j = 1:length(zt_train{1,1})
        result2.state{1,1}(i,j) = x_test{1,i}(j,1); % 入力x(x→z)
        result2.state{1,2}(i,j) = zt_train{1,i}(j,1); % 教師zt(x→z)
        result2.state{1,3}(i,j) = output4{1,i}(j,1); % 出力z(x→z)
        result2.state{1,4}(i,j) = z_test{1,i}(j,1); % 入力z(z→x)
        result2.state{1,5}(i,j) = xt_train{1,i}(j,1); % 教師xt(z→x)
        result2.state{1,6}(i,j) = output5{1,i}(j,1); % 出力x(z→x)
        result2.state{1,7}(i,j) = output6{1,i}(j,1); % 出力x(x→z→x)
    end
end

result2.xz_error = immse(result2.state{1,3},result2.state{1,2});
result2.zx_error = immse(result2.state{1,6},result2.state{1,5});
result2.xzx_error = immse(result2.state{1,7},result2.state{1,5});
fprintf('MSE x→z：%f\n',result2.xz_error);
fprintf('MSE z→x：%f\n',result2.zx_error);
fprintf('MSE x→z→x：%f\n',result2.xzx_error);
%% 結果の描画
figf = nn.plot_Result(result1,figf);
figf = nn.plot_Result(result2,figf);
%% 結果データ保存
others = 'Result_';
d = char(datetime('now','TimeZone','local','Format','yMMd'));
% extension = '.mat';
filename_save = [others,d,nn.extension];
save(filename_save,'result1','result2','date');
date.save = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 結果保存完了\n',date.save);
%% 終了宣言
date.end = char(datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss'));
fprintf('%s 終了\n',date.end);


