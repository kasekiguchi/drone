function [FigNum] = PlotFunc_MapAndVehicleTrueAndEst(obj,FigNum)
%% robot State
[~,PlantDim,PlantData,Flag] = FindDataMatchName(obj.logger,'plant.state.p');
if Flag
    %estimation
    [~,EstDim,EstData] = FindDataMatchName(obj.logger,'estimator.result.state.p');
    if ~PlantDim ==EstDim
        error('Dimention is not match');
    end
    [~,PlantqDim,PlantqData,~] = FindDataMatchName(obj.logger,'plant.state.q');
    [~,EstqDim,EstqData] = FindDataMatchName(obj.logger,'estimator.result.state.q');
    if ~PlantqDim == EstqDim
        error('Dimention is not match');
    end
    %Time
    Time = cell2mat(arrayfun(@(N) obj.logger.Data.t(N),1:size(obj.logger.Data.t,1),'UniformOutput',false));
%% Map State
%estimate map x
tmp = regexp(obj.logger.items,'estimator.result.map_param.x');
tmp = cellfun(@(c) ~isempty(c),tmp);
tmpIndex = find(tmp);
MapDatax = obj.logger.Data.agent{end,tmpIndex};
MapDimx = size(MapDatax,1);
%estimate map y
tmp = regexp(obj.logger.items,'estimator.result.map_param.y');
tmp = cellfun(@(c) ~isempty(c),tmp);
tmpIndex = find(tmp);
MapDatay = obj.logger.Data.agent{end,tmpIndex};
MapDimy = size(MapDatay,1);

%plant map
tmp = regexp(obj.logger.items,'env.Floor.param.Vertices');
tmp = cellfun(@(c) ~isempty(c),tmp);
Index = find(tmp);
MapIdx = size(obj.logger.Data.agent{1,Index},3);
for ei = 1:MapIdx
    tmpenv(ei) = polyshape(obj.logger.Data.agent{1,Index}(:,:,ei));
end
p_Area = union(tmpenv(:));

%make figure
figure(FigNum)
hold on;
ax = gca;

tmp_max = max(obj.logger.Data.agent{1,Index});
tmp_min = min(obj.logger.Data.agent{1,Index});
% xmin = min(tmp_min(:,1,:));
xmin = -30;
dx = 10;
% xmax = max(tmp_max(:,1,:));
xmax = 70;
% ymin = min(tmp_min(:,2,:));
ymin = -30;
dy = 10;
% ymax = max(tmp_max(:,2,:));
ymax = 30;



Wall = plot(p_Area,'FaceColor','red','FaceAlpha',0.1);
for i=1:MapDimx
    PlotMap = plot([MapDatax(i,1),MapDatax(i,2)],[MapDatay(i,1),MapDatay(i,2)],'LineWidth',5,'Color','r');
end
%plantFinalState
PlantFinalState = PlantData(:,end);
PlantFinalStatesquare = PlantFinalState + 2.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
PlantFinalStatesquare =  polyshape( PlantFinalStatesquare');
PlantFinalStatesquare =  rotate(PlantFinalStatesquare,180 * PlantqData(end) / pi, PlantData(:,end)');
PlotFinalPlant = plot(PlantFinalStatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
%modelFinalState
EstFinalState = EstData(:,end);
EstFinalStatesquare = EstFinalState + 2.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
EstFinalStatesquare =  polyshape( EstFinalStatesquare');
EstFinalStatesquare =  rotate(EstFinalStatesquare,180 * EstqData(end) / pi, EstData(:,end)');
PlotFinalEst = plot(EstFinalStatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
%
PlotPlant = plot(PlantData(1,:),PlantData(2,:),'Color',[0.5020,0.5020,0.5020],'LineWidth',5);
PlotEst = plot(EstData(1,:),EstData(2,:),'Color',[0.0745,0.6235,1.0000],'LineWidth',4);

legend([PlotPlant PlotEst PlotFinalPlant PlotFinalEst Wall PlotMap],'Plant Trajectory','Estimated Trajectory','Plant','Estimate','Wall','EstimateMap','Location','northoutside','NumColumns',2);
%setting
grid on;
xlim([xmin xmax]);ylim([ymin ymax]);
xticks([xmin:dx:xmax]);yticks([ymin:dy:ymax]);
pbaspect([abs(xmin -xmax) abs(ymin -ymax) 1]);
% axis equal;
% xlim([-50 200]);ylim([-20 20]);
xlabel('x [m]');ylabel('y [m]');
% xticks([-50:20:200]);yticks([-20:20:20])
%---テンプレ部分---%
    ax.FontSize = obj.FontSize;
    ax.FontName = obj.FontName;
    ax.FontWeight = obj.FontWeight;
    hold off
    exportgraphics(ax,strcat('MapAndTrajectry','.pdf'));
    movefile(strcat('MapAndTrajectry','.pdf'),obj.SaveDateStr);
    exportgraphics(ax,strcat('MapAndTrajectry','.emf'));
    movefile(strcat('MapAndTrajectry','.emf'),obj.SaveDateStr);
    FigNum = FigNum + 1;
    %---------------------%
else
    disp(strcat('we do not disp Map'));
end