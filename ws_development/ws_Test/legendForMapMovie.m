%% 凡例plot用
figure('Color','w')
hold on
ax = gca;
tmp_plant_square = [0;0] + [1,1.5,1,-1,-1;1,0,-1,-1,1];
plant_square =  polyshape( tmp_plant_square');
plant_square =  rotate(plant_square,180 * pi / pi, [0;0]');
PlotPlant = plot(plant_square,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
Plotref = plot(0,0,'Color',[0.8588,0.3882,0.2314],'Marker','o','LineWidth',2);
TraP = plot([0 1],[2 3],'Color',[0.0745,0.6235,1.0000],'LineStyle','-','LineWidth',4);
p_Area = polybuffer([0,0],'points',0.1);
Environment = plot(p_Area,'FaceColor','red','FaceAlpha',0.1);
SensorLine = plot(p_Area,'FaceColor',[0.2235,0.6784,0.1216]);
PlotMap = plot([0,1],[2,3],'LineWidth',2,'Color','r');
ax.FontSize = 15;
legend([PlotPlant Plotref TraP Environment SensorLine PlotMap],'Robot','reference','Robot Trajectory','Environment','Laser Sensor','Estimate Map','Location','northoutside','NumColumns',4);