%% plotResultの各グラフをそれぞれに分割して表示
clear all
close all

%% flag
flg.calcFile1RMSE = 1; % file{1}に読み込んだデータのRMSEを求める
flg.ylimHold = 0; % 指定した値にylimを固定
flg.xlimHold = 1; % 指定した値にxlimを固定

%% select file to load

% loadfilename{1} = 'EstimationResult_12state_6_26_circle=circle_estimation=circle.mat' ;%mainで書き込んだファイルの名前に逐次変更する
% loadfilename{2} = 'EstimationResult_12state_6_26_circle=flight_estimation=circle.mat';
% loadfilename{3} = 'EstimationResult_12state_6_20_circle__test_InputandConst_ByLinear.mat';

loadfilename{1} = 'test1.mat';
% loadfilename{2} = 'test2.mat';

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
    stepN = 61;
    if flg.xlimHold == 1
        xlimHold = [0,1];
    end
elseif stepnum == 2
    stepN = 91;
    if flg.xlimHold == 1
        xlimHold = [0,1.5];
    end
else
    stepN = 121;
    if flg.xlimHold == 1
        xlimHold = [0,2];
    end
end

% flg.ylimHoldがtrueのときのplot y範囲
if flg.ylimHold == 1
    ylimHold.p = [-1.5, 1.5];
    ylimHold.q = [-0.2, 0.8];
    ylimHold.v = [-3, 4];
    ylimHold.w = [-1.5, 2];
end

%% Font size
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% load
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
columnomber = size(file,2)+1;

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
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$x_d$','$\hat{x}_{\rm case1}$','$\hat{x}_{\rm case2}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Position x [m]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$y_d$','$\hat{y}_{\rm case1}$','$\hat{y}_{\rm case2}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Position y [m]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$z_d$','$\hat{z}_{\rm case1}$','$\hat{z}_{\rm case2}$'};
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
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];

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
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\phi_d$','$\hat{\phi}_{\rm case1}$','$\hat{\phi}_{\rm case2}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Attitude $\phi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\theta_d$','$\hat{\theta}_{\rm case1}$','$\hat{\theta}_{\rm case2}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
            ylabel('Attitude $\theta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\psi_d$','$\hat{\psi}_{\rm case1}$','$\hat{\psi}_{\rm case2}$'};
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
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];

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
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$v_{xd}$','$\hat{v}_{x,{\rm case1}}$','$\hat{v}_{x,{\rm case2}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Velocity $v_x$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$v_{yd}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{y,{\rm case2}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Velocity $v_y$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$v_{zd}$','$\hat{v}_{z,{\rm case1}}$','$\hat{v}_{z,{\rm case2}}$'};
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
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];

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
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\omega_{1 d}$','$\hat{\omega}_{1,{\rm case1}}$','$\hat{\omega}_{1,{\rm case2}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Angular Velocity $\omega_{1 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 2
            if i == 1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\omega_{2 d}$','$\hat{\omega}_{2,{\rm case1}}$','$\hat{\omega}_{2,{\rm case2}}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
            lgd.NumColumns = columnomber;
            set(gca,'FontSize',Fsize.luler);
            xlabel('time [sec]','FontSize',Fsize.label);
            ylabel('Angular Velocity $\omega_{2 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
        elseif graph_num == 3
            if i ==1
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
            elseif i == 2
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',3,'LineStyle',':');
            else
                plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(graph_num,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','-.');
            end
            lgdtmp = {'$\omega_{3 d}$','$\hat{\omega}_{3,{\rm case1}}$','$\hat{\omega}_{3,{\rm case2}}$'};
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
