%% Koopman Linear by Data %%
% 先に main.m の Initialize settings を実行すること

% initialize
clc
clear
close all

%データ保存先ファイル名
FileName = 'EstimationResult.mat';

%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% load data
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

% 使用するデータセットの数を指定
% 23/01/18現在 1 or 2 のみ対応
Data.HowmanyDataset = 2;

switch Data.HowmanyDataset
    case 1
        Dataset1 = InportFromExpData('TestData2.mat');

        Data.X = [Dataset1.X];
        Data.U = [Dataset1.U];
        Data.Y = [Dataset1.Y];
    case 2
        Dataset1 = InportFromExpData('TestData1.mat');
        Dataset2 = InportFromExpData('TestData2.mat');

        Data.X = [Dataset1.X, Dataset2.X];
        Data.U = [Dataset1.U, Dataset2.U];
        Data.Y = [Dataset1.Y, Dataset2.Y];
end
% Data = InportFromOUIBSimulationData();

% クォータニオンのノルムをチェック
% 閾値を下回った or 上回った場合注意文を提示
% attitude_norm 各時間におけるクォータニオンのノルム
if size(Data.X,1)==13
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Data.est.q',thre);
end

%% Defining Koopman Operator
% クープマン作用素を定義
% F@(X) Xを与える関数ハンドルとして定義
% DroneSimulation
% F = @(x) x; % 状態そのまま
% F = @quaternionParameter; % クォータニオンを含むパラメータを追加 22/11/22 観測量にクォータニオンを含めるとうまく推定できない？
F = @eulerAngleParameter;
% F = @eulerAngleParameter_withinConst;
% F = @eulerAngleParameter_InputAndConst;


% OUIBS system
% F = @(x) x;
% F = @(x) [x(2);sin(x(1));cos(x(1))];
% F = @(x) [x(1);x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];
% F = @(x) [x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];

%% Koopman linear
% 12/12 関数化
[est.Ahat,est.Bhat, est.Chat] = KoopmanLinear(Data.X,Data.U,Data.Y,F);

disp('Estimated')

%% Simulation by Estimated model
simResult.reference = InportFromExpData('TestData1.mat');
simResult.Z(:,1) = F(simResult.reference.X(:,1));
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U;
simResult.T = simResult.reference.T;
for i = 1:1:simResult.reference.N-2
    simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + est.Bhat * simResult.U(:,i);
    simResult.Xhat(:,i+1) = est.Chat * simResult.Z(:,i);
end
% SimulationByEstimatedModel

%% Save Estimation Result
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

save(targetpath,'est','Data','simResult')
disp('Saved to')
disp(targetpath)

%% Display MSE
% 工事中

%% Plot by simulation
% P
figure(1)
subplot(2,1,2);
p2 = plot(simResult.reference.T(1:simResult.state.N),simResult.reference.est.p(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
originYlim = gcf().CurrentAxes.YLim;
hold off
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.p,'LineWidth',2);
ylim(originYlim)
hold on
grid on

ylabel('Estimated Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

% Q
figure(2)
subplot(2,1,2);
p2 = plot(simResult.reference.T(1:simResult.state.N),simResult.reference.est.q(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
originYlim = gcf().CurrentAxes.YLim;
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.q,'LineWidth',2);
hold on
grid on
ylim(originYlim)
ylabel('Estimated Data','FontSize',12);
legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

% V
figure(3)
subplot(2,1,2);
p2 = plot(simResult.reference.T(1:simResult.state.N),simResult.reference.est.v(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
originYlim = gcf().CurrentAxes.YLim;
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.v,'LineWidth',2);
hold on
grid on
ylim(originYlim)
ylabel('Estimated Data','FontSize',12);
legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off


% W
figure(4)
subplot(2,1,2);
p2 = plot(simResult.reference.T(1:simResult.state.N),simResult.reference.est.w(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
originYlim = gcf().CurrentAxes.YLim;
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.w,'LineWidth',2);
hold on
grid on
ylim(originYlim)
ylabel('Estimated Data','FontSize',12);
legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off


% Z
figure(5)
plot(simResult.T,simResult.Z);
