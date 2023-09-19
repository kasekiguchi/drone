
te = 5;
close all
% fprintf("%f秒\n", totalT)
Fontsize = 15;  xmax = 3;
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

%%
for i = 1:length(log.Data.t)-1
    Data(:,i) = log.Data.agent.estimator.result{i}.state.get();
    RData(:,i) = log.Data.agent.reference.result{i}.state.get();
end
logt = log.Data.t;
logt = logt(1:end-1);
Edata = Data(1:3,:);
Qdata = Data(4:6,:);
Vdata = Data(7:9,:);
Wdata = Data(10:12,:);

Rdata = RData(1:3,:);
Rdata = [Rdata; zeros(9, 200)];

Diff = Edata - Rdata(1:3, :);
cutT = 0;
close all

m = 3; n = 2;

% figure(1)
% Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
grid on; xlim([0 xmax]); ylim([-inf inf]);

% atiitude 0.2915 rad = 16.69 deg
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2);  hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-0.6 0.6]);

% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
grid on; xlim([0 xmax]); ylim([-inf inf]);

% input
figure(4); 
plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
grid on; xlim([0 xmax]); ylim([-inf 5.5]);
ytickformat('%.1f')

set(gca,'FontSize',Fontsize);  grid on; title("");
xlabel("Time [s]");


figure(6)
% average
Average = sum(data.calT(2:end-1,1)) / length(data.calT(2:end-1,1))
AverageCal = repmat(Average, length(data.calT(1:end-1)),1);  
plot(logt, data.calT(1:end-1,1), logt, AverageCal);
xlabel("Time [s]"); ylabel("Calculation time [s]");

% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])


agent(1).animation(logger,"target",1); 
%% save
% saveas(1,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_p.epsc");
% saveas(2,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_q.epsc");
% saveas(3,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_v.eps");
% saveas(4,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_input.eps");
% saveas(7,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_ZZ.eps")
