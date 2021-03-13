function [FigNum] = PlotFunc_VWTureAndEst(obj,FigNum)
plotcolor = [0.3010 0.7450 0.9330;0.6350 0.0780 0.1840];
%plant(true)
[~,PlantVDim,PlantVData,vFlag] = FindDataMatchName(obj.logger,'plant.state.v');
if vFlag
    %estimation
    [~,EstVDim,EstVData,~] = FindDataMatchName(obj.logger,'estimator.result.state.v');
    if ~PlantVDim ==EstVDim
        error('Dimention is not match');
    end
    [~,PlantWDim,PlantWData,~] = FindDataMatchName(obj.logger,'plant.state.w');
    [~,EstWDim,EstWData,~] = FindDataMatchName(obj.logger,'estimator.result.state.w');
    if ~PlantWDim == EstWDim
        error('Dimention is not match');
    end
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
    axis equal
    for vidx = 1:PlantVDim
        plot(Time,PlantVData(vidx,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(vidx,:));
        plot(Time,EstVData(vidx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx,:));
    end
    ylabel('State value [m/s]','Interpreter','latex');
    yyaxis right
    for widx = 1:PlantWDim
        plot(Time,PlantWData(widx,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(vidx + widx,:));
        plot(Time,EstWData(widx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx + widx,:));
    end
    xlabel('t [s]','Interpreter','latex');ylabel('State value [rad/s]','Interpreter','latex');
    legend('Plant  $v$','Estimate $v$','Plant $\omega$','Estimate $\omega$','Location','northoutside','NumColumns',3,'Interpreter','latex')
    HYaxis = ax.YAxis;
    HYaxis(2).Color = 'k'; %  右軸ラベルの色変更
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('VWfig','.pdf'));
    movefile(strcat('VWfig','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('VWfig','.emf'));
    movefile(strcat('VWfig','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp VWTureAndEst'));
end