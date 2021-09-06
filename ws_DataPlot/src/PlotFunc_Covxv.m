function [FigNum] = PlotFunc_Covxv(obj,FigNum)
%% robot State
tmp = regexp(obj.logger.items,'estimator.result.P');
tmp = cellfun(@(c) ~isempty(c),tmp);
Index = find(tmp);
if isempty(Index)
    Flag = false;
    data = 0;
else
    Flag = true;
    data = arrayfun(@(N) obj.logger.Data.agent{N,Index},1:size(obj.logger.Data.t,1),'UniformOutput',false);
end
if Flag
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    % make datas
    Data = arrayfun(@(N) data{1,N}(1,4),1:size(obj.logger.Data.t,1));%covxvを抽出
    
    % color code
    ColorCodes = [0.3922,0.8314,0.0745;...
                   0.3020,0.7451,0.9333;...
                   0.8510,0.3255,0.0980;...
                   0.4941,0.1843,0.5569];
    %make figure
        figure(FigNum)
        hold on;
        ax = gca;        
        plot(Time(1,:),Data(:),'Color',ColorCodes(1,:),'LineWidth',5);
        legend('Covxv','Location','northoutside','NumColumns',2);
        %setting
        grid on;
        % xlim([xmin xmax]);ylim([ymin ymax]);
        % xticks([xmin:dx:xmax]);yticks([ymin:dy:ymax]);
        % pbaspect([abs(xmin -xmax) abs(ymin -ymax) 1]);
        % axis equal;
        xlim([min(Time) max(Time)]);
%         ylim([0 3000]);
        xlabel('t [s]');ylabel('Eval');
        % xticks([-50:20:200]);yticks([-20:20:20])
        %---テンプレ部分---%
        ax.FontSize = obj.FontSize;
        ax.FontName = obj.FontName;
        ax.FontWeight = obj.FontWeight;
        hold off
        exportgraphics(ax,strcat('Covxv','.pdf'));
        movefile(strcat('Covxv','.pdf'),obj.SaveDateStr);
        exportgraphics(ax,strcat('Covxv','.emf'));
        movefile(strcat('Covxv','.emf'),obj.SaveDateStr);
        FigNum = FigNum + 1;
        %---------------------%
else
    disp(strcat('we do not disp Evals'));
end