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
[~,EstDim,EstData] = FindDataMatchName(obj.logger,'estimator.result.state.map_param.x');
[~,EstDim,EstData] = FindDataMatchName(obj.logger,'estimator.result.state.map_param.y');
% x_s = agent.estimator.ekfslam_WC.map_param.x(:,1);
% x_e = agent.estimator.ekfslam_WC.map_param.x(:,2);
% y_s = agent.estimator.ekfslam_WC.map_param.y(:,1);
% y_e = agent.estimator.ekfslam_WC.map_param.y(:,2);
[~,EstDim,EstData] = FindDataMatchName(obj.logger,'env.Floor.param.Vertices');
s_xy = [x_s,y_s];
e_xy = [x_e,y_e];
si = size(x_s,1);
figure(5)
hold on;
ax = gca;
SOE = size(Env.param.Vertices,3);
for ei = 1:SOE
    tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei));
end
p_Area = union(tmpenv(:));
% p_Area = polyshape(Env.param.Vertices());
plot(p_Area);

for i=1:si
    plot([x_s(i),x_e(i)],[y_s(i),y_e(i)],'LineWidth',5,'Color','r');
end
plot(model_data(1,end),model_data(2,end),'b>');
plot(plant_data(1,end),plant_data(2,end),'g>');
grid on;
axis equal;
% xlim([-50 200]);ylim([-20 20]);
xlabel('x [m]');ylabel('y [m]');
xticks([-50:20:200]);yticks([-20:20:20])
ax.FontSize = 15;
hold off
end