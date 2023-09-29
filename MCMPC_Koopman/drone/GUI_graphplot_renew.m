%% GUIデータ用グラフプロット
opengl software
% パスの設定
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden;
% clear all;
clc;

%% データのインポート
% load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
% load("Koopman_ホバリング_x=1_y=1_重み調整よくない.mat")
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

%% 特定の範囲のグラフ出力

% for i = find(log.Data.phase == 102,1,'first'):find(log.Data.phase == 108,1,'first')
%     data.t(1,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.t(i,1);                                     
%     data.u1(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.input{i}(:,1);
% end
% 
% for i = find(log.Data.t > 18,1,'first'):find(log.Data.phase == 108,1,'first')
%     data.t1(1,i-find(log.Data.t > 18,1,'first')+1) = log.Data.t(i,1);         
%     data.p(:,i-find(log.Data.t > 18,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
%     data.u2(:,i-find(log.Data.t > 18,1,'first')+1) = log.Data.agent.input{i}(:,1);
% end

%% 各グラフで出力
num = input('出力するグラフ形態を選択してください (各グラフで出力 : 0 / いっぺんに出力 : 1)：','s'); %0:各グラフで出力,1:いっぺんに出力
selection = str2double(num); %文字列を数値に変換

if selection == 0
close all

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 16; %凡例の大きさ調整

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
colororder(newcolors)
plot(data.t,data.p(:,:),'LineWidth',1,'LineStyle','-');
xlabel('Time [s]');
ylabel('p');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',2) %特定の位置に縦線を引く
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','red','LineWidth',2)
hold on
grid on
plot(data.t,data.pr(:,:),'LineWidth',1,'LineStyle','--');
% lgdtmp = {'$x_r$','$y_r$','$z_r$'}; %リファレンスのみ凡例
% lgdtmp = {'$x_e$','$y_e$','$z_e$'};
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax = gca;
hold off
title('Position p of agent1','FontSize',12);

%姿勢角q
figure(2)
colororder(newcolors)
plot(data.t,data.q(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('q');
grid on
lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(2) = gca;
title('Attitude q of agent1','FontSize',12);

%速度v
figure(3)
colororder(newcolors)
plot(data.t,data.v(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('v');
grid on
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(3) = gca;
title('Velocity v of agent1','FontSize',12);

%角速度w
figure(4)
colororder(newcolors)
plot(data.t,data.w(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('w');
grid on
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(4) = gca;
title('Angular velocity w of agent1','FontSize',12);

figure(5)
plot(data.p(1,:),data.p(2,:));
xlabel('Position x [m]');
ylabel('Position y [m]');
grid on
hold on
plot(data.pr(1,:),data.pr(2,:));
plot(0,1,'o','MarkerFaceColor','red','Color','red');
% plot(1,-1,'o','MarkerFaceColor','red','Color','red');
legend('Estimated trajectory','Trajectory','Initial position')
ax(5) = gca;

figure(6)
plot3(data.p(1,:),data.p(2,:),data.p(3,:));
grid on
zlim([0 max(data.p(3,:))])
ax(6) = gca;

%入力
figure(7)
plot(data.t,data.u(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('u');
grid on
lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(7) = gca;
title('Input u of agent1','FontSize',12);

fontSize = 12; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 

else
%% いっぺんに出力
close all

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];
colororder(newcolors)
columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 12; %凡例の大きさ調整
size = figure;
size.WindowState = 'maximized'; %表示するグラフを最大化
num = 3;

subplot(2, num, 1);
p1 = plot(data.t, data.p(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
p2 = plot(data.t,data.pr(:,:),'LineWidth',1,'LineStyle','--');
xlim([data.t(1) data.t(end)])
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
ax = gca;
hold off
title('Position p of agent1');

% 姿勢角
subplot(2, num, 2);
p3 = plot(data.t, data.q(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('q');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(2) = gca;
title('Attitude q of agent1');

% 速度
subplot(2, num, 3);
p4 = plot(data.t, data.v(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('v');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(3) = gca;
title('Velocity v of agent1');

% 角速度
subplot(2, num, 4);
p5 = plot(data.t, data.w(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('w');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(4) = gca;
title('Angular velocity w of agent1');

% 入力
subplot(2,num,5);
plot(data.t,data.u(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('u');
grid on
lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(5) = gca;
title('Input u of agent1');

% 軌道(2次元，3次元)
choice = 0;
subplot(2,num,6);
if choice == 0
    plot(data.p(1,:),data.p(2,:));
    grid on
    xlabel('Position x [m]');
    ylabel('Position y [m]');
    hold on
%     plot(data.pr(1,:),data.pr(2,:));
%     plot(0,1,'o','MarkerFaceColor','red','Color','red');
%     plot(1,1,'o','MarkerFaceColor','red','Color','red');
%     plot(1,-1,'o','MarkerFaceColor','red','Color','red');
%     legend('Estimated trajectory','Target position')
%     xlim([-0.5 0.5])
%     ylim([-0.5 0.5])
else
    plot3(data.p(1,:),data.p(2,:),data.p(3,:));
    grid on
    xlabel('x');
    ylabel('y');
    zlabel('z');
end

fontSize = 16; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize);
% size = 'maximized';
% set(gcf,"Position",get(0,'Screensize')
end

%% グラフの背景に色あり

% %位置p
% box on %グラフの枠線が出ないときに使用
% figure(1)
% hold on
% colororder(newcolors)
% plot(data.t,data.p(:,:),'LineWidth',1,'LineStyle','-');
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(data.t > 18,1,'first')]),[1.0 0.9 1.0]); %グラフの背面を塗る
% Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]));
% xlabel('Time [s]');
% ylabel('p');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
% % hold on
% grid on
% % plot(data.t,data.pr(:,:),'LineWidth',1,'LineStyle','--');
% % lgdtmp = {'$x_r$','$y_r$','$z_r$'}; %リファレンスのみ凡例
% lgdtmp = {'$x_e$','$y_e$','$z_e$'};
% % lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
% lgd.NumColumns = columnomber;
% xlim([data.t(1) data.t(end)])
% ax = gca;
% hold off
% title('Position p of agent1','FontSize',12);
% 
% %姿勢角q
% figure(2)
% colororder(newcolors)
% plot(data.t,data.q(:,:),'LineWidth',1);
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(data.t > 18,1,'first')]),[1.0 0.9 1.0]);
% Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]));
% xlabel('Time [s]');
% ylabel('q');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
% grid on
% lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
% xlim([data.t(1) data.t(end)])
% ax(2) = gca;
% title('Attitude q of agent1','FontSize',12);
% 
% %速度v
% figure(3)
% colororder(newcolors)
% plot(data.t,data.v(:,:),'LineWidth',1);
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(data.t > 18,1,'first')]),[1.0 0.9 1.0]); 
% Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]));
% xlabel('Time [s]');
% ylabel('v');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
% grid on
% lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
% xlim([data.t(1) data.t(end)])
% ax(3) = gca;
% title('Velocity v of agent1','FontSize',12);
% 
% %角速度w
% figure(4)
% colororder(newcolors)
% plot(data.t,data.w(:,:),'LineWidth',1);
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(data.t > 18,1,'first')]),[1.0 0.9 1.0]); 
% Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]));
% xlabel('Time [s]');
% ylabel('w');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
% grid on
% lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
% xlim([data.t(1) data.t(end)])
% ax(4) = gca;
% title('Angular velocity w of agent1','FontSize',12);
% 
% figure(5)
% plot(data.p(1,:),data.p(2,:));
% grid on
% ax(5) = gca;
% 
% figure(6)
% plot3(data.p(1,:),data.p(2,:),data.p(3,:));
% grid on
% ax(6) = gca;
% 
% %入力
% figure(7)
% plot(data.t,data.u(:,:),'LineWidth',1);
% Square_coloring(data.t([find(log.Data.phase == 102,1,'first'),find(data.t > 18,1,'first')]),[1.0 0.9 1.0]); 
% Square_coloring(data.t([find(data.t > 18,1,'first'),find(log.Data.phase == 108,1,'first')]));
% xlabel('Time [s]');
% ylabel('u');
% xline(data.t(1,find(log.Data.phase == 102,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(data.t > 18,1,'first')),'LineStyle','--','Color','red','LineWidth',1)
% xline(data.t(1,find(log.Data.phase == 108,1,'first')),'LineStyle','--','Color','black','LineWidth',1)
% grid on
% lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
% lgd.NumColumns = columnomber;
% xlim([data.t(1) data.t(end)])
% ax(7) = gca;
% title('Input u of agent1','FontSize',12);
% 
% fontSize = 14; %軸の文字の大きさの設定
% set(ax,'FontSize',fontSize); 
