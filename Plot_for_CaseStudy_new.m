%%
clc
%%
FigNo=1;
% 実験結果を表示する→exp_flag = 1
exp_flag = 1;
% シミュレーション結果を表示する→sim_flag = 1
sim_flag = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exp_flag
% 実験結果のファイル名を記入 例：(['Log(12-Oct-2020_07_52_15).mat'])
exp = (['experiment.mat']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sim_flag
% シミュレーション結果のファイル名を記入 例：(['Log(12-Oct-2020_07_52_15).mat'])
sim = (['simulation.mat']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% for exp
if exp_flag
    Data_exp = load(exp);
    tt = find(Data_exp.logger.Data.t==0,2);
        for i=1:tt(2)-1
            Result_exp.Estimator.p(:,i) = Data_exp.logger.Data.agent{i,2}.state.p;
            Result_exp.Estimator.q(:,i) = Data_exp.logger.Data.agent{i,2}.state.q;
            Result_exp.Estimator.v(:,i) = Data_exp.logger.Data.agent{i,2}.state.v;
            Result_exp.Estimator.w(:,i) = Data_exp.logger.Data.agent{i,2}.state.w;
            Result_exp.Reference.p(:,i) = Data_exp.logger.Data.agent{i,3}.state.p;
%             Result_exp.Reference.xd(:,i) = Data_exp.logger.Data.agent{i,3}.state.xd;
        end
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Result_exp.Reference.p(1,:),Result_exp.Reference.p(2,:));
    fig2 = plot(Result_exp.Estimator.p(1,:),Result_exp.Estimator.p(2,:));
    xlabel('{\itx} [m]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.p(1,:));
    fig2 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(1,:));
    xlabel('{\itt} [s]')
    ylabel('{\itx} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.p(2,:));
    fig2 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(2,:));
    xlabel('{\itt} [s]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.p(3,:));
    fig2 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\itz} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')


%     if sum(contains(Data_exp.Data{1,2}{1,1},strcat('reference.result.state.xd')))>0
%         if size(Result_exp.Reference.xd(:,1)) == [20,1]
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.xd(5,:));
%             fig2 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.v(1,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_x} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
% 
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.xd(6,:));
%             fig2 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.v(2,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_y} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
% 
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Reference.xd(7,:));
%             fig2 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.v(3,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_z} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
%         end
%     end

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.q(1,:));
    fig2 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.q(2,:));
    fig3 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.q(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\theta} [rad]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',3)
    set(fig2,'LineWidth',3)
    set(fig3,'LineWidth',3)
    legend({'Roll','Pitch','Yaw'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.w(1,:));
    fig2 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.w(2,:));
    fig3 = plot(Data_exp.logger.Data.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.w(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\omega} [rad/s]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',3)
    set(fig2,'LineWidth',3)
    set(fig3,'LineWidth',3)
    legend({'Roll','Pitch','Yaw'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')
end
%% for sim
if sim_flag
    Data_sim = load(sim);
        for i=1:numel(Data_sim.logger.Data.t)
            Result_sim.Estimator.p(:,i) = Data_sim.logger.Data.agent{i,2}.state.p;
            Result_sim.Estimator.q(:,i) = Data_sim.logger.Data.agent{i,2}.state.q;
            Result_sim.Estimator.v(:,i) = Data_sim.logger.Data.agent{i,2}.state.v;
            Result_sim.Estimator.w(:,i) = Data_sim.logger.Data.agent{i,2}.state.w;
            Result_sim.Reference.p(:,i) = Data_sim.logger.Data.agent{i,3}.state.p;
            Result_sim.Reference.xd(:,i) = Data_sim.logger.Data.agent{i,3}.state.xd;
        end

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Result_sim.Reference.p(1,:),Result_sim.Reference.p(2,:));
    fig2 = plot(Result_sim.Estimator.p(1,:),Result_sim.Estimator.p(2,:));
    xlabel('{\itx} [m]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_sim.logger.Data.t,Result_sim.Reference.p(1,:));
    fig2 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.p(1,:));
    xlabel('{\itt} [s]')
    ylabel('{\itx} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_sim.logger.Data.t,Result_sim.Reference.p(2,:));
    fig2 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.p(2,:));
    xlabel('{\itt} [s]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_sim.logger.Data.t,Result_sim.Reference.p(3,:));
    fig2 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.p(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\itz} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')


%     if sum(contains(Data_sim.Data{1,2}{1,1},strcat('reference.result.state.xd')))>0
%         if size(Result_sim.Reference.xd(:,1)) == [20,1]
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_sim.Data{1,1}.t,Result_sim.Reference.xd(5,:));
%             fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.v(1,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_x} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
% 
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_sim.Data{1,1}.t,Result_sim.Reference.xd(6,:));
%             fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.v(2,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_y} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
% 
%             FigNo=FigNo + 1;
%             figure(FigNo)
%             hold on
%             grid on
%             fig1 = plot(Data_sim.Data{1,1}.t,Result_sim.Reference.xd(7,:));
%             fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.v(3,:));
%             xlabel('{\itt} [s]')
%             ylabel('{\itv_z} [m/s]')
%             set(gca,'FontName','Times New Roman')
%             set(gca,'FontSize',18)
%             set(fig1,'LineWidth',6)
%             set(fig2,'LineWidth',3)
%             legend({'Reference','State'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
%         end
%     end

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.q(1,:));
    fig2 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.q(2,:));
    fig3 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.q(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\theta} [rad]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',3)
    set(fig2,'LineWidth',3)
    set(fig3,'LineWidth',3)
    legend({'Roll','Pitch','Yaw'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')

    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.w(1,:));
    fig2 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.w(2,:));
    fig3 = plot(Data_sim.logger.Data.t,Result_sim.Estimator.w(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\omega} [rad/s]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',3)
    set(fig2,'LineWidth',3)
    set(fig3,'LineWidth',3)
    legend({'Roll','Pitch','Yaw'},'Location','southwest','Orientation','horizontal','Fontsize',10,'FontName','Times New Roman')
end
%%
if exp_flag && sim_flag
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Result_exp.Estimator.p(1,:),Result_exp.Estimator.p(2,:));
    fig2 = plot(Result_sim.Estimator.p(1,:),Result_sim.Estimator.p(2,:));
    xlabel('{\itx} [m]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(1,:));
    fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.p(1,:));
    xlabel('{\itt} [s]')
    ylabel('{\itx} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(2,:));
    fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.p(2,:));
    xlabel('{\itt} [s]')
    ylabel('{\ity} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.p(3,:));
    fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.p(3,:));
    xlabel('{\itt} [s]')
    ylabel('{\itz} [m]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.q(1:3,:));
    fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.q(1:3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\theta} [rad]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
    
    FigNo=FigNo + 1;
    figure(FigNo)
    hold on
    grid on
    fig1 = plot(Data_exp.Data{1,1}.t(1:length(Result_exp.Reference.p)),Result_exp.Estimator.w(1:3,:));
    fig2 = plot(Data_sim.Data{1,1}.t,Result_sim.Estimator.w(1:3,:));
    xlabel('{\itt} [s]')
    ylabel('{\it\omega} [rad/s]')
    set(gca,'FontName','Times New Roman')
    set(gca,'FontSize',18)
    set(fig1,'LineWidth',6)
    set(fig2,'LineWidth',3)
    legend({'exp','sim'},'Location','southwest','Orientation','horizontal','Fontsize',18,'FontName','Times New Roman')
end
