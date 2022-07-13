function [FigNum] = PlotFunc_TrackMPCEval(obj,FigNum)
%% robot State
tmp = regexp(obj.logger.items,'controller.result.eachfval');
tmp = cellfun(@(c) ~isempty(c),tmp);
Index = find(tmp);
if isempty(Index)
    Flag = false;
    data = 0;
else
    Flag = true;
    data = cell2mat(arrayfun(@(N) obj.logger.Data.agent{N,Index},1:size(obj.logger.Data.t,1),'UniformOutput',false));
end
if Flag
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    % make datas
    Names = fieldnames(data);
    NameSize = size(Names,1);
    Data = cell(1,NameSize);
    for ni = 1:NameSize
        Data{1,ni} = arrayfun(@(N) data(N).(Names{ni}),1:size(obj.logger.Data.t,1));
    end
    
    % color code
    ColorCodes = [0.3922,0.8314,0.0745;...
                   0.3020,0.7451,0.9333;...
                   0.8510,0.3255,0.0980;...
                   0.4941,0.1843,0.5569;...
                   0.3922,0.8314,0.0745];
    %make figure
    for fi = 1:NameSize
        figure(FigNum)
        hold on;
        ax = gca;        
        plot(Time(1,:),Data{1,fi}(:),'Color',ColorCodes(fi,:),'LineWidth',5);
        legend(Names{fi},'Location','northoutside','NumColumns',2);
        %setting
        grid on;
        % xlim([xmin xmax]);ylim([ymin ymax]);
        % xticks([xmin:dx:xmax]);yticks([ymin:dy:ymax]);
        % pbaspect([abs(xmin -xmax) abs(ymin -ymax) 1]);
        % axis equal;
        xlim([min(Time) max(Time)]);
%         ylim([0 5]);
        xlabel('t [s]');ylabel('Eval');
        % xticks([-50:20:200]);yticks([-20:20:20])
        %---テンプレ部分---%
        ax.FontSize = obj.FontSize;
        ax.FontName = obj.FontName;
        ax.FontWeight = obj.FontWeight;
        hold off
        exportgraphics(ax,strcat(Names{fi},'.pdf'));
        movefile(strcat(Names{fi},'.pdf'),obj.SaveDateStr);
        exportgraphics(ax,strcat(Names{fi},'.emf'));
        movefile(strcat(Names{fi},'.emf'),obj.SaveDateStr);
        FigNum = FigNum + 1;
        %---------------------%
    end
else
    disp(strcat('we do not disp Evals'));
end