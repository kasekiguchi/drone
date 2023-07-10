close all hidden;
clear all;
clc;

load("experiment_6_20_circle_estimaterdata.mat")
disp('load finished')

% for i = find(log.Data.phase == 116,1,'first')+85:find(log.Data.phase == 108,1,'first')
%     data.t1(1,i-(find(log.Data.phase == 116,1,'first')+85)+1) = log.Data.t(i,1);         
%     data.p(:,i-(find(log.Data.phase == 116,1,'first')+85)+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
%     data.u2(:,i-(find(log.Data.phase == 116,1,'first')+85)+1) = log.Data.agent.input{i}(:,1);
% end

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p               
end

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 16; %凡例の大きさ調整

% figure(1)
% plot(data.p(1,:),data.p(2,:));
% grid on

% figure(2)
% plot3(data.p(1,:),data.p(2,:),data.p(3,:));
% grid on

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
colororder(newcolors)
plot(data.t,data.p(:,:),'LineWidth',1,'LineStyle','-');
Square_coloring(data.t([find(log.Data.phase == 108,1,'first'),find(log.Data.phase==108,1,'first')+15]),[1.0 0.9 1.0]);
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(log.Data.phase==102,1,'first') + 220]),[0.9 1.0 1.0]);
% Square_coloring(data.t([find(log.Data.phase==102,1,'first') + 220,find(log.Data.phase==108,1,'first')]));
xlabel('Time [s]');
ylabel('p');
xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
xline(data.t(1,find(log.Data.phase == 108,1,'first')+15),'LineStyle','--','Color','black','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'last')-5),'LineStyle','--','Color','black','LineWidth',2)
hold on
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

fontSize = 16; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 

% plot3(data.p(1,:),data.p(2,:),data.p(3,:));
% zlim([0 1.2])
% grid on
% xlabel('x');
% ylabel('y');
% zlabel('z');
% ax = gca;
% 
% fontSize = 14; %軸の文字の大きさの設定
% set(ax,'FontSize',fontSize);
