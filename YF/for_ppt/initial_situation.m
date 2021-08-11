figure
% clear all;
%%
% cd('C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\video\data\success')
% load('16.mat')
n=yasui.main_roop_count;
N=length(yasui.save.agent);
Nb=yasui.Nb;
fp=yasui.fp;
close all;
i = 0;
span = 14;
pt = 3+(span*10)*i;
% pt = 1201
mb = 50;
pb = 50;
xmin = fp(1)-20;
ymin = fp(2)-70;
xmax = fp(1)+50;
ymax = fp(2)+50;

dronesize = 1.;
birdsize = 2.5;
cogsize = 0.04;

%%
farmx = fp(1);
farmy = fp(2);
xb=5;
yb=5;
x = [farmx+xb farmx+xb farmx-xb farmx-xb];
y = [farmy-yb farmy+yb farmy+yb farmy-yb];

fill(x,y,[(64/255),(64/255),(64/255)],'FaceAlpha',.2,'EdgeAlpha',.2,'Displayname','Farm')

hold on; grid on;
leg = legend
leg.AutoUpdate = 'off'
for hh =1:N
    if hh>Nb
%         if hh == N
%             pgon1 = viscircles([(yasui.save.agent{hh}.state(1,pt)),(yasui.save.agent{hh}.state(2,pt))],dronesize,'Color','b');
%         else
%             
            pgon1 = viscircles([(yasui.save.agent{hh}.state(1,pt)),(yasui.save.agent{hh}.state(2,pt))],dronesize);
            %         plot(pgon1);
%         end
    else
%         if hh==Nb
%             pgon1 = nsidedpoly(3,'Center',[(yasui.save.agent{hh}.state(1,pt)),(yasui.save.agent{hh}.state(2,pt))],'SideLength',birdsize);
%             plot(pgon1,'Facecolor',[(0/255),(255/255),(0/255)]);
%             
%         else
            pgon1 = nsidedpoly(3,'Center',[(yasui.save.agent{hh}.state(1,pt)),(yasui.save.agent{hh}.state(2,pt))],'SideLength',birdsize);
            plot(pgon1,'Facecolor',[(70/255),(130/255),(190/255)]);
            
%         end
    end
end
leg = legend
leg.AutoUpdate = 'on';
leg.FontSize =16;
leg.Location = 'southeastoutside';
k = plot(1000,1000,'k:^','Displayname','Psetbirds','MarkerFaceColor',[(70/255),(130/255),(150/255)]);
k. LineWidth = 0.00001;
q = scatter(1000,1000,'o','r','Displayname','Drone');
q.LineWidth = 2;
hold off;

hold off;grid on;
axis([xmin xmax ymin ymax]);
axis equal
% pbaspect([abs(xmin)+abs(xmax) abs(ymin)+abs(ymax) 1])
xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
all = 0;
ax = gca;
ax.FontSize = 24;



fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'

