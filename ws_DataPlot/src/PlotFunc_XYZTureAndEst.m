function [FigNum,Ax] = PlotFunc_XYZTureAndEst(obj,FigNum)
labelstr = ['x','y','z'];
%plant(true)
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.state.p');
if Flag
%estimation
[~,EstDim,EstData] = FindDataMatchName(obj.logger,'estimator.result.state.p');
if ~PlantDim ==EstDim
    error('Dimention is not match');
end
%Time
Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
for pidx = 1:PlantDim
figure(FigNum)
% figcf = gcf;
hold on;
ax = gca;
grid on
axis equal
plot(Time,PlantData(pidx,:),'Linewidth',5);
plot(Time,EstData(pidx,:),'Linewidth',3);
grid on;
axis equal;
xlabel('t [s]');ylabel(strcat(labelstr(pidx),'[m]'));
legend('plant','estimate')
ax.FontSize = obj.FontSize;
ax.FontName = obj.FontName;
ax.FontWeight = obj.FontWeight;
hold off

exportgraphics(ax,strcat('fig',labelstr(pidx),'.pdf'));
movefile(strcat('fig',labelstr(pidx),'.pdf'),obj.SaveDateStr);
exportgraphics(ax,strcat('fig',labelstr(pidx),'.emf'));
movefile(strcat('fig',labelstr(pidx),'.emf'),obj.SaveDateStr);

FigNum = FigNum + 1;
end
else
    disp(strcat('we do not disp XYZ TureAndEst'));
end