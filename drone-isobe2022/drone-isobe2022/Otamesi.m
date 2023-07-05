close all hidden;
clear all;
clc;

%% 特定の範囲のグラフ出力

%landingのインデックスから220だけ増加させることでだいたい円軌道に収束後となる
% load("experiment_6_20_circle_estimaterdata.mat")
load("simulation_7_5_saddle2.mat")
disp('load finished')

for i = find(log.Data.phase == 102,1,'first')+220:find(log.Data.phase == 108,1,'first')
    data.t(1,i-find(log.Data.phase == 102,1,'first')+1-220) = log.Data.t(i,1);                                     
    data.p1(:,i-find(log.Data.phase==102,1,'first')+1-220) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
end

for i = find(log.Data.phase == 102,1,'first'):find(log.Data.phase == 108,1,'first')
    data.t1(1,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.t(i,1);         
    data.p2(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
end

figure(1)
plot(data.p1(1,:),data.p1(2,:));
grid on

figure(2)
plot(data.p2(1,:),data.p2(2,:));
grid on

figure(3)
plot3(data.p1(1,:),data.p1(2,:),data.p1(3,:));
grid on

figure(4)
plot3(data.p2(1,:),data.p2(2,:),data.p2(3,:));
grid on