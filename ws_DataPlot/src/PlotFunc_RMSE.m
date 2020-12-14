function [FigNum] = PlotFunc_RMSE(obj,FigNum)
%Plant
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.state.p');
if Flag
%Estimation;
[~,~,EstData,~] = FindDataMatchName(obj.logger,'estimator.result.state.p');
rmse = zeros(PlantDim,1);
for ri = 1:PlantDim
    rmse(ri) = sqrt(sum((EstData(ri,:) - PlantData(ri,:)).^2)/length(EstData(ri,:)));
end

%plant(true)
[~,PlantqDim,PlantqData,Flag] = FindDataMatchName(obj.logger,'plant.state.q');
if Flag
%estimation
[~,~,EstqData,~] = FindDataMatchName(obj.logger,'estimator.result.state.q');
qrmse = zeros(PlantqDim,1);
for ri = 1:PlantqDim
    qrmse(ri) = sqrt(sum((EstqData(ri,:) - PlantqData(ri,:)).^2)/length(EstqData(ri,:)));
end
figure(7)
hold on;
ax = gca;
yyaxis left
bxy = bar(1:2,[rmse(1),rmse(2)],'r');
yyaxis right
bq = bar(3,[qrmse],'b');
ax.FontSize = obj.FontSize;
ax.FontName = obj.FontName;
ax.FontWeight = obj.FontWeight;
hold off

exportgraphics(ax,strcat('RMSE','.pdf'));
movefile('RMSE.pdf',obj.SaveDateStr);
exportgraphics(ax,'RMSE.emf');
movefile('RMSE.emf',obj.SaveDateStr);
else
    disp('We do not calculate RMSE');
end
end