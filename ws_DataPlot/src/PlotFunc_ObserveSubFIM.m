function [FigNum] = PlotFunc_ObserveSubFIM(obj,FigNum)
% labelstr = ['x','y','z'];
plotcolor = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840];
%plant(true)
tmp = regexp(obj.logger.SubFuncitems,'ObserbSubFIM');
if length(obj.logger.SubFuncitems) > 1%subfunc have more than 1 item;
    tmp = cellfun(@(c) ~isempty(c),tmp);
else
    tmp = arrayfun(@(c) ~isempty(c),tmp);
end
Index = find(tmp)+1;
if isempty(Index)
    Flag = false;
else
    Flag = true;
end

if Flag
    %---Calculate Fim---%
    EigOfFim = cell2mat(arrayfun(@(N) eig(obj.logger.Data.SubFuncData{N,Index}),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    M = max(EigOfFim);
    %--------------------%
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
    ylim([0 1e7]);
    xlim([0 Time(end)]);
    plot(Time,M,'Linewidth',3,'LineStyle','-','Color',plotcolor(1,:));
    ylabel('InvFimMaxeig','Interpreter','latex');
    xlabel('t [s]','Interpreter','latex');
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('ObserveSubFIM_Maxeig','.pdf'));
    movefile(strcat('ObserveSubFIM_Maxeig','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('ObserveSubFIM_Maxeig','.emf'));
    movefile(strcat('ObserveSubFIM_Maxeig','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp AllTureAndEst'));
end