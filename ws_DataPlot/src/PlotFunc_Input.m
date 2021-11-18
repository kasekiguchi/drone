function [FigNum] = PlotFunc_Input(obj,FigNum)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840; ];
%plant(true)
[~,~,Input,vFlag] = FindDataMatchName(obj.logger,'input');
if vFlag
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
    axis equal
        plot(Time,Input(1,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(1,:));
    ylabel('State value [m/$s^2$]','Interpreter','latex');
    yyaxis right
        plot(Time,Input(2,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(2,:));
    xlabel('t [s]','Interpreter','latex');ylabel('State value [rad/s]','Interpreter','latex');
    legend('$v$','$w$','Location','northoutside','NumColumns',3,'Interpreter','latex')
    HYaxis = ax.YAxis;
    HYaxis(2).Color = 'k'; %  右軸ラベルの色変更
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('Input','.pdf'));
    movefile(strcat('Input','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('Input','.emf'));
    movefile(strcat('Input','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp VWTureAndEst'));
end