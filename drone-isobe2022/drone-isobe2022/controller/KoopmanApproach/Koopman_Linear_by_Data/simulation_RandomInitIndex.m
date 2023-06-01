%% simulation_RandomInitIndex
% テストデータのランダムな時刻を初期状態とした検証シミュレーションを複数回実行
%% initialize
clc
clear
close all
%% flag
flg.plotresult_eachTime = 1; % 毎回結果をプロットする 出力までが伸びます

%% 初期設定
% データ保存先フォルダ
FolderName = 'RandomInitialIndexTest';

%データ保存先ファイル名
% 'FileName'_'シミュレーション番号'.mat
FileName = 'EstimationResult_12state_6_1_Input_byLiner';

% 読み込むデータファイル名
loading_filename = 'EstimationResult_12state_6_1_Input_byLiner.mat';

% シミュレーション実行回数
HowmanySimulationRunning = 4;

% 確認するステップ数
stepN = 20;

% 乱数シード
% seed = double('T');
seed = double('C');
% seed = double('U');
% seed = double('G');
rng(seed);

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
            simResult.Z(:,j+1) = est.Ahat * simResult.Z(:,j) + (est.Bhat + est.Ehat*simResult.Z(13:15,j)*[1,1,1,1] )* simResult.U(:,j);
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
            simResult.Z(:,j+1) = est.Ahat * simResult.Z(:,j) + est.Bhat * simResult.U(:,j);
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
    end
    % シミュレーション結果のプロット
    close all
    if flg.plotresult_eachTime
        plotSimulationResult(simResult, stepN)
%         pause(2);
        
        pause;

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
    save(fileName,'simResult','est');
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

    % P
    fp = figure(1);
    subplot(2,1,2);
    p2 = plot(tlength,simResult.reference.est.p(simResult.initTindex:simResult.initTindex+stepN,:)','LineWidth',2);
    hold on
    grid on
    xlabel('time [sec]','FontSize',12);
    ylabel('Original Data','FontSize',12);
    legend('x','y','z','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    originYlim = gcf().CurrentAxes.YLim;
    originXlim = gcf().CurrentAxes.XLim;
    hold off
    subplot(2,1,1);
    p1 = plot(tlength,simResult.state.p(:,1:stepN+1),'LineWidth',2);
    xlim(originXlim)
    ylim(originYlim)
    hold on
    grid on
    
    ylabel('Estimated Data','FontSize',12);
    legend('x','y','z','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off

    movegui(fp,'northwest')
    
    % Q
    fq = figure(2);
    subplot(2,1,2);
    p2 = plot(tlength ,simResult.reference.est.q(simResult.initTindex:simResult.initTindex+stepN,:)','LineWidth',2);
    hold on
    grid on
    originYlim = gcf().CurrentAxes.YLim;
    xlabel('time [sec]','FontSize',12);
    ylabel('Original Data','FontSize',12);
    legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off
    subplot(2,1,1);
    p1 = plot(tlength,simResult.state.q(:,1:stepN+1),'LineWidth',2);
    hold on
    grid on
    ylim(originYlim)
    ylabel('Estimated Data','FontSize',12);
    legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off

    movegui(fq,'northeast')
    
    % V
    fv = figure(3);
    subplot(2,1,2);
    p2 = plot(tlength ,simResult.reference.est.v(simResult.initTindex:simResult.initTindex+stepN,:)','LineWidth',2);
    hold on
    grid on
    originYlim = gcf().CurrentAxes.YLim;
    xlabel('time [sec]','FontSize',12);
    ylabel('Original Data','FontSize',12);
    legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off
    subplot(2,1,1);
    p1 = plot(tlength,simResult.state.v(:,1:stepN+1),'LineWidth',2);
    hold on
    grid on
    ylim(originYlim)
    ylabel('Estimated Data','FontSize',12);
    legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off
    
    movegui(fv,'southwest')

    % W
    fw = figure(4);
    subplot(2,1,2);
    p2 = plot(tlength ,simResult.reference.est.w(simResult.initTindex:simResult.initTindex+stepN,:)','LineWidth',2);
    hold on
    grid on
    originYlim = gcf().CurrentAxes.YLim;
    xlabel('time [sec]','FontSize',12);
    ylabel('Original Data','FontSize',12);
    legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off
    subplot(2,1,1);
    p1 = plot(tlength,simResult.state.w(:,1:stepN+1),'LineWidth',2);
    hold on
    grid on
    ylim(originYlim)
    ylabel('Estimated Data','FontSize',12);
    legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
    set(gca,'FontSize',14);
    hold off

    movegui(fw,'southeast')
     
 end
