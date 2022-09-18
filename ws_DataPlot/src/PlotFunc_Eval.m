function [FigNum] = PlotFunc_Eval(obj,param)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840;0.9010 0.7450 0.9330;0.4010 0.7450 0.4330];
FigNum = 0;
%plant(true)
%[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.Eval');
[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.eachfval');
if vFlag
    %Time
    %Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    Time = obj.logger.data(0,'t',[]);
    %under code make figure
    figure();
    hold on;
    ax = gca;
    %     set(gca,'TickLabelInterpreter','latex')
    grid on
%     axis equal
    fn = fieldnames(EvalData(1));
    %for vidx = 1:length(fn);%:-1:1
%        %plot(Time,[EvalData.(fn{vidx})],'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx,:));
        %plot(Time,EstVData(vidx,:),'Linewidth',3,'LineStyle','-','Color',plotcolor(vidx,:));
        %ltext(vidx) = string(fn{vidx});
    %end
    plot(Time,[EvalData.(fn{1})].*[EvalData.(fn{5})],'Linewidth',3,'LineStyle','-','Color',plotcolor(1,:));
    plot(Time,[EvalData.(fn{2})],'Linewidth',3,'LineStyle','-','Color',plotcolor(2,:));
    plot(Time,[EvalData.(fn{3})],'Linewidth',3,'LineStyle','-','Color',plotcolor(3,:));
    plot(Time,[EvalData.(fn{4})],'Linewidth',3,'LineStyle','-','Color',plotcolor(4,:));
    xlabel('t [s]','Interpreter','latex');ylabel('Evaluation value','Interpreter','latex');
    %legend('Eval1','Eval2','Eval3','Eval4','Location','northoutside','NumColumns',3,'Interpreter','latex')
    is_area=[0,Time(reshape([param;param],[1,2*length(param)]))',Time(end)];
    is_area_v = repmat([0 0 100 100],1,length(is_area)/2);
    area(is_area,is_area_v(1:length(is_area)),'FaceColor','#EEAAAA','FaceAlpha',0.5,'EdgeColor','none');
    ltext = ["Estimation","Terminal","Stage","Input","Insufficient Area"];
    legend(ltext,'Location','northoutside','NumColumns',3,'Interpreter','latex')
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    ylim([0,60]);
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