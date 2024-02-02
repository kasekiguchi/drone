%% simulation_RandomInitIndex
% テストデータのランダムな時刻を初期状態とした検証シミュレーションを複数回実行
%% initialize
clc
clear all
close all

%% グラフを再表示したい場合にセクションの実行
% close all
% clc
% clear all
% load('test_11_2_1.mat')
% plotSimulationResult(simResult, stepN)

%% flag
flg.plotresult_eachTime = 1; % 毎回結果をプロットする 出力までが伸びます

%% 初期設定
% データ保存先フォルダ
FolderName = 'RandomInitialIndexTest';

%データ保存先ファイル名
% 'FileName'_'シミュレーション番号'.mat
FileName = 'test';

% 読み込むデータファイル名
loading_filename = 'EstimationResult_12state_1_29_Exp_sprineandhov_est=P2Pshape_torque_incon.mat';

% シミュレーション実行回数
HowmanySimulationRunning = 1;

% 確認するステップ数
stepN = 55;

% 乱数シード %初期idxの値を固定したい場合はコメントイン
% seed = double('T');
% seed = double('C');
% seed = double('U');
% seed = double('G');
% rng(seed);

%% データの読み込みと保存先の設定
% データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FolderName,'\',FileName);
% データ読み込み
load(loading_filename)
F = est.observable;
if isfield(est,'Ehat')
    flg.bilinear = 1;
else
    flg.bilinear = 0;
end

%% シミュレーション実行
for i = 1:HowmanySimulationRunning
    simResult = rmfield(simResult, {'Z','Xhat','U', 'T'});

    % 初期状態として抜き出す時間インデックスをランダムに決める
    simResult.initTindex = randi(size(simResult.reference.T,2),1);
    while size(simResult.initTindex) > size(simResult.reference.T,2) - 3*stepN 
        simResult.initTindex = randi(size(simResult.reference.T,2),1);
    end
    % simResult.initTindex = 3.5/0.025+1; %生成する時間固定の場合

    % 決めた時間インデックスiでの状態X[i]と観測量Fから観測量空間上の初期状態Z[1] = F(x[i])を求める
    simResult.Z(:,1) = F(simResult.reference.X(:,simResult.initTindex));
    
    % 状態真値X[i]を初期推定値Xhat[1]に代入
    simResult.Xhat(:,1) = simResult.reference.X(:,simResult.initTindex);
    
    % 時間インデックスiからシミュレーション終了時間-1までの入力と時間を抜き出して保存
    simResult.U = simResult.reference.U(:,simResult.initTindex:1:simResult.reference.N-2);
    simResult.T = simResult.reference.T(simResult.initTindex:1:simResult.reference.N-2);
    
    % シミュレーションループ
    if flg.bilinear ==1
        for j = 1:simResult.reference.N-2 - simResult.initTindex
            simResult.Z(:,j+1) = est.A * simResult.Z(:,j) + (est.Bhat + est.Ehat*simResult.Z(13:15,j)*[1,1,1,1] )* simResult.U(:,j);
            simResult.Xhat(:,j+1) = est.Chat * simResult.Z(:,j+1);
        end
        if size(Data.X,1)==13
             simResult.state.p = simResult.Xhat(1:3,:);
             simResult.state.q = simResult.Xhat(4:7,:);
             simResult.state.v = simResult.Xhat(8:10,:);
             simResult.state.w = simResult.Xhat(11:13,:);
         else
             simResult.state.p = simResult.Xhat(1:3,:);
             simResult.state.q = simResult.Xhat(4:6,:);
             simResult.state.v = simResult.Xhat(7:9,:);
             simResult.state.w = simResult.Xhat(10:12,:);
        end
    else
        for j = 1:simResult.reference.N-2 - simResult.initTindex
            simResult.Z(:,j+1) = est.A * simResult.Z(:,j) + est.B * simResult.U(:,j);
            simResult.Xhat(:,j+1) = est.C * simResult.Z(:,j+1);
        end
        if size(Data.X,1)==13
             simResult.state.p = simResult.Xhat(1:3,:);
             simResult.state.q = simResult.Xhat(4:7,:);
             simResult.state.v = simResult.Xhat(8:10,:);
             simResult.state.w = simResult.Xhat(11:13,:);
         else
             simResult.state.p = simResult.Xhat(1:3,:);
             simResult.state.q = simResult.Xhat(4:6,:);
             simResult.state.v = simResult.Xhat(7:9,:);
             simResult.state.w = simResult.Xhat(10:12,:);
        end
    end
    %% シミュレーション結果のプロット 
    close all
    if flg.plotresult_eachTime
        plotSimulationResult(simResult, stepN)
%         pause(2);
        
%         pause;

%         fig = uiufigure;
%         btn = uibutton(fig);
%         btn.Text = 'Continue';
%         btn.ButtonPushedFcn = 'uiresume(fig)';
%         
%         disp('This text prints immediately');
%         uiwait(fig)
%         disp('This text prints after you click Continue');
    end
    % 結果を保存
    fileName = append(targetpath,'_',num2str(i),'.mat');
    save(fileName,'simResult','est','stepN');
    disp('saved to')
    disp(fileName)
end

%% PLOTSIMULARIONRESULT
% output(空戻り値) = plotSimulationResult(simResult, stepN)
% シミュレーション結果 simReult から stepN 分抜き出してプロットを表示
% 引数であるsimResusltの構造が雑多なので他に活かせるとかは多分ない

function output = plotSimulationResult(simResult,stepN)
    dt = simResult.reference.T(2)-simResult.reference.T(1);
    tlength = simResult.reference.T(simResult.initTindex:simResult.initTindex+stepN);
    newcolors = [0 0.4470 0.7410
                 0.9900 0 0
                 0.3660 0.6740 0.1880];
    Fsize.label = 18;
    Fsize.lgd = 16;
    Fsize.luler = 18;
    columnomber = 3; %凡例のサイズを変更
    % P
    for i = 1:3
        figure(i)
        colororder(newcolors)
        plot(tlength,simResult.reference.est.p(simResult.initTindex:simResult.initTindex+stepN,i)','LineWidth',2);
        hold on
        grid on
        plot(tlength,simResult.state.p(i,1:stepN+1),'LineWidth',2,'LineStyle','-.');
        xlabel('time [sec]','FontSize',12);
        xlim([tlength(1) tlength(end)])
        if i == 1
            ylabel('Position x [m]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$x_r$','$\hat{x}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        elseif i == 2
            ylabel('Position y [m]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$y_r$','$\hat{y}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        else
            ylabel('Position z [m]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$z_r$','$\hat{z}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        end
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',14);
        hold off
    end
    
    % Q
    for i = 1:3
        figure(i+3)
        colororder(newcolors)
        plot(tlength,simResult.reference.est.q(simResult.initTindex:simResult.initTindex+stepN,i)','LineWidth',2);
        hold on
        grid on
        plot(tlength,simResult.state.q(i,1:stepN+1),'LineWidth',2,'LineStyle','-.');
        xlabel('time [sec]','FontSize',12);
        xlim([tlength(1) tlength(end)])
        if i == 1
            ylabel('Attitude $\phi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\phi_r$','$\hat{\phi}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        elseif i == 2
            ylabel('Attitude $\theta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\theta_r$','$\hat{\theta}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        else
            ylabel('Attitude $\psi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\psi_r$','$\hat{\psi}_e$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        end
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',14);
        hold off
    end
    
    % V
    for i = 1:3
        figure(i+6)
        colororder(newcolors)
        plot(tlength,simResult.reference.est.v(simResult.initTindex:simResult.initTindex+stepN,i)','LineWidth',2);
        hold on
        grid on
        plot(tlength,simResult.state.v(i,1:stepN+1),'LineWidth',2,'LineStyle','-.');
        xlabel('time [sec]','FontSize',12);
        xlim([tlength(1) tlength(end)])
        if i == 1
            ylabel('Velocity $v_x$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$v_{xr}$','$\hat{v}_{xe}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        elseif i == 2
            ylabel('Velocity $v_y$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$v_{yr}$','$\hat{v}_{ye}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        else
            ylabel('Velocity $v_z$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$v_{zr}$','$\hat{v}_{ze}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        end
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',14);
        hold off
    end

    % W
    for i = 1:3
        figure(i+9)
        colororder(newcolors)
        plot(tlength,simResult.reference.est.w(simResult.initTindex:simResult.initTindex+stepN,i)','LineWidth',2);
        hold on
        grid on
        plot(tlength,simResult.state.w(i,1:stepN+1),'LineWidth',2,'LineStyle','-.');
        xlabel('time [sec]','FontSize',12);
        xlim([tlength(1) tlength(end)])
        if i == 1
            ylabel('Angular Velocity $\omega_1$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\omega_{1r}$','$\hat{\omega}_{1e}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        elseif i == 2
            ylabel('Angular Velocity $\omega_2$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\omega_{2r}$','$\hat{\omega}_{2e}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        else
            ylabel('Angular Velocity $\omega_3$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
            lgdtmp = {'$\omega_{3r}$','$\hat{\omega}_{3e}$'};
            lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        end
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',14);
        hold off
    end
     
 end
