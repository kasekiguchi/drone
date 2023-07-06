close all hidden;
clear all;
clc;

load("experiment_6_20_circle_estimaterdata.mat")
disp('load finished')

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
    data.pr(:,i) = log.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
    data.q(:,i) = log.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
    data.v(:,i) = log.Data.agent.estimator.result{i}.state.v(:,1);      %速度
    data.w(:,i) = log.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
    data.u(:,i) = log.Data.agent.input{i}(:,1);                         %入力
end

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 16; %凡例の大きさ調整

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
hold on
colororder(newcolors)
plot(data.t,data.p(:,:),'LineWidth',1,'LineStyle','-');
Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]),[0.9 1.0 1.0]); %グラフの背面を塗る
xlabel('Time [s]');
ylabel('p');
xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','blue','LineWidth',2)
xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',2)
xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','red','LineWidth',2)
% hold on
grid on
% plot(data.t,data.pr(:,:),'LineWidth',1,'LineStyle','--');
% lgdtmp = {'$x_r$','$y_r$','$z_r$'}; %リファレンスのみ凡例
lgdtmp = {'$x_e$','$y_e$','$z_e$'};
% lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax = gca;
hold off
title('Position p of agent1','FontSize',12);

fontSize = 12; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 