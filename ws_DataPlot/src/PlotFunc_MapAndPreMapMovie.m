function [FigNum] = PlotFunc_MapAndPreMapMovie(obj,FigNum)
%% Robot State
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
    %% Pre Map State
    %estimate map x
    tmp = regexp(obj.logger.items,'estimator.result.PreMapParam.x');
    tmp = cellfun(@(c) ~isempty(c),tmp);
    PreMapXIndex = find(tmp);
    %estimate map y
    tmp = regexp(obj.logger.items,'estimator.result.PreMapParam.y');
    tmp = cellfun(@(c) ~isempty(c),tmp);
    PreMapYIndex = find(tmp);
    %% Map State
    %estimate map x
    tmp = regexp(obj.logger.items,'estimator.result.map_param.x');
    tmp = cellfun(@(c) ~isempty(c),tmp);
    MapXIndex = find(tmp);
    %estimate map y
    tmp = regexp(obj.logger.items,'estimator.result.map_param.y');
    tmp = cellfun(@(c) ~isempty(c),tmp);
    MapYIndex = find(tmp);
    
    %plant map
    tmp = regexp(obj.logger.items,'env.Floor.param.Vertices');
    tmp = cellfun(@(c) ~isempty(c),tmp);
    Index = find(tmp);
    MapIdx = size(obj.logger.Data.agent{1,Index},3);
    for ei = 1:MapIdx
        tmpenv(ei) = polyshape(obj.logger.Data.agent{1,Index}(:,:,ei));
    end
    p_Area = union(tmpenv(:));
    %% Movie plot
    msi = size(obj.logger.Data.t,1);
    %Map plot start
    figure(FigNum)
    hold on;
    ax = gca;
    % Animation Loop
    mo_t = 1;
    tmp_max = max(obj.logger.Data.agent{1,Index});
    tmp_min = min(obj.logger.Data.agent{1,Index});
    xmin = min(tmp_min(:,1,:));
    dx = 10;
    xmax = max(tmp_max(:,1,:));
    ymin = min(tmp_min(:,2,:));
    dy = 10;
    ymax = max(tmp_max(:,2,:));
    
    v = VideoWriter(strcat('SLAM_MAPplot.avi'));
    open(v);
    while mo_t <= msi
        clf(figure(FigNum));
        xlim([xmin xmax]);ylim([ymin ymax]);
        xticks([xmin:dx:xmax]);yticks([ymin:dy:ymax]);
        %     set(gca,'FontSize',20);
        xlabel('\sl x \rm [m]','FontSize', 15);
        ylabel('\sl y \rm [m]','FontSize',15);
        hold on
        grid on;
        box on
%         ax.FontSize = obj.FontSize;
%         ax.FontName = obj.FontName;
%         ax.FontWeight = obj.FontWeight;
        %         pbaspect([250 50 1]);
        %     axis equal
        %plot
        %     logger.Data.agent{mot,4}(:,1)
        %------estimation map plot-------------%
        MapDatax = obj.logger.Data.agent{mo_t,MapXIndex};
        MapDimx = size(MapDatax,1);
        MapDatay = obj.logger.Data.agent{mo_t,MapYIndex};
        %         MapDimy = size(MapDatay,1);
        for i=1:MapDimx
            plot([MapDatax(i,1),MapDatax(i,2)],[MapDatay(i,1),MapDatay(i,2)],'LineWidth',2,'Color','r');
        end
        %--------------------------------------%
        %------Pre estimation map plot--------%
        PreMapDatax = obj.logger.Data.agent{mo_t,PreMapXIndex};
        PreMapDimx = size(PreMapDatax,1);
        PreMapDatay = obj.logger.Data.agent{mo_t,PreMapYIndex};
        %         MapDimy = size(MapDatay,1);
        for i=1:PreMapDimx
            plot([PreMapDatax(i,1),PreMapDatax(i,2)],[PreMapDatay(i,1),PreMapDatay(i,2)],'LineWidth',1,'Color','b');
        end
        %-----------------------------------%
        %plant plot%
        tmp_plant_square = PlantData(:,mo_t) + [1,1.5,1,-1,-1;1,0,-1,-1,1];
        plant_square =  polyshape( tmp_plant_square');
        plant_square =  rotate(plant_square,180 * PlantqData(mo_t) / pi, PlantData(:,mo_t)');
        fig6(2) = plot(plant_square);
        %-------------%
        
        %model plot%
        tmp_model_square = EstData(:,mo_t) + [1,1.5,1,-1,-1;1,0,-1,-1,1];
        model_square =  polyshape( tmp_model_square');
        model_square =  rotate(model_square,180 * EstqData(mo_t) / pi, EstData(:,mo_t)');
        fig6(3) = plot(model_square);
        %-------------%
        fig6(4) = plot(p_Area,'FaceColor','red','FaceAlpha',0.1);% true map plot
        fig6(5) = plot(polybuffer([PlantData(1,mo_t),PlantData(2,mo_t)],'points',40),'FaceColor','blue','FaceAlpha',0.1);%Raser plot
        hold off
        pause(16 * 1e-2);
        mo_t = mo_t+1;
        frame = getframe(figure(FigNum));
        writeVideo(v,frame);
    end
    close(v);
    movefile(strcat('SLAM_MAPplot.avi'),obj.SaveDateStr);
    disp('simulation ended')
    FigNum = FigNum + 1;
end