%% Koopman Linear by Data %%
% 先に main.m の Initialize settings を実行すること
% initialize
clc
clear
close all
% フラグ管理
flg.bilinear = 0;

%データ保存先ファイル名
FileName = 'EstimationResult_12state_100data_5_417_.mat'; %保存先のファイル名も逐次変更する
% FileName = 'otamesi.mat';

% 読み込むデータファイル名
% loading_filename = 'sim_rndP_12state';
loading_filename = 'simtest'; %run_mainManyTimeの中のFileNameに変更すればそのファイルを読み込んでくれる
% loading_filename = 'sim_rndP4;

%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% Defining Koopman Operator
% クープマン作用素を定義
% F@(X) Xを与える関数ハンドルとして定義
% DroneSimulation
F = @(x) [x;1]; % 状態そのまま
% F = @quaternionParameter; % クォータニオンを含む13状態の観測量
% F = @eulerAngleParameter; % 姿勢角をオイラー角モデルの状態方程式からdq/dt部分を抜き出した観測量
% F = @eulerAngleParameter_withinConst; % eulerAngleParameter+慣性行列を含む部分(dvdt)を含む観測量
% F = @eulerAngleParameter_InputAndConst; % eulerAngleParameter_withinConst+入力にかかる係数行列の項を含む観測量(しっかり回る)
% F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用(しっかり回る)
% F = @quaternions_13state; % 状態+クォータニオンの1乗2乗3乗 クォータニオンパラメータ用
% F = @eulerAngleParameter_withoutP;

% load data
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

% 使用するデータセットの数を指定
% 23/01/26 run_mainManyTime.m で得たデータを合成
disp('now loading data set')
Data.HowmanyDataset = 10; %使用するデータの量に応じて逐次変更

for i= 1: Data.HowmanyDataset
    Dataset = InportFromExpData(append(loading_filename,'_',num2str(i),'.mat')); %行列の形に直してる
    if i==1
        Data.X = [Dataset.X]; %Data.X内の行は上から位置(x,y,z),姿勢角(ロール、ピッチ、ヨー)...
        Data.U = [Dataset.U];
        Data.Y = [Dataset.Y];        
    else
        Data.X = [Data.X, Dataset.X];
        Data.U = [Data.U, Dataset.U];
        Data.Y = [Data.Y, Dataset.Y];
    end
    disp(num2str(i))
end
disp('loaded')

% クォータニオンのノルムをチェック
% 閾値を下回った or 上回った場合注意文を提示
% attitude_norm 各時間におけるクォータニオンのノルム (クォータニオンのノルムは1にならなければいけないという制約がある)
if size(Data.X,1)==13
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Dataset.est.q',thre); 
end

% OUIBS system
% F = @(x) x;
% F = @(x) [x(2);sin(x(1));cos(x(1))];
% F = @(x) [x(1);x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];
% F = @(x) [x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];

%% Koopman linear
% 12/12 関数化
disp('now estimating')
if flg.bilinear == 1 %双線形であるかどうかの切り替え(上が双線形)
    [est.Ahat, est.Bhat, est.Ehat, est.Chat] = KoopmanLinear_biLinear(Data.X,Data.U,Data.Y,F);
else
    [est.Ahat, est.Bhat, est.Chat] = KoopmanLinear(Data.X,Data.U,Data.Y,F);
end
est.observable = F;
disp('Estimated')

%% Simulation by Estimated model (作ったモデルでシミュレーション)
%分からないから先輩に聞こう！
%中間発表の推定精度検証シミュレーション
simResult.reference = InportFromExpData('TestData3.mat');
if flg.bilinear == 1
%     simResult.Z(:,1) = F(simResult.reference.X(:,1));
%     simResult.Xhat(:,1) = simResult.reference.X(:,1);
%     simResult.U = simResult.reference.U;
%     simResult.T = simResult.reference.T;
    simResult.Z(:,1) = F(simResult.reference.X(:,1));
    simResult.Xhat(:,1) = simResult.reference.X(:,1);
    simResult.U = simResult.reference.U(:,1:end);
    simResult.T = simResult.reference.T(1:end);
    % dZ = A*Z + (B + E*R*ez*[1,1,1,1])*u
%     for i = 1:1:simResult.reference.N-2
    for i = 1:1:simResult.reference.N-2
%         roll  = simResult.Z(4,i);
%         pitch = simResult.Z(5,i);
%         yaw   = simResult.Z(6,i);
        % R*ez
%         R13 = ( 2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)) + 2.*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)))./m;
%         R23 = (-2.*(cos(pitch/2).*cos(roll/2).*cos(yaw/2) + sin(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(yaw/2).*sin(roll/2) - cos(roll/2).*sin(pitch/2).*sin(yaw/2)) - 2.*(cos(roll/2).*cos(yaw/2).*sin(pitch/2) + cos(pitch/2).*sin(roll/2).*sin(yaw/2)).*(cos(pitch/2).*cos(roll/2).*sin(yaw/2) - cos(yaw/2).*sin(pitch/2).*sin(roll/2)))./m;
%         R33 =  (cos(pitch).*cos(roll))/m;
        %simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + (est.Bhat + [zeros(6,4);est.Ehat(7:8,:)*simResult.Z(13:14,i)*[1,1,1,1];zeros(7,4)] )* simResult.U(:,i);
        simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + (est.Bhat + est.Ehat*simResult.Z(13:15,i)*[1,1,1,1] )* simResult.U(:,i);
        simResult.Xhat(:,i+1) = est.Chat * simResult.Z(:,i+1);
    end
else
    simResult.Z(:,1) = F(simResult.reference.X(:,1)); 
    simResult.Xhat(:,1) = simResult.reference.X(:,1);
    simResult.U = simResult.reference.U;
    simResult.T = simResult.reference.T;
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + est.Bhat * simResult.U(:,i);
        simResult.Xhat(:,i+1) = est.Chat * simResult.Z(:,i+1);
    end
end
%% Save Estimation Result (結果を保存するところ)
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
simResult.state.N = simResult.reference.N-1;
simResult.observable = F;
save(targetpath,'est','Data','simResult')
disp('Saved to')
disp(targetpath)

%% Display MSE
% 工事中 多分ずっと

%% Plot by simulation(グラフを出力するところ)
% stepN = 31;
% dt = simResult.reference.T(2)-simResult.reference.T(1);
% tlength = simResult.reference.T(1:stepN);
% 
% % P
% figure(1)
% subplot(2,1,2);
% p2 = plot(tlength,simResult.reference.est.p(1:stepN,:)','LineWidth',2);
% hold on
% grid on
% xlabel('time [sec]','FontSize',12);
% ylabel('Original Data','FontSize',12);
% legend('x','y','z','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% originYlim = gcf().CurrentAxes.YLim;
% originXlim = gcf().CurrentAxes.XLim;
% hold off
% subplot(2,1,1);
% p1 = plot(tlength,simResult.state.p(:,1:stepN),'LineWidth',2);
% xlim(originXlim)
% ylim(originYlim)
% hold on
% grid on
% 
% ylabel('Estimated Data','FontSize',12);
% legend('x','y','z','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% 
% % Q
% figure(2)
% subplot(2,1,2);
% p2 = plot(tlength ,simResult.reference.est.q(1:stepN,:)','LineWidth',2);
% hold on
% grid on
% originYlim = gcf().CurrentAxes.YLim;
% xlabel('time [sec]','FontSize',12);
% ylabel('Original Data','FontSize',12);
% legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% subplot(2,1,1);
% p1 = plot(tlength,simResult.state.q(:,1:stepN),'LineWidth',2);
% hold on
% grid on
% ylim(originYlim)
% ylabel('Estimated Data','FontSize',12);
% legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% 
% % V
% figure(3)
% subplot(2,1,2);
% p2 = plot(tlength ,simResult.reference.est.v(1:stepN,:)','LineWidth',2);
% hold on
% grid on
% originYlim = gcf().CurrentAxes.YLim;
% xlabel('time [sec]','FontSize',12);
% ylabel('Original Data','FontSize',12);
% legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% subplot(2,1,1);
% p1 = plot(tlength,simResult.state.v(:,1:stepN),'LineWidth',2);
% hold on
% grid on
% ylim(originYlim)
% ylabel('Estimated Data','FontSize',12);
% legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% 
% 
% % W
% figure(4)
% subplot(2,1,2);
% p2 = plot(tlength ,simResult.reference.est.w(1:stepN,:)','LineWidth',2);
% hold on
% grid on
% originYlim = gcf().CurrentAxes.YLim;
% xlabel('time [sec]','FontSize',12);
% ylabel('Original Data','FontSize',12);
% legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% subplot(2,1,1);
% p1 = plot(tlength,simResult.state.w(:,1:stepN),'LineWidth',2);
% hold on
% grid on
% ylim(originYlim)
% ylabel('Estimated Data','FontSize',12);
% legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
% set(gca,'FontSize',14);
% hold off
% 
% 
% % % Z
% % figure(5)
% % plot(simResult.T,simResult.Z);
