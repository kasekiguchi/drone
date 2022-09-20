function [FigNum] = PlotFunc_Eval(obj,param,prename,trange)
plotcolor = [0.3010 0.7450 0.9330;0.6010 0.8450 0.7330;0.6350 0.0780 0.1840;0.9010 0.7450 0.9330;0.4010 0.7450 0.4330];
FigNum = 0;
%plant(true)
%[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.Eval');
[~,EvalDim,EvalData,vFlag] = FindDataMatchName(obj.logger,'controller.result.eachfvalp');
if vFlag
    %Time
    %Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
    Time = obj.logger.data(0,'t',[],"ranget",trange);
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
    EvalData = EvalData(1:length(Time));

    param(param>=length(Time)) = [];
    is_area=[0,Time(reshape([param;param],[1,2*length(param)]))',Time(end)];
    is_area_v = repmat([0 0 200 200],1,length(is_area)/2);
    area(is_area,is_area_v(1:length(is_area)),'FaceColor','#EEAAAA','FaceAlpha',0.5,'EdgeColor','none');
    plot(Time,[EvalData.(fn{2})],'Linewidth',3,'LineStyle','-','Color',plotcolor(2,:));
    plot(Time,[EvalData.(fn{3})],'Linewidth',3,'LineStyle','-','Color',plotcolor(3,:));
    plot(Time,[EvalData.(fn{4})],'Linewidth',3,'LineStyle','-','Color',plotcolor(4,:));
    plot(Time,[EvalData.(fn{1})],'Linewidth',3,'LineStyle','-','Color',plotcolor(1,:));
    % dummy
    area(is_area,is_area_v(1:length(is_area))*0,'FaceColor','#EEAAAA','FaceAlpha',0.5,'EdgeColor','none');
    xlabel('t [s]','Interpreter','latex');ylabel('Evaluation value','Interpreter','latex');
    %legend('Eval1','Eval2','Eval3','Eval4','Location','northoutside','NumColumns',3,'Interpreter','latex')
    ltext = ["","Terminal","Stage","Input","Estimation","Insufficient Area"];
    legend(ltext,'Location','northoutside','NumColumns',3,'Interpreter','latex');
    xlim([Time(1),Time(end)]);
    ylim([0,200]);
    %---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    pbaspect([3 1 1]);
    %ylim([0,100]);
    hold off
    exportgraphics(ax,strcat(prename,'Eval','.pdf'));
    movefile(strcat(prename,'Eval','.pdf'),obj.SaveDateStr);
%     exportgraphics(ax,strcat('Eval','.emf'));
%     movefile(strcat('Eval','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp Eval'));
end