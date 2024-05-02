%% plotResultの各グラフをそれぞれに分割して表示
%例）位置のグラフなら，x,y,zそれぞれを別のグラフとして出力
clear all
close all
clc
%% flag
flg.calcFile1RMSE = 1; % file{1}に読み込んだデータのRMSEを求める
flg.ylimHold = 0; % 指定した値にylimを固定
flg.xlimHold = 1; % 指定した値にxlimを固定

%pdf保存するときの名前-----------------------
 name = '';
 folderName = '';
%------------------------------------------

%% select file to load (max number of file:5)

loadfilename{1} = 'EstimationResult_2024-05-02_Exp_Kiyama_code00_1.mat' ;%mainで書き込んだファイルの名前に逐次変更する
% loadfilename{2} = '.mat';
% loadfilename{3} = '.mat';
% loadfilename{4} = '.mat';

WhichRef = 1; % どのファイルをリファレンスに使うか

%% plot range
%何ステップまで表示するか
%ステップ数とxlinHoldの幅を変えればグラフの長さを変えられる
% stepN %検証用シミュレーションのステップ数がどれだけあるかを確認,これを変えると出力時間が伸びる

stepnum = 1; %ステップ数，xの範囲を設定
if stepnum == 0
    stepN = 31;
    if flg.xlimHold == 1
        xlimHold = [0,0.5];
    end
elseif stepnum == 1
    stepN = 55;
    if flg.xlimHold == 1
        xlimHold = [0,0.8];
    end
elseif stepnum == 2
    stepN = 91;
    if flg.xlimHold == 1
        xlimHold = [0,1.5];
    end
elseif stepnum == 3
    stepN = 126;
    if flg.xlimHold == 1
        xlimHold = [0,2];
    end
else
    stepN = 261;
    if flg.xlimHold == 1
        xlimHold = [0,4];
    end
end

% flg.ylimHoldがtrueのときのplot y範囲
if flg.ylimHold == 1
    ylimHold.p = [-1.5, 1.5];
    ylimHold.q = [-0.2, 0.8];
    ylimHold.v = [-3, 4];
    ylimHold.w = [-1.5, 2];
end

%% Font size(凡例や軸ラベルの大きさの設定)
Fsize.label = 18;
Fsize.lgd = 20;
Fsize.luler = 18;

%% load 凡例などの設定
HowmanyFile = size(loadfilename,2);
for i = 1:HowmanyFile
    file{i} = load(loadfilename{i});
    file{i}.name = loadfilename{i};
    % file{i}.markerSty = ':o';
    file{i}.markerSty = '';
    file{i}.lgdname.p = {append('$data',num2str(i),'_x$'),append('$data',num2str(i),'_y$'),append('$data',num2str(i),'_z$')};
    file{i}.lgdname.q = {append('$data',num2str(i),'_{roll}$'),append('$data',num2str(i),'_{pitch}$'),append('$data',num2str(i),'_{yaw}$')};
    file{i}.lgdname.v = {append('$data',num2str(i),'_{vx}$'),append('$data',num2str(i),'_{vy}$'),append('$data',num2str(i),'_{vz}$')};
    file{i}.lgdname.w = {append('$data',num2str(i),'_{w1}$'),append('$data',num2str(i),'_{w2}$'),append('$data',num2str(i),'_{w3}$')};
    
    if isfield(file{i}.simResult,'initTindex')
    
    else
        file{i}.simResult.initTindex = 1;
    end

    if i == 1
        indexcheck = file{i}.simResult.initTindex;
    elseif indexcheck ~= file{i}.simResult.initTindex
            disp('Caution!! 読み込んだファイルの初期状態が異なっています!!')
            dammy = input('Enterで無視して続行します');
    end
end

%%
% columnomber = size(file,2)+1;
columnomber = 3; %凡例のサイズを変更

dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
tlength = file{1}.simResult.initTindex:file{1}.simResult.initTindex+stepN-1;

%% P
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];

for graph_num = 1:3 %1 = x,2 = y,3 = z
    figure(graph_num)
    colororder(newcolors)
    plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.p(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    for i = 1:HowmanyFile
        if graph_num == 1
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$x_{d}$','$\hat{x}_{case1}$','$\hat{x}_{\rm case2}$','$\hat{x}_{\rm case3}$','$\hat{x}_{\rm case4}$','$\hat{x}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Position x [m]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$y_{d}$','$\hat{y}_{case1}$','$\hat{y}_{\rm case2}$','$\hat{y}_{\rm case3}$','$\hat{y}_{\rm case4}$','$\hat{y}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Position y [m]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$z_{d}$','$\hat{z}_{case1}$','$\hat{z}_{\rm case2}$','$\hat{z}_{\rm case3}$','$\hat{z}_{\rm case4}$','$\hat{z}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Position z [m]','FontSize',Fsize.label,'Interpreter','latex');
        end
        % xlim, ylimの設定
        if flg.xlimHold == 1
            if ~isfield(xlimHold,'p')
                xlim(xlimHold);
            else
                xlim(xlimHold.p);
            end
        end
        if flg.ylimHold == 1
            if ~isfield(ylimHold,'p')
                ylim(ylimHold);
            else
                ylim(ylimHold.p);
            end
        end
    end
    hold off
    
end

%% Q

for graph_num = 1:3 
    figure(graph_num + 3)
    colororder(newcolors)
    plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.q(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    for i = 1:HowmanyFile
        if graph_num == 1
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\phi_d$','$\hat{\phi}_{\rm case1}$','$\hat{\phi}_{\rm case2}$','$\hat{\phi}_{\rm case3}$','$\hat{\phi}_{\rm case4}$','$\hat{\phi}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Attitude $\phi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\theta_d$','$\hat{\theta}_{\rm case1}$','$\hat{\theta}_{\rm case2}$','$\hat{\theta}_{\rm case3}$','$\hat{\theta}_{\rm case4}$','$\hat{\theta}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Attitude $\theta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\psi_d$','$\hat{\psi}_{\rm case1}$','$\hat{\psi}_{\rm case2}$','$\hat{\psi}_{\rm case3}$','$\hat{\psi}_{\rm case4}$','$\hat{\psi}_{\rm case5}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Attitude $\psi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
        end
        % xlim, ylimの設定
        if flg.xlimHold == 1
            if ~isfield(xlimHold,'q')
                xlim(xlimHold);
            else
                xlim(xlimHold.q);
            end
        end
        if flg.ylimHold == 1
            if ~isfield(ylimHold,'q')
                ylim(ylimHold);
            else
                ylim(ylimHold.q);
            end
        end
    end
    hold off
end

%% v

for graph_num = 1:3 
    figure(graph_num + 6)
    colororder(newcolors)
    plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.v(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    for i = 1:HowmanyFile
        if graph_num == 1
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$v_{xd}$','$\hat{v}_{x,{\rm case1}}$','$\hat{v}_{x,{\rm case2}}$','$\hat{v}_{x,{\rm case3}}$','$\hat{v}_{x,{\rm case4}}$','$\hat{v}_{x,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Velocity $v_x$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$v_{yd}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{y,{\rm case2}}$','$\hat{v}_{y,{\rm case3}}$','$\hat{v}_{y,{\rm case4}}$','$\hat{v}_{y,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Velocity $v_y$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$v_{zd}$','$\hat{v}_{z,{\rm case1}}$','$\hat{v}_{z,{\rm case2}}$','$\hat{v}_{z,{\rm case3}}$','$\hat{v}_{z,{\rm case4}}$','$\hat{v}_{z,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Velocity $v_z$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
        end
        % xlim, ylimの設定
        if flg.xlimHold == 1
            if ~isfield(xlimHold,'q')
                xlim(xlimHold);
            else
                xlim(xlimHold.q);
            end
        end
        if flg.ylimHold == 1
            if ~isfield(ylimHold,'q')
                ylim(ylimHold);
            else
                ylim(ylimHold.q);
            end
        end
    end
    hold off
end

%% w

for graph_num = 1:3 
    figure(graph_num + 9)
    colororder(newcolors)
    plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.w(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    for i = 1:HowmanyFile
        if graph_num == 1
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\omega_{1 d}$','$\hat{\omega}_{1,{\rm case1}}$','$\hat{\omega}_{1,{\rm case2}}$','$\hat{\omega}_{1,{\rm case3}}$','$\hat{\omega}_{1,{\rm case4}}$','$\hat{\omega}_{1,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Angular Velocity $\omega_{1 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\omega_{2 d}$','$\hat{\omega}_{2,{\rm case1}}$','$\hat{\omega}_{2,{\rm case2}}$','$\hat{\omega}_{2,{\rm case3}}$','$\hat{\omega}_{2,{\rm case4}}$','$\hat{\omega}_{2,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Angular Velocity $\omega_{2 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i ==1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':','Color',[0 0.6 0.4]);
            elseif i == 3
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.9290 0.6940 0.1250]);
            elseif i == 4
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[0.6 0 1]);
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.','Color',[1 0 1]);
            end
            lgdtmp = {'$\omega_{3 d}$','$\hat{\omega}_{3,{\rm case1}}$','$\hat{\omega}_{3,{\rm case2}}$','$\hat{\omega}_{3,{\rm case3}}$','$\hat{\omega}_{3,{\rm case4}}$','$\hat{\omega}_{3,{\rm case5}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Angular Velocity $\omega_{3 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
        end
        % xlim, ylimの設定
        if flg.xlimHold == 1
            if ~isfield(xlimHold,'q')
                xlim(xlimHold);
            else
                xlim(xlimHold.q);
            end
        end
        if flg.ylimHold == 1
            if ~isfield(ylimHold,'q')
                ylim(ylimHold);
            else
                ylim(ylimHold.q);
            end
        end
    end
    hold off
end
%% pdfで保存
Num = input('pdfで保存しますか (しない : 0 / する : 1)：','s'); %0:各グラフで出力,1:いっぺんに出力
pdf = str2double(Num); %文字列を数値に変換

if pdf == 1
    mkdir(folderName);
    movefile(folderName,'Graph')
    exportgraphics(figure(1),strcat('Position_x_',name,'.pdf'))
    movefile(strcat('Position_x_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(2),strcat('Position_y_',name,'.pdf'))
    movefile(strcat('Position_y_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(3),strcat('Position_z_',name,'.pdf'))
    movefile(strcat('Position_z_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(4),strcat('phi_',name,'.pdf'))
    movefile(strcat('phi_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(5),strcat('theta_',name,'.pdf'))
    movefile(strcat('theta_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(6),strcat('psi_',name,'.pdf'))
    movefile(strcat('psi_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(7),strcat('velocity_x_',name,'.pdf'))
    movefile(strcat('velocity_x_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(8),strcat('velocity_y_',name,'.pdf'))
    movefile(strcat('velocity_y_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(9),strcat('velocity_z_',name,'.pdf'))
    movefile(strcat('velocity_z_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(10),strcat('omega_phi_',name,'.pdf'))
    movefile(strcat('omega_phi_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(11),strcat('omega_theta_',name,'.pdf'))
    movefile(strcat('omega_theta_',name,'.pdf'),fullfile('Graph',folderName))
    exportgraphics(figure(12),strcat('omega_psi_',name,'.pdf'))
    movefile(strcat('omega_psi_',name,'.pdf'),fullfile('Graph',folderName))
end
