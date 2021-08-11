%% 鳥とドローンの移動軌跡
% clear all;
% close all;
addpath 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\YF\Cov'
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\video\data'

   savecount = dir('*.mat');
    text = [num2str(length(savecount)-1)];
% load('15.mat')% clear all
% load(text)% clear all

% load('C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\video\data\12')
% 




count = length(yasui.save.agent{1, 1}.state);
N = length(yasui.save.agent);
mb =50;pb =7;
fp = yasui.fp;
xmin = fp(1)-mb;
ymin = fp(2)-mb;
xmax = fp(1)+pb;
ymax = fp(2)+pb;

%% 軌跡のプロット
figure(8)
%畑のプロット
farmx = fp(1);
farmy = fp(2);
xb=5;
yb=5;
x = [farmx+xb farmx+xb farmx-xb farmx-xb];
y = [farmy-yb farmy+yb farmy+yb farmy-yb];
s = fill(x,y,[(64/255),(64/255),(64/255)],'FaceAlpha',.2,'EdgeAlpha',.2);
s.Annotation.LegendInformation.IconDisplayStyle = 'off'; % step プロットの凡例の非表示設定
hold on;
leg = legend
leg.AutoUpdate = 'off'
for i=1:N%N機目はドローン
 if i>Nb
        %ドローン用
%         txt = ['Drone'];
% %         plot(yasui.save.agent{i}.state(1,:),yasui.save.agent{i}.state(2,:),'-','LineWidth',2,'DisplayName',txt,'Color','r'); 
%         plot(yasui.save.agent{i}.state(1,:),yasui.save.agent{i}.state(2,:),'*','LineWidth',2,'DisplayName',txt,'Color','r'); 

 else
  txt = ['Birds',num2str(i)];%%数字を文字に変換して
  plot(yasui.save.agent{i}.state(1,:),yasui.save.agent{i}.state(2,:),'--','LineWidth',2,'Color',[(255-10*i)/255 (10*i)/255 (255-5*i)/255],'DisplayName',txt);
 end
  
end
leg = legend
leg.AutoUpdate = 'on';
leg.FontSize =16;
leg.Location = 'southeast';
plot(1000,1000,'r','Displayname','Drone');
plot(1000,1000,'--','Displayname','Pset birds');
hold off; grid on; axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%軸の設定等々%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
span = 5;%秒数
xlim([round(xmin,-1) round(xmax,-1)])
ylim([round(ymin,-1) round(ymax,-1)])
% xticks([xmin:10:round(xmax,-1)]);
% yticks([ymin:10:round(ymax,-1)]);
% xticklabels(0:span:length(temp)*dt);
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

