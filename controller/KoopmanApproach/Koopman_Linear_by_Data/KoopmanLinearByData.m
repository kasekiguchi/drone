%% Koopman Linear by Data %%

% initialize
clc
clear
close all

%% load data
% 実験データから必要なものを抜き出す処理
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

Data = InportFromExpData();

if size(Data.X,1)==13
    for i=1:Data.N-1
        attitude_norm(i) = norm(Data.est.q(i,:));
    end
end

%% Defining Koopman Operator
% 
% クープマン作用素を定義
% F@(X) Xを与える関数ハンドルとして定義
% F = @(x) x; % 状態そのまま
F = @quarternionParameter; % クォータニオンを含むパラメータを追加 20221109 現状発散する なんで？

%% Koopman linear
%Xlift,Yliftを計算する
for i = 1:size(Data.X,2)%1:Data.num
    est.Xlift(:,i) = F(Data.X(:,i));
    est.Ylift(:,i) = F(Data.Y(:,i));
end
[est.numX, ~] = size(est.Xlift);
[est.numU, ~] = size(Data.U);
 
% 個別にA,Bを計算する
% est.Ahat = est.Ylift*pinv(est.Xlift);
% est.Bhat = est.Ylift*pinv(Data.U);
% est.Chat = Data.X*pinv(est.Xlift);

%ABをまとめて計算する 参考資料記載のやりかた
est.M = est.Ylift * pinv([est.Xlift; Data.U]);
est.Ahat = est.M(1 : est.numX, 1 : est.numX);
est.Bhat = est.M(1 : est.numX, est.numX + 1:est.numX + est.numU);
est.Chat = Data.X*pinv(est.Xlift);

% % A,Bをまとめて計算するデータ数が多い場合のやりかた
% est.G = [est.Xlift ; Data.U]*[est.Xlift ; Data.U]';
% est.V = est.Ylift*[est.Xlift ; Data.U]';
% est.M = est.V * pinv(est.G);
% est.Ahat = est.M(1:est.numX, 1:est.numX);
% est.Bhat = est.M(1:est.numX, est.numX+1:est.numX+est.numU);
% est.Chat = Data.X*pinv(est.Xlift); % C: Z->X の厳密な求め方
% % est.Chat = [eye(2),zeros(2,4)]; % 観測量の頭に元の状態が含まれているときの C: Z->X

disp('Estimation Finishd')

%% Simulation by Estimated model
simResult.Z(:,1) = F(Data.X(:,1));
simResult.X = Data.X;
simResult.Xhat(:,1) = Data.X(:,1);
simResult.U = Data.U;
simResult.T = Data.T;
for i = 1:1:Data.N-2
    simResult.Z(:,i+1) = est.Ahat * simResult.Z(:,i) + est.Bhat * simResult.U(:,i);
    simResult.Xhat(:,i+1) = est.Chat * simResult.Z(:,i);
end

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
simResult.state.N = Data.N-1;

save('KoopmanApproarch\Koopman_Linear_by_Data\EstimationResult','est','Data','simResult')

%% Display MSE
% 工事中

%% Plot by Data with Quarternion13
% P
figure(1)
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.p,'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T(1:simResult.state.N),Data.est.p(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

% Q
figure(2)
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.q,'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T(1:simResult.state.N),Data.est.q(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('q0','q1','q2','q3','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

% V
figure(3)
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.v,'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T(1:simResult.state.N),Data.est.v(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('v_x','v_y','v_z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

% W
figure(4)
subplot(2,1,1);
p1 = plot(simResult.T , simResult.state.w,'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T(1:simResult.state.N),Data.est.w(1:simResult.state.N,:)','LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('w_{roll}','w_{pitch}','w_{yaw}','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
