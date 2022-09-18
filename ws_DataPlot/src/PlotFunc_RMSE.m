function [FigNum] = PlotFunc_RMSE(obj,FigNum,prename)
%Plant
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.result.state.p');
if Flag
%Estimation;
[~,~,EstData,~] = FindDataMatchName(obj.logger,'estimator.result.state.p');
rmse = zeros(PlantDim,1);
for ri = 1:PlantDim
    rmse(ri) = sqrt(sum((EstData(ri,:) - PlantData(ri,:)).^2)/length(EstData(ri,:)));
end

%plant(true)
[~,PlantqDim,PlantqData,Flag] = FindDataMatchName(obj.logger,'plant.result.state.q');
if Flag
%estimation
[~,~,EstqData,~] = FindDataMatchName(obj.logger,'estimator.result.state.q');
qrmse = zeros(PlantqDim,1);
for ri = 1:PlantqDim
    qrmse(ri) = sqrt(sum((EstqData(ri,:) - PlantqData(ri,:)).^2)/length(EstqData(ri,:)));
end
figure(FigNum)
hold on;
ax = gca;
set(gca,'TickLabelInterpreter','latex')
yyaxis left
[0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840];
bxy = bar(1,[rmse(1)],'Facecolor',[0 0.4470 0.7410]);
bxy = bar(2,[rmse(2)],'Facecolor',[0.8500 0.3250 0.0980]);
ylabel('RMSE of position','Interpreter','latex');
yyaxis right
bq = bar(3,[qrmse],'Facecolor',[0.4660 0.6740 0.1880]);
ylabel('RMSE of attitude','Interpreter','latex');
xticks([1 2 3])
xticklabels({'$x$','$y$','$\theta$'})
HYaxis = ax.YAxis;
HYaxis(1).Color = 'k'; %  左軸ラベルの色変更
HYaxis(2).Color = 'k'; %  右軸ラベルの色変更
ax.FontSize = obj.FontSize;
ax.FontName = obj.FontName;
ax.FontWeight = obj.FontWeight;
hold off
[rmse;qrmse]
exportgraphics(ax,strcat(prename,'RMSE','.pdf'));
movefile(strcat(prename,'RMSE.pdf'),obj.SaveDateStr);
% exportgraphics(ax,'RMSE.emf');
% movefile('RMSE.emf',obj.SaveDateStr);
FigNum = FigNum + 1;
else
    disp('We do not calculate RMSE');
end
end