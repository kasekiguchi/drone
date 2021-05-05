%% plot file

figure(1);
hold on;
grid on;
p1 = plot(GridX,GridY,'bo');
MapDimx = size(obj.MapParam.x,1);
for i=1:MapDimx
    plot([obj.MapParam.x(i,1),obj.MapParam.x(i,2)],[obj.MapParam.y(i,1),obj.MapParam.y(i,2)],'LineWidth',2,'Color','r');
end


hold off

