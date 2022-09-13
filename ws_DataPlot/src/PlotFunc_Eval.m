function [FigNum] = PlotFunc_Eval(obj,FigNum)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840;0.9010 0.7450 0.9330;0.4010 0.7450 0.4330];
%plant(true)
%[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.Eval');
[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.eachfval');
if vFlag
    %Time
    %Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    Time = obj.logger.data(0,'t',[]);
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
%     axis equal
    fn = fieldnames(EvalData(1));
    for vidx = length(fn):-1:1
        plot(Time,[EvalData.(fn{vidx})],'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx,:));
%         plot(Time,EstVData(vidx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx,:));
        ltext(vidx) = string(fn{vidx});
    end
    xlabel('t [s]','Interpreter','latex');ylabel('State value [rad/s]','Interpreter','latex');
    %legend('Eval1','Eval2','Eval3','Eval4','Location','northoutside','NumColumns',3,'Interpreter','latex')
    legend(ltext,'Location','northoutside','NumColumns',3,'Interpreter','latex')
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('Eval','.pdf'));
    movefile(strcat('Eval','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('Eval','.emf'));
    movefile(strcat('Eval','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp Eval'));
end