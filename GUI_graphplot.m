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
load("1_24_sprine_7.mat") %読み込むデータファイルの設定
% load("9_4_test.mat")

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);      %推定値
    data.pr(:,i) = log.Data.agent.reference.result{i}.state.p(:,1);     %目標値
    data.q(:,i) = log.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
    data.v(:,i) = log.Data.agent.estimator.result{i}.state.v(:,1);      %速度
    data.w(:,i) = log.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
    data.u(:,i) = log.Data.agent.input{i}(:,1);                         %入力
    data.error(:,i) = data.pr(:,i) - data.p(:,i);                       %error
end

% for i = 1:size(data.u,2) %GUIの入力を各プロペラの推力に分解
%     data.u(:,i) = T2T(data.u(1,i),data.u(2,i),data.u(3,i),data.u(4,i));
% end

disp('load finished')
%% グラフ出力

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 16; %凡例の大きさ調整

% name = 'すぎやま'; %ファイル名
% folderName = '2023_1003_全体実験_すぎやま'; %フォルダ名
% mkdir(folderName) %新規フォルダ作成

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
colororder(newcolors)
plot(data.t,data.p(:,:),'LineWidth',2,'LineStyle','-');
xlabel('Time [s]');
ylabel('p');
hold on
grid on
plot(data.t,data.pr(:,:),'LineWidth',2,'LineStyle','--');
% lgdtmp = {'$x_r$','$y_r$','$z_r$'}; %リファレンスのみ凡例
% lgdtmp = {'$x_e$','$y_e$','$z_e$'};
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax = gca;
hold off
title('Position p of agent1','FontSize',12);
% cd(folderName)
% savefig(strcat('Position_',name));

%姿勢角q
figure(2)
colororder(newcolors)
plot(data.t,data.q(:,:),'LineWidth',2);
xlabel('Time [s]');
ylabel('q');
grid on
lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(2) = gca;
title('Attitude q of agent1','FontSize',12);
% savefig(strcat('Attitude_',name));

%速度v
figure(3)
colororder(newcolors)
plot(data.t,data.v(:,:),'LineWidth',2);
xlabel('Time [s]');
ylabel('v');
grid on
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(3) = gca;
title('Velocity v of agent1','FontSize',12);
% savefig(strcat('Velocity_',name));

%角速度w
figure(4)
colororder(newcolors)
plot(data.t,data.w(:,:),'LineWidth',2);
xlabel('Time [s]');
ylabel('w');
grid on
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
xlim([data.t(1) data.t(end)])
ax(4) = gca;
title('Angular velocity w of agent1','FontSize',12);
% savefig(strcat('Angular velocity_',name));

figure(5)
plot(data.p(1,:),data.p(2,:),'LineWidth', 2);
xlabel('Position x [m]');
ylabel('Position y [m]');
hold on
plot(data.pr(1,:), data.pr(2,:),'LineWidth',2)
grid on
hold off
lgdtmp = {'estimator', 'reference'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(5) = gca;
% savefig(strcat('x-y_',name))

%入力
figure(6)
plot(data.t,data.u(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('u');
grid on
lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(6) = gca;
title('Input u of agent1','FontSize',12);
% savefig(strcat('Input_',name))

% %error
figure(7)
plot(data.t,data.error(:,:),'LineWidth',1)
xlabel('Time [s]');
ylabel('Error');
grid on
lgdtmp = {'error.x','error.y','error.z'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(7) = gca;
title('Error of agent1','FontSize',12);
% savefig(strcat('Error_',name))

fontSize = 12; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 
