%% 鳥とドローンの距離をやる
clear bird_drone;
clear bird_dronemin;
close all;
clear dis
addpath 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\YF\Cov'
%%
cd('C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\video\data\success')
% load('16.mat')

dt = 0.1;
fp = yasui.fp;
count = length(yasui.save.agent{1, 1}.state);
N = length(yasui.save.agent);
for i=1:N-1%N機目はドローン
    for j=1:count
        for k=1:N-1
            %     dis{i,1}(j) = Cov_distance(yasui.save.agent{i}.state(1:2,j),fp,1);
            tmp = Cov_distance(yasui.save.agent{i}.state(1:2,j),yasui.save.agent{k}.state(1:2,j),1);
            dx{i,1}(j,k) = tmp.dx;
            dy{i,1}(j,k) = tmp.dy;
            dis{i,1}(k,j) = tmp.result;
        end
    end
end
%% 距離のプロット
figure(6)
plot(temp)
dis_birds = plot(temp);
dis_birds.Color = 'b';dis_birds.LineWidth = 2;
dis_birds.DisplayName='The closest bird';
hold on;grid on;
% dis_birds = plot(abs(pdx));
% dis_birds.Color = 'g';dis_birds.LineWidth = 2;
% hold on;grid on;
% dis_birds = plot(abs(pdy));
% dis_birds.Color = 'b';dis_birds.LineWidth = 2;
dis_drone = plot(tmp_drone);
dis_drone.Color = 'r';dis_drone.LineWidth = 2;
dis_drone.DisplayName='The drone';
% hline = refline(0,5);%%横棒
% hline.Color = 'r'; hline.LineWidth = 2;%%横棒設定
% hline = refline(0,5*sqrt(2));%%横棒
% hline.Color = 'm'; hline.LineWidth = 2;%%横棒設定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%軸の設定等々%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
span = 5;%秒数
temp =dis_birds.YData;
xlim([1 length(temp)])
% ylim([0 max(temp)+1])
xticks([0:span*10:length(temp)]);
xticklabels(0:span:length(temp)*dt);
xlabel('{\sl T} [s]','FontName','Times New Roman','FontSize',24)
ylabel('Distance [m]','FontName','Times New Roman','FontSize',24)
all = 0; 
ax = gca;
ax.FontSize = 24;
hold off 


figure(7)
dis_drone = plot(bird_dronemin);
dis_drone.Color = 'r';dis_drone.LineWidth = 2;
dis_drone.DisplayName='Minimum distance';
span = 3;%秒数
temp =dis_birds.YData;
xlim([1 length(temp)])
% ylim([0 max(temp)+1])
xticks([0:span*10:length(temp)]);
xticklabels(0:span:length(temp)*dt);
xlabel('{\sl T} [s]','FontName','Times New Roman','FontSize',24)
ylabel('Distance [m]','FontName','Times New Roman','FontSize',24)
all = 0; 
ax = gca;
ax.FontSize = 24;
grid on;

lgd = legend;
lgd.FontSize = 14;
fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

