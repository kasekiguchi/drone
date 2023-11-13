close all hidden;
clear all;
clc;

%% データのインポート
% load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
% load("experiment_9_5_saddle_estimatordata.mat")
% load("simulation_7_5_saddle.mat")
load("experiment_11_8_P2Pshape_estimator.mat")
disp('load finished')

for i = find(log.Data.phase==102,1,'first')+10:find(log.Data.phase==102,1,'first')+200
    data.t(1,i-(find(log.Data.phase==102,1,'first')+10)+1) = log.Data.t(i,1);                                      %時間t
    data.p(:,i-(find(log.Data.phase==102,1,'first')+10)+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p               %入力
end

figure(1)
plot3(data.p(1,:),data.p(2,:),data.p(3,:));
zlim([0 max(data.p(3,:))])
grid on

figure(2)
plot(data.p(1,:),data.p(2,:))
grid on