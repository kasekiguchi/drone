function [FigNum] = PlotFunc_TrajectoryRMSE(obj,FigNum)
% labelstr = ['x','y','z'];
plotcolor = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840];
%plant(true)
tmp = regexp(obj.logger.SubFuncitems,'TrajectoryErrorDis');
if length(obj.logger.SubFuncitems) > 1%subfunc have more than 1 item;
    tmp = cellfun(@(c) ~isempty(c),tmp);
else
    tmp = arrayfun(@(c) ~isempty(c),tmp);
end
Index = find(tmp)+1;
if isempty(Index)
    Flag = false;
    Dim = 0;
    Data = 0;
else
    Flag = true;
    if ~iscolumn(obj.logger.Data.SubFuncData{1,Index})
        Dim = size(obj.logger.Data.SubFuncData{1,Index}',1);
        Data = zeros(Dim,size(obj.logger.Data.t,1));
        for pI = 1:Dim
            Data(pI,:) = cell2mat(arrayfun(@(N) obj.logger.Data.SubFuncData{N,Index}(pI),1:size(obj.logger.Data.t,1),'UniformOutput',false));
        end
    else
        Dim = size(obj.logger.Data.SubFuncData{1,Index},1);
        Data = zeros(Dim,size(obj.logger.Data.t,1));
        for pI = 1:Dim
            Data(pI,:) = cell2mat(arrayfun(@(N) obj.logger.Data.SubFuncData{N,Index}(pI),1:size(obj.logger.Data.t,1),'UniformOutput',false));
        end
    end
end

if Flag
    %---Calculate RMSE---%
    Rmse = sqrt( sum((Data).^2 ) / length(Data) );
    %--------------------%
    %under code make figure
    figure(FigNum)
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
%     axis equal
%     for pidx = 1:Dim
%         plot(Time,Rmse,'Linewidth',3,'LineStyle','-','Color',plotcolor(pidx,:));
%     end
    bar(Rmse);
    ylabel('Eval','Interpreter','latex');
    xlabel('t [s]','Interpreter','latex');
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('TrajectoryRMSE','.pdf'));
    movefile(strcat('TrajectoryRMSE','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('TrajectoryRMSE','.emf'));
    movefile(strcat('TrajectoryRMSE','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp AllTureAndEst'));
end