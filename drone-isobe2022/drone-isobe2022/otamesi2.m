%%正規化
close all hidden;
clear all;
clc;
%% データのインポート
load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
% load("simulation_7_5_saddle.mat")
disp('load finished')

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
    data.q(:,i) = log.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
    data.v(:,i) = log.Data.agent.estimator.result{i}.state.v(:,1);      %速度
    data.w(:,i) = log.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
    data.u(:,i) = log.Data.agent.input{i}(:,1);                         %入力
end
%% 
for i = 1:3
    %平均値の算出
    meanValue.p(i,:) = mean(data.p(i,:));
    meanValue.q(i,:) = mean(data.q(i,:));
    meanValue.v(i,:) = mean(data.v(i,:));
    meanValue.w(i,:) = mean(data.w(i,:));
    %標準偏差の算出
    stdValue.p(i,:) = std(data.p(i,:));
    stdValue.q(i,:) = std(data.q(i,:));
    stdValue.v(i,:) = std(data.v(i,:));
    stdValue.w(i,:) = std(data.w(i,:));
end

sizeA = size(data.p,1);
sizeB = size(data.p,2);
meanValue.p = repmat(meanValue.p,1,sizeB);
meanValue.q = repmat(meanValue.q,1,sizeB);
meanValue.v = repmat(meanValue.v,1,sizeB);
meanValue.w = repmat(meanValue.w,1,sizeB);

%データの正規化
normalizedData.p = (data.p - meanValue.p);
normalizedData.q = (data.q - meanValue.q);
normalizedData.v = (data.v - meanValue.v);
normalizedData.w = (data.w - meanValue.w);
for i = 1:3
    normalizedData.p(i,:) = (1/stdValue.p(i))*normalizedData.p(i,:);
    normalizedData.q(i,:) = (1/stdValue.q(i))*normalizedData.p(i,:);
    normalizedData.v(i,:) = (1/stdValue.v(i))*normalizedData.p(i,:);
    normalizedData.w(i,:) = (1/stdValue.w(i))*normalizedData.p(i,:);
end

figure(1)
plot(data.t,normalizedData.p)
grid on

figure(2)
plot(data.t,normalizedData.q)
grid on

figure(3)
plot(data.t,normalizedData.v)
grid on

figure(4)
plot(data.t,normalizedData.w)
grid on
% disp(normalizedData);
