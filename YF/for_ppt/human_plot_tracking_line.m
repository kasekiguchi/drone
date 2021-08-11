load = yasui.save.env;
N=length(yasui.save.agent);
PlotColor = ['r';'b';'g'];
close all;
Feald = yasui.save.env.Vertices;
    xmin = min(Feald(:,1))-1;
    ymin = min(Feald(:,2))-1;
    xmax = max(Feald(:,1))+1;
    ymax = max(Feald(:,2))+1;
dronesize = 0.2;
AllXd = cell2mat(arrayfun(@(i) yasui.save.agent{i}.RefarenceLabels,1:length(yasui.save.agent),'Uniformoutput',false));
XdLabels = unique(AllXd','rows')';
%%
axis equal;
view(2)
axis equal;
scatter(1000,1000,'k','Displayname','Human');
hold on
leg = legend
leg.AutoUpdate = 'off'
plot(load,'Facecolor','none')
hold on; axis equal;grid on;
PlotTime = 60;
for hh =1:N
    if yasui.save.agent{hh}.RefarenceLabels==XdLabels(:,1)
        pgon1 = viscircles([(yasui.save.agent{hh}.state(1,PlotTime*(1/yasui.dt)+1)),(yasui.save.agent{hh}.state(2,PlotTime*(1/yasui.dt)+1))],dronesize ,'color','b');
        %                    quiver((yasui.save.agent{hh}.state(1,1)),(yasui.save.agent{hh}.state(2,1)),yasui.save.agent{hh}.u(1,1)*2,yasui.save.agent{hh}.u(2,1)*2,'LineWidth',2,'MarkerSize',10)
    else
        pgon1 = viscircles([(yasui.save.agent{hh}.state(1,PlotTime*(1/yasui.dt)+1)),(yasui.save.agent{hh}.state(2,PlotTime*(1/yasui.dt)+1))],dronesize ,'color','r');
        %                    quiver((yasui.save.agent{hh}.state(1,1)),(yasui.save.agent{hh}.state(2,1)),yasui.save.agent{hh}.u(1,1)*2,yasui.save.agent{hh}.u(2,1)*2,'LineWidth',2,'MarkerSize',10)
        
    end
end



axis([xmin xmax ymin ymax]);

xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
all = 0;
ax = gca;
ax.FontSize = 20;

leg = legend
leg.AutoUpdate = 'on';
leg.FontSize =16;
leg.Box = 'off'
leg.Location = 'eastoutside'

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'
hold off;
