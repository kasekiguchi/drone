%% initialize
close all
clear

%% Flag
FLG_calcMean = 1

%% Font size setting
% plot 上のフォントサイズを指定
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% Plot T Span
% plot する時間の範囲を指定
tspan = [0, 20.0];

if FLG_calcMean~=1
    load('EstimationResult_OUBIS1.mat')
    simResult1 = simResult;
    load('EstimationResult_OUBIS2.mat')
    simResult2 = simResult;
    load('EstimationResult_OUBIS3.mat')
    simResult3 = simResult;
    load('EstimationResult_OUBIS4.mat')
    simResult4 = simResult;
else
    load('EstimationResult_OUBIS1_seedT.mat')
    simResult1T = simResult;
    load('EstimationResult_OUBIS1_seedC.mat')
    simResult1C = simResult;
    load('EstimationResult_OUBIS1_seedU.mat')
    simResult1U = simResult;
    load('EstimationResult_OUBIS2_seedT.mat')
    simResult2T = simResult;
    load('EstimationResult_OUBIS2_seedC.mat')
    simResult2C = simResult;
    load('EstimationResult_OUBIS2_seedU.mat')
    simResult2U = simResult;
    load('EstimationResult_OUBIS3_seedT.mat')
    simResult3T = simResult;
    load('EstimationResult_OUBIS3_seedC.mat')
    simResult3C = simResult;
    load('EstimationResult_OUBIS3_seedU.mat')
    simResult3U = simResult;
    load('EstimationResult_OUBIS4_seedT.mat')
    simResult4T = simResult;
    load('EstimationResult_OUBIS4_seedC.mat')
    simResult4C = simResult;
    load('EstimationResult_OUBIS4_seedU.mat')
    simResult4U = simResult;
end

%% Calculate Result mean
if FLG_calcMean
    simResult_meanX = simResult1T.X;
    simResult_meanX = (simResult_meanX+simResult1C.X)./2;
    simResult_meanX = (simResult_meanX+simResult1U.X)./2;
    simResult_mean1.Xhat = simResult1T.Xhat;
    simResult_mean1.Xhat = simResult_mean1.Xhat+simResult1C.Xhat;
    simResult_mean1.Xhat = simResult_mean1.Xhat+simResult1U.Xhat;
    simResult_mean1.Xhat = simResult_mean1.Xhat./3;
    simResult_mean1.U = simResult1T.U;
    simResult_mean1.U = simResult_mean1.U+simResult1C.U;
    simResult_mean1.U = simResult_mean1.U+simResult1U.U;
    simResult_mean1.U = simResult_mean1.U./3;
    
    simResult_meanX = (simResult_meanX+simResult2T.X)./2;
    simResult_meanX = (simResult_meanX+simResult2C.X)./2;
    simResult_meanX = (simResult_meanX+simResult2U.X)./2;
    simResult_mean2.Xhat = simResult2T.Xhat;
    simResult_mean2.Xhat = simResult_mean2.Xhat+simResult2C.Xhat;
    simResult_mean2.Xhat = simResult_mean2.Xhat+simResult2U.Xhat;
    simResult_mean2.Xhat = simResult_mean2.Xhat./3;
    simResult_mean2.U = simResult2T.U;
    simResult_mean2.U = simResult_mean2.U+simResult2C.U;
    simResult_mean2.U = simResult_mean2.U+simResult2U.U;
    simResult_mean2.U = simResult_mean2.U./3;
    
    simResult_meanX = (simResult_meanX+simResult3T.X)./2;
    simResult_meanX = (simResult_meanX+simResult3C.X)./2;
    simResult_meanX = (simResult_meanX+simResult3U.X)./2;
    simResult_mean3.Xhat = simResult3T.Xhat;
    simResult_mean3.Xhat = simResult_mean3.Xhat+simResult3C.Xhat;
    simResult_mean3.Xhat = simResult_mean3.Xhat+simResult3U.Xhat;
    simResult_mean3.Xhat = simResult_mean3.Xhat./3;
    simResult_mean3.U = simResult3T.U;
    simResult_mean3.U = simResult_mean3.U+simResult3C.U;
    simResult_mean3.U = simResult_mean3.U+simResult3U.U;
    simResult_mean3.U = simResult_mean3.U./3;
    
    simResult_meanX = (simResult_meanX+simResult4T.X)./2;
    simResult_meanX = (simResult_meanX+simResult4C.X)./2;
    simResult_meanX = (simResult_meanX+simResult4U.X)./2;
    simResult_mean4.Xhat = simResult4T.Xhat;
    simResult_mean4.Xhat = simResult_mean4.Xhat+simResult4C.Xhat;
    simResult_mean4.Xhat = simResult_mean4.Xhat+simResult4U.Xhat;
    simResult_mean4.Xhat = simResult_mean4.Xhat./3;
    simResult_mean4.U = simResult4T.U;
    simResult_mean4.U = simResult_mean4.U+simResult4C.U;
    simResult_mean4.U = simResult_mean4.U+simResult4U.U;
    simResult_mean4.U = simResult_mean4.U./3;
end

%%
T_first_logical = simResult.T <= tspan(1);
idx_t_first = find(T_first_logical,1,'last')
T_end_logical = simResult.T <= tspan(2);
idx_t_end = find(T_end_logical,1,'last')
%%
if FLG_calcMean~=1
    figure(1)
    subplot(2,1,1)
    p0 = plot(simResult.T(idx_t_first:idx_t_end),Data.X(1,idx_t_first:idx_t_end),'LineWidth',2);
    xlim(tspan)
    hold on
    grid on
    p1 = plot(simResult.T(idx_t_first:idx_t_end) , simResult1.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p2 = plot(simResult.T(idx_t_first:idx_t_end) , simResult2.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p3 = plot(simResult.T(idx_t_first:idx_t_end) , simResult3.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p4 = plot(simResult.T(idx_t_first:idx_t_end) , simResult4.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    xlim(tspan)
    ylabel('$\delta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
    set(gca,'FontSize',Fsize.luler);
    
    subplot(2,1,2)
    p0 = plot(simResult.T(idx_t_first:idx_t_end),Data.X(2,idx_t_first:idx_t_end),'LineWidth',2);
    xlim(tspan)
    hold on
    grid on
    p1 = plot(simResult.T(idx_t_first:idx_t_end) , simResult1.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p2 = plot(simResult.T(idx_t_first:idx_t_end) , simResult2.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p3 = plot(simResult.T(idx_t_first:idx_t_end) , simResult3.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p4 = plot(simResult.T(idx_t_first:idx_t_end) , simResult4.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    xlim(tspan)
    ylabel('$\omega$ [Hz]','FontSize',Fsize.label,'Interpreter','latex');
    set(gca,'FontSize',Fsize.luler);
    xlabel('time [sec]','FontSize',Fsize.label);
    lgd = legend('Nonlinear','Linear 1','Linear 2','Linear 3','Linear 4','Linear 5','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = 6;
    hold off
else
%% Xhat mean 
    figure(1)
    subplot(2,1,1)
    p0 = plot(simResult.T(idx_t_first:idx_t_end),simResult_meanX(1,idx_t_first:idx_t_end),'LineWidth',2);
    xlim(tspan)
    hold on
    grid on
    p1 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean1.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p2 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean2.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p3 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean3.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    p4 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean4.Xhat(1,idx_t_first:idx_t_end),'--','LineWidth',1);
    xlim(tspan)
    ylabel('$\delta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
    set(gca,'FontSize',Fsize.luler);
    
    subplot(2,1,2)
    p0 = plot(simResult.T(idx_t_first:idx_t_end),simResult_meanX(2,idx_t_first:idx_t_end),'LineWidth',2);
    xlim(tspan)
    hold on
    grid on
    p1 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean1.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p2 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean2.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p3 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean3.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    p4 = plot(simResult.T(idx_t_first:idx_t_end) , simResult_mean4.Xhat(2,idx_t_first:idx_t_end),'--','LineWidth',1);
    xlim(tspan)
    ylabel('$\omega$ [Hz]','FontSize',Fsize.label,'Interpreter','latex');
    set(gca,'FontSize',Fsize.luler);
    xlabel('time [sec]','FontSize',Fsize.label);
    lgd = legend('Nonlinear','Linear 1','Linear 2','Linear 3','Linear 4','Linear 5','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = 6;
    hold off
end

%% RMSE
rms(simResult_meanX(1,1:end-1)-simResult_mean2.Xhat(1,1:end))