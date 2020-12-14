%% 事前処理
close all
PlotColor = ['r','b','c','m','g','k','y'];

data = cell(N,1);
for k=1:N
    data{k}(1,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,1,k}(1) , 1:size(logger.Data.t,1),'UniformOutput',false));
    data{k}(2,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,1,k}(2) , 1:size(logger.Data.t,1),'UniformOutput',false));
    data{k}(3,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,1,k}(3) , 1:size(logger.Data.t,1),'UniformOutput',false));
end
%Dataから呼び出したとき
% for k=1:N
%     data{k}(1,:) = cell2mat(arrayfun(@(N) Data.agent{N,2,k}(1) , 1:size(Data.t,1),'UniformOutput',false));
%     data{k}(2,:) = cell2mat(arrayfun(@(N) Data.agent{N,2,k}(2) , 1:size(Data.t,1),'UniformOutput',false));
%     data{k}(3,:) = cell2mat(arrayfun(@(N) Data.agent{N,2,k}(3) , 1:size(Data.t,1),'UniformOutput',false));
% end

Area = polyshape([agent(1,1).controller.mpc_f.param.wall_width_x(1,1),agent(1,1).controller.mpc_f.param.wall_width_x(1,1),agent(1,1).controller.mpc_f.param.wall_width_x(2,1),agent(1,1).controller.mpc_f.param.wall_width_x(2,1),agent(1,1).controller.mpc_f.param.wall_width_x(2,2),agent(1,1).controller.mpc_f.param.wall_width_x(2,2),agent(1,1).controller.mpc_f.param.wall_width_x(1,1),agent(1,1).controller.mpc_f.param.wall_width_x(1,1),3,3],[3,agent(1,1).controller.mpc_f.param.wall_width_y(1,2),agent(1,1).controller.mpc_f.param.wall_width_y(1,2),agent(1,1).controller.mpc_f.param.wall_width_y(2,2),agent(1,1).controller.mpc_f.param.wall_width_y(2,2),agent(1,1).controller.mpc_f.param.wall_width_y(2,1),agent(1,1).controller.mpc_f.param.wall_width_y(1,1),-1,-1,3]);
% Area = polyshape([wall_width_x(1,1),wall_width_x(1,1),wall_width_x(2,1),wall_width_x(2,1),wall_width_x(2,2),wall_width_x(2,2),wall_width_x(1,1),wall_width_x(1,1),5,5],[3.5,wall_width_y(1,2),wall_width_y(1,2),wall_width_y(2,2),wall_width_y(2,2),wall_width_y(2,1),wall_width_y(1,1),-1,-1,3.5]);




%% position
% PlotLine = ['-','--',':','-.','-'];
Time = 0:.05:100;
%xy位置
figure(1)
hold on;
ax= gca;
fig1 = zeros(1,N);

if N==1 
    fig1(1) = plot(data{1}(1,:),data{1}(2,:),'.','Color',PlotColor(1),'Linewidth',2);
    fig1(1) = plot(data{1}(1,end),data{1}(2,end),'o','Color',PlotColor(1),'Linewidth',2);
else
for k=1:N-1
    fig1(k) = plot(data{k}(1,:),data{k}(2,:),'.','Color',PlotColor(k),'Linewidth',2);
    fig1(k) = plot(data{k}(1,end),data{k}(2,end),'o','Color',PlotColor(k),'Linewidth',2);
end
k=N;
fig1(k) = plot(logger.Data.agent{1,2,k}(1),logger.Data.agent{1,2,k}(2),'o','Color',PlotColor(k),'Linewidth',2);
end
% Area = polyshape([0,0,5,5],[-1,3.5,3.5,-1])-polyshape([wall_width_x(1,1),wall_width_x(1,1),wall_width_x(1,2),wall_width_x(1,2)][wall_width_y(1,2),wall_width_y(1,1),wall_width_y(1,1),wall_width_y(1,2)])
plot(Area,'FaceColor','red','FaceAlpha',0.1);
legend(fig1,'Drone1','Drone2','Drone3','Drone4','Drone5','Power supply','Location','northoutside','NumColumns',3);
% lgd.Numcolums = 3;
axis equal;
grid on;
xticks([-1:1:12]);yticks([-1:1:6])
% xlim([-1 12]);ylim([-1 3.5]);
xlabel('x [m]');ylabel('y [m]');
ax.FontSize = 15;
hold off;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
%%
%x position
figure(2)
hold on;
fig2 = zeros(1,N-1);
for k=1:N-1
% fig2(k) = plot(data{k}(1,:),logger.Data.t),'-','Color',PlotColor(k));
end
legend(fig2,'leader','follower');
xlabel('t');ylabel('x');
grid on;
hold off;
%%
%y position
figure(3)
hold on;
fig3 = zeros(1,N-1);
for k=1:N-1
fig3(k) = plot(1:i,Save.State(6+13*(k-1),1:i),'-','Color',PlotColor(k));
end
legend(fig3,'leader','follower');
xlabel('t');ylabel('y');
grid on;
hold off;
%%
%関数の評価値
figure(4)
hold on;
fig4 = zeros(1,N-1);
for k=1:N-1
fig4(k) = plot(1:i,Save.fval(k,1:i),'-','Color',PlotColor(k));
end
legend(fig4,'leader','follower');
xlabel('t');ylabel('Evaluation');
% axis equal;
grid on;
%%
%計算の指標のフラグ
figure(5)
hold on;
fig5 = zeros(1,N-1);
for k=1:N-1
fig5(k) = plot(1:i,Save.exitflag(k,1:i),'-','Color',PlotColor(k));
end
legend(fig5,'leader','follower');
grid on;
hold off;
%%
%distance
figure(7)
fig7 = zeros(1,N);
hold on;
ax = gca;
for k=1:N-1
fig7(k) =plot(logger.Data.t,cell2mat(arrayfun(@(i) norm([data{k}(1,i),data{k}(2,i)] - [data{k+1}(1,i),data{k+1}(2,i)]),1:length(logger.Data.t),'UniformOutput',false)),'-','Color',PlotColor(k),'LineWidth',1);
end
k=N;
fig7(k) = plot([0 100],[3 3],'k-','LineWidth',3);
fig7(k) = plot([0 100],[0.1 0.1],'k-','LineWidth',3);
legend('distance12','distance23','distance34','distance45','distance56','constraint','Location','northoutside','NumColumns',3);
grid('on');
xlim([0 50]);ylim([0 3]);
ax.FontSize = 15;
xlabel('t[s]');ylabel('Distance[m]');
hold off

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

%% ケーブルの通過した範囲
figure(11)

% plot(1:i,Save.var_final(1,1:i),'bo');
% grid on
hold on;
ax= gca;
for t = 1:length(logger.Data.t)
    for i=1:N-1
        fig11(i) = plot([data{i}(1,t) data{i+1}(1,t)],[data{i}(2,t) data{i+1}(2,t)],'LineWidth',1,'LineStyle','-','Color',PlotColor(i));hold on
    end
end
plot(Area,'FaceColor','red','FaceAlpha',0.1);
axis equal;
xticks([-1:1:12]);yticks([-1:1:3.5])
xlim([-1 5]);ylim([-1 3.5]);
legend([fig11(1),fig11(2),fig11(3),fig11(4),fig11(5)],'Cable1-2','Cable2-3','Cable3-4','Cable4-5','Cable5-6','Location','northoutside','NumColumns',3);
xlabel('x[m]');ylabel('y[m]');
% axis equal;
ax.FontSize = 15;
grid on;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
%% Initial_Position
figure(9)
hold on;
ax = gca;
fig1 = zeros(1,N);
for k=1:N
fig1(k) = plot(Save.State(5+13*(k-1),1),Save.State(6+13*(k-1),1),'o','Color',PlotColor(k),'LineWidth', 2);
end
plot(Area,'FaceColor','red','FaceAlpha',0.1);
figl  = plot( [3.0,4.0,4.0,2.5], [0,0,2.5,2.5], 'k--', 'LineWidth', 2);
legend([fig1,figl],'Drone1','Drone2','Drone3','Drone4','Drone5','Power supply','Reference path','Location','northoutside','NumColumns',3);
% axis equal;
axis equal 
xticks([-1:1:5]);yticks([-1:1:3.5])
xlim([-1 5]);ylim([-1 3.5]);
grid on;
xlabel('x[m]');ylabel('y[m]');
ax.FontSize = 15;
hold off
%% animation
figure(10)
xmax = 5;
xmin = -1;
ymax = 3.5;
ymin = -1;
dx = 1;
dy = 1;
fig10 = zeros(N,1);
% Animation Loop
t = 1;
v = VideoWriter('fometion_control_2.avi');
open(v);
while t <= length(logger.Data.t)
clf(figure(10)); 
xlim([xmin xmax]);
xticks(xmin:dx:xmax);
ylim([ymin ymax]);
yticks(ymin:dy:ymax);
set(gca,'FontSize',15);
xlabel('\sl x \rm [m]','FontSize',20);
ylabel('\sl y \rm [m]','FontSize',20);
hold on
grid on; 
pbaspect([1 1 1]);
% ax = gca;
axis equal
grid on
% ax.Box = 'on';
% ax.GridColor = 'k';
% ax.GridAlpha = 0.4;
for k=1:N-1
fig10(k) = plot(data{k}(1,t),data{k}(2,t),'o','Color',PlotColor(k),'Linewidth',2);
plot([data{k}(1,t) data{k+1}(1,t)],[data{k}(2,t) data{k+1}(2,t)],'LineWidth',2,'LineStyle','-','Color','k')
end
k=N;
fig10(k) = plot(data{k}(1,t),data{k}(2,t),'o','Color',PlotColor(k),'Linewidth',2);
plot(Area,'FaceColor','red','FaceAlpha',0.1);
legend(fig10,'Drone1','Drone2','Drone3','Drone4','Drone5','Power supply','Reference path','Location','northoutside','NumColumns',3);
hold off 
pause(16 * 1e-3) ; 
t = t+5;   
frame = getframe(figure(10));
writeVideo(v,frame);      
end
close(v);
disp('simulation ended')
%% velocity
%x position
figure(11)
hold on;
fig11 = zeros(1,N-1);
for k=1:N-1
fig11(k) = plot(Time(1:i),Save.State(8+13*(k-1),1:i),'-','Color',PlotColor(k),'LineWidth',2);
end
legend(fig11,'Drone1','Drone2','Drone3','Drone4','Drone5','Location','northoutside','NumColumns',3);
xlabel('t[s]');ylabel('vx[m/s]');
grid on;
hold off;
%% y velocity
%x position
figure(12)
hold on;
fig12 = zeros(1,N-1);
for k=1:N-1
fig12(k) = plot(Time(1:i),Save.State(9+13*(k-1),1:i),'-','Color',PlotColor(k),'LineWidth',2);
end
legend(fig12,'Drone1','Drone2','Drone3','Drone4','Drone5','Location','northoutside','NumColumns',3);

xlabel('t[s]');ylabel('vy[m/s]');
grid on;
hold off;
%% 計算時間
%x position
figure(13)
hold on;
xmax = 50;
xmin = 0;
xlim([xmin xmax]);
% ylim([0 4.5])
fig13 = plot(logger.Data.t,calculation','-','Color',PlotColor(2),'LineWidth',2);

% legend(fig13,'calculation time','Location','northoutside','NumColumns',3);
xlabel('time t[s]');ylabel('caluculation time[s]');
legend(fig13,'calculation time','Location','northoutside')
grid on;
hold off;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
%% 計算時間 二つのデータ比較
%x position
figure(50)
hold on;
xmax = 50;
xmin = 0;
xlim([xmin xmax]);
% ylim([0 4.5])
% fig50 = plot(logger.Data.t,calculation','-','Color',PlotColor(2),'LineWidth',2);
%Dataをloadしたとき↓
fig50(1) = plot(Data.t,calculation','-','Color',PlotColor(2),'LineWidth',2);
fig50(2) = plot(Data.t,calculation2','-','Color',PlotColor(5),'LineWidth',2);
% legend(fig13,'calculation time','Location','northoutside','NumColumns',3);
xlabel('time t[s]');ylabel('caluculation time[s]');
legend(fig50,'Calculation time','Calculation time after optimization','Location','northoutside')
grid on;
ax = gca;
ax.FontSize = 15;
hold off;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
%% 計算時間と位置の比較
%x position
figure(13)

xmax = 50;
xmin = 0;
subplot(2,1,1);
hold on;
xlim([xmin xmax]);
fig13 = plot(logger.Data.t,calculation','-','Color',PlotColor(2),'LineWidth',2);hold on
xlabel('time t[s]');ylabel('caluculation time[s]');
grid on;


subplot(2,1,2);
hold on
xlim([xmin xmax]);
for k=1:N
% fig13 = plot(logger.Data.t,data{k}(1,:),'.','Color',PlotColor(k),'Linewidth',2);hold on
fig13 = plot(logger.Data.t,data{k}(2,:),'--','Color',PlotColor(k),'Linewidth',2);
end
% legend(fig13,'calculation time','Location','northoutside','NumColumns',3);
xlabel('time t[s]');ylabel('x,y[s]');
grid on;


fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
%% 
figure(14)

xmax = 50;
xmin = 0;

hold on
xlim([xmin xmax]);
for k=1:N
fig14 = plot(logger.Data.t,data{k}(1,:),'.','Color',PlotColor(k),'Linewidth',2);hold on
fig14 = plot(logger.Data.t,data{k}(2,:),'--','Color',PlotColor(k),'Linewidth',2);
end
% legend(fig13,'calculation time','Location','northoutside','NumColumns',3);
xlabel('time t[s]');ylabel('y[m]');
legend('Drone1','Drone2','Drone3','Drone4','Drone5','Drone6','Location','northoutside','NumColumns',3);

grid on;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

%%
% PlotLine = ['-','--',':','-.','-'];
Time = 0:.05:100;
%xy位置
figure(1)
hold on;
ax= gca;
fig1 = zeros(1,N,251);

if N==1 
    fig1(1) = plot(data{1}(1,:),data{1}(2,:),'.','Color',PlotColor(1),'Linewidth',2);
    fig1(1) = plot(data{1}(1,end),data{1}(2,end),'o','Color',PlotColor(1),'Linewidth',2);
else
for k=1:N-1
    fig1(k) = plot3(data{k}(1,:),data{k}(2,:),Conttime(k,:),'-','Color',PlotColor(k),'Linewidth',1);
%     fig1(k) = plot(data{k}(1,end),data{k}(2,end),'o','Color',PlotColor(k),'Linewidth',2);
end
k=N;
% fig1(k) = plot(Data.agent{1,2,k}(1),Data.agent{1,2,k}(2),'o','Color',PlotColor(k),'Linewidth',2);
end
% Area = polyshape([0,0,5,5],[-1,3.5,3.5,-1])-polyshape([wall_width_x(1,1),wall_width_x(1,1),wall_width_x(1,2),wall_width_x(1,2)][wall_width_y(1,2),wall_width_y(1,1),wall_width_y(1,1),wall_width_y(1,2)])
% plot(Area,'FaceColor','red','FaceAlpha',0.1);
% legend(fig1,'Drone1','Drone2','Drone3','Drone4','Drone5','Power supply','Location','northoutside','NumColumns',3);
% lgd.Numcolums = 3;
axis equal;
grid on;
xticks([-1:1:12]);yticks([-1:1:6])
% xlim([-1 12]);ylim([-1 3.5]);
xlabel('x [m]');ylabel('y [m]');
ax.FontSize = 15;
hold off;

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
