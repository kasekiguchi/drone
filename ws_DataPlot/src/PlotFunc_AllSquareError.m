function [FigNum] = PlotFunc_AllSquareError(obj,FigNum)
labelstr = ['x','y','theta'];
plotcolor = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840];
%plant(true)
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.state.p');
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
    [~,PlantqDim,PlantqData,~] = FindDataMatchName(obj.logger,'plant.state.q');
    [~,EstqDim,EstqData] = FindDataMatchName(obj.logger,'estimator.result.state.q');
    if ~PlantqDim == EstqDim
        error('Dimention is not match');
    end
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    %under code make figure
    for fi = 1:(PlantDim)
        figure(FigNum)
        hold on;
        ax = gca;
        grid on
        %     axis equal
        plot(Time,(PlantData(fi,:) - EstData(fi,:)).^2,'Linewidth',3,'LineStyle','-','Color',plotcolor(fi,:));
        xlabel('t [s]','Interpreter','latex');
        ylabel('State value [m]','Interpreter','latex');
        %---テンプレ部分---%
        ax.FontSize = obj.FontSize;
        ax.FontName = obj.FontName;
        ax.FontWeight = obj.FontWeight;
        hold off
        exportgraphics(ax,strcat(labelstr(fi),'.pdf'));
        movefile(strcat(labelstr(fi),'.pdf'),obj.SaveDateStr);
        exportgraphics(ax,strcat(labelstr(fi),'.emf'));
        movefile(strcat(labelstr(fi),'.emf'),obj.SaveDateStr);
        FigNum = FigNum + 1;
        %---------------------%
    end
    
    for fi = 1:(PlantqDim)
        figure(FigNum)
        hold on;
        ax = gca;
        grid on
        %     axis equal
        plot(Time,(PlantqData(fi,:) - EstqData(fi,:)).^2,'Linewidth',3,'LineStyle','-','Color',plotcolor(fi+PlantDim,:));
        xlabel('t [s]','Interpreter','latex');
        ylabel('State value [rad]','Interpreter','latex');
        %---テンプレ部分---%
        ax.FontSize = obj.FontSize;
        ax.FontName = obj.FontName;
        ax.FontWeight = obj.FontWeight;
        hold off
        exportgraphics(ax,strcat(labelstr(fi+PlantDim),'.pdf'));
        movefile(strcat(labelstr(fi+PlantDim),'.pdf'),obj.SaveDateStr);
        exportgraphics(ax,strcat(labelstr(fi+PlantDim),'.emf'));
        movefile(strcat(labelstr(fi+PlantDim),'.emf'),obj.SaveDateStr);
        FigNum = FigNum + 1;
        %---------------------%
    end
else
    disp(strcat('we do not disp AllTureAndEst'));
end