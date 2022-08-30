function [FigNum] = PlotFunc_ExitFlag(obj,FigNum)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840; ];
%plant(true)
[~,~,Flag,vFlag] = FindDataMatchName(obj.logger,'controller.result.exitflag');
Flag = Flag';
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
    plot(Time,Flag(1,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(1,:));
    ylabel('State value [m/$s^2$]','Interpreter','latex');
    legend('$Flag$','Location','northoutside','NumColumns',3,'Interpreter','latex')
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
%     exportgraphics(ax,strcat('Flag','.pdf'));
%     movefile(strcat('Flag','.pdf'),obj.SaveDateStr);
%     exportgraphics(ax,strcat('Flag','.emf'));
%     movefile(strcat('Flag','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp VWTureAndEst'));
end