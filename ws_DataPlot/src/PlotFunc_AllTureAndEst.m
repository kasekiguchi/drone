function [FigNum] = PlotFunc_AllTureAndEst(obj,FigNum)
% labelstr = ['x','y','z'];
plotcolor = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840];
%plant(true)
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.result.state.p');
if Flag
    %estimation
    [~,EstDim,EstData] = FindDataMatchName(obj.logger,'estimator.result.state.p');
    if ~PlantDim ==EstDim
        error('Dimention is not match');
    end
%     [~,PlantVDim,PlantVData,vFlag] = FindDataMatchName(obj.logger,'plant.state.v');
%     [~,EstVDim,EstVData,veFlag] = FindDataMatchName(obj.logger,'estimator.result.state.v');
%     [~,PlantWDim,PlantWData,wFlag] = FindDataMatchName(obj.logger,'plant.state.w');
%     [~,EstWDim,EstWData,weFlag] = FindDataMatchName(obj.logger,'estimator.result.state.w');
    [~,PlantqDim,PlantqData,~] = FindDataMatchName(obj.logger,'plant.result.state.q');
    [~,EstqDim,EstqData] = FindDataMatchName(obj.logger,'estimator.result.state.q');
    if ~PlantqDim == EstqDim
        error('Dimention is not match');
    end
    %Time
    Time = obj.logger.data(0,'t',[]);%cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
    axis equal
    for pidx = 1:PlantDim
        plot(Time,PlantData(pidx,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(pidx,:));
        plot(Time,EstData(pidx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(pidx,:));
    end
    ylabel('State value [m]','Interpreter','latex');
    yyaxis right
    for qidx = 1:PlantqDim
        plot(Time,PlantqData(qidx,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(pidx + qidx,:));
        plot(Time,EstqData(qidx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(pidx + qidx,:));
    end
    xlabel('t [s]','Interpreter','latex');ylabel('State value [rad]','Interpreter','latex');
    legend('Plant  $x$','Estimate $x$','Plant $y$','Estimate $y$','Plant $\theta$','Estimate $\theta$','Location','northoutside','NumColumns',3,'Interpreter','latex')
    HYaxis = ax.YAxis;
    HYaxis(2).Color = 'k'; %  右軸ラベルの色変更
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
%     exportgraphics(ax,strcat('Allfig','.pdf'));
%     movefile(strcat('Allfig','.pdf'),obj.SaveDateStr);
%     exportgraphics(ax,strcat('Allfig','.emf'));
%     movefile(strcat('Allfig','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp AllTureAndEst'));
end