%% GUIデータ用グラフプロット
opengl software
% パスの設定
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden;
clear all;
clc;

%% データのインポート
% load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
load("Koopman_円旋回_radius=1_T=60_10_14_重み改良.mat")
disp('load finished')

for i = 1:find(logger.Data.t,1,'last')
    data.t(1,i) = logger.Data.t(i,1);                                      %時間t
    data.p(:,i) = logger.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
    data.pr(:,i) = logger.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
    data.q(:,i) = logger.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
    data.v(:,i) = logger.Data.agent.estimator.result{i}.state.v(:,1);      %速度
    data.w(:,i) = logger.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
    data.u(:,i) = logger.Data.agent.input{i}(:,1);                         %入力
end

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 16; %凡例の大きさ調整

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
% colororder(newcolors)
plot(data.t,data.p(1,:),'LineWidth',1,'LineStyle','-','Color',"red");
xlabel('Time [s]');
ylabel('p');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',2) %特定の位置に縦線を引く
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','red','LineWidth',2)
hold on
grid on
plot(data.t,data.pr(1,:),'LineWidth',1,'LineStyle','--','Color',"red");
plot(data.t,data.p(2,:),'LineWidth',1,'LineStyle','-','Color',[0.4660 0.6740 0.1880]);
plot(data.t,data.pr(2,:),'LineWidth',1,'LineStyle','--','Color',[0.4660 0.6740 0.1880]);
plot(data.t,data.p(3,:),'LineWidth',1,'LineStyle','-','Color',"blue");
plot(data.t,data.pr(3,:),'LineWidth',1,'LineStyle','--','Color',"blue");
% lgdtmp = {'$x_r$','$y_r$','$z_r$'}; %リファレンスのみ凡例
% lgdtmp = {'$x_e$','$y_e$','$z_e$'};
% lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgdtmp = {'$x_e$','$x_r$','$y_e$','$y_r$','$z_e$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ylim([-1.5 2])
ax = gca;
hold off
title('Position p of agent1','FontSize',12);

fontSize = 12; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 