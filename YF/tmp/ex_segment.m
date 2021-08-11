close all;
clear all;
a = randi([-5 5],1,30);
b = randi([-5 5],1,30);
c = zeros(1,30);
loc1 = [a(:),b(:),c(:)];
a = randi([-5 5],1,40);
b = randi([-5 5],1,40);
c = zeros(1,40);
loc2 = [a(:),b(:),c(:)];
ptCloud = pointCloud([loc1;loc2]);
% pcshow(ptCloud)
figure;scatter3(ptCloud.Location(:,1),ptCloud.Location(:,2),ptCloud.Location(:,3))
% title('Point Cloud')
minDistance = 1.5;
[labels,numClusters] = pcsegdist(ptCloud,minDistance);
xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
all = 0;
ax = gca;
ax.FontSize = 24;
view(2)
xlim([-5.5 5.5]);ylim([-5.5 5.5]);
axis square
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

exportsetupdlg
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'
%%
figure;hold on;grid on; axis equal;
color_range = ['m','r','g','b','w','k'];
for i=1:length(labels)
%     if labels(i)==1
        scatter3(ptCloud.Location(i,1),ptCloud.Location(i,2),ptCloud.Location(i,3),color_range(labels(i)))
        hold on
%     else
%         scatter3(ptCloud.Location(i,1),ptCloud.Location(i,2),ptCloud.Location(i,3),'r')
%     end
end
xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
all = 0;
ax = gca;
ax.FontSize = 24;
xlim([-5.5 5.5]);ylim([-5.5 5.5]);
axis square
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'

% pcshow(ptCloud.Location,labels)
% colormap(hsv(numClusters))
% title('Point Cloud Clusters')