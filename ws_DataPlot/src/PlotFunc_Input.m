function [FigNum] = PlotFunc_Input(obj,FigNum,prename,trange)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840; ];
%plant(true)
%[~,~,Input,vFlag] = FindDataMatchName(obj.logger,'input');
Input = obj.logger.data(1,'input',"","ranget",trange)';
if 1%vFlag
    %Time
    %Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    Time = obj.logger.data(0,'t',[],"ranget",trange);
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')

    grid on
 %   axis equal
    plot(Time,Input(1,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(1,:));
    ylabel('$a$ [m/$s^2$]','Interpreter','latex');
 xlim([Time(1),Time(end)]);
    ylim([-1.2,1.2]);
    yyaxis right
        plot(Time,Input(2,:),'Linewidth',3,'LineStyle',':','Color',plotcolor(2,:));
 xlim([Time(1),Time(end)]);
    ylim([-1.2,1.2]);
    xlabel('t [s]','Interpreter','latex');ylabel('$\omega$ [rad/s]','Interpreter','latex');
    legend('$a$','$w$','Location','northoutside','NumColumns',3,'Interpreter','latex')
    HYaxis = ax.YAxis;
    HYaxis(2).Color = 'k'; %  右軸ラベルの色変更

    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    pbaspect([3 1 1]);
    hold off
    exportgraphics(ax,strcat(prename,'Input','.pdf'));
    movefile(strcat(prename,'Input','.pdf'),obj.SaveDateStr);
%     exportgraphics(ax,strcat('Input','.emf'));
%     movefile(strcat('Input','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp VWTureAndEst'));
end