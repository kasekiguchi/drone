opengl software
close all hidden;

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 14; %凡例の大きさ調整
lgdtmp = {'$x_e$','$x_r$','$y_e$','$y_r$','$z_e$','$z_r$'};
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};

colororder(newcolors)
%位置p
plot(data.t,data.x,'LineWidth',1);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
plot(data.t,data.y,'LineWidth',1);
plot(data.t,data.z,'LineWidth',1);
plot(data.t,data.xr,'LineWidth',1,'LineStyle','--');
plot(data.t,data.yr,'LineWidth',1,'LineStyle','--');
plot(data.t,data.zr,'LineWidth',1,'LineStyle','--');
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
hold off
