%%plot
close all;
SigmaData = zeros(4, te/dt);
fprintf("%f秒\n", totalT)
Fontsize = 15;  xmax = time.t;
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

% size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
% Rdata = logger.data(1, "p", "r")';

Vdata = logger.data(1, "v", "e")';
Qdata = logger.data(1, "q", "e")';
Idata = logger.data(1,"input",[])';
logt = logger.data('t',[],[]);
Rdata = zeros(12, size(logt, 1));
IV = zeros(4, size(logt, 1));
for R = 1:size(logt, 1)
    % Rdata(:, R) = data.xr{R}(1:12, 1);
%     if ~isempty(data.input_v); IV(:, R) = data.input_v{R}; end
%     if length(data.sigma{1}) == 4; SigmaData(:, R) = data.sigma{R}; end
%     Bestcost(:, R) = data.bestcost{R};
end
Diff = Edata - Rdata(1:3, :);
close all

Rdata = logger.data(1, "p", "r")';

% x-y
% figure(5); plot(Edata(1,:), Edata(2,:)); xlabel("X [m]"); ylabel("Y [m]");
m = 3; n = 2;
% x-z
% Et = -0.5:0.1:0.5; Ez = 3/10 * Et; Er = -10/3 * Et;
% figure(6); plot(Edata(1,1:round(xmax/dt)-1), Edata(3,1:round(xmax/dt-1))); hold on; % 軌跡
% plot(Rdata(1,1:round(xmax/dt)-1), Rdata(3, 1:round(xmax/dt)-1));
% % plot(0, 0.15, '*'); plot(0.1, 0.15, '.'); plot(0.1, 0.1, '.');
% plot(Edata(1,1), Edata(3,1), 'h');  % initial
% plot(Et, Er)
% plot(Et, Ez); 
% hold off; % 斜面
% xlabel("X [m]"); ylabel("Z [m]"); 
% position
% 1:リファレンス, 

% figure(1)
% Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--');  xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference", "landing time", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_p.eps");
% title("Time change of Position"); 
% atiitude 0.2915 rad = 16.69 deg
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2);  hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "landing time", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-0.6 0.6]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_q.eps");
% title("Time change of Atiitude");
% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--');  xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "landing time", "Location","southwest");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_v.eps");
% title("Time change of Velocity"); 
% input
figure(4); 
plot(logt, Idata, "LineWidth", 1.5); hold on; xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw", "landing time", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-inf 5.5]);
ytickformat('%.1f')
exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_input.eps");
% % title("Time change of Input");
% figure(5); % 仮想入力
% plot(logt, IV); legend("Z", "X", "Y", "YAW");
% xlabel("Time [s]"); ylabel("input.V");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % calculation time
% figure(6);
% plot(logt, data.calT(1:size(logger.data('t',[],[]),1))); hold on;
% plot(logt, totalT/(te/dt)*ones(size(logt,1),1), '--', 'LineWidth', 2); hold off;
% xlim([0 xmax]);
%%
zdis = (Edata(3,:) - (3/10 .* Edata(1,:)+0.1)) .* cos(atan(3/10));
figure(7);
plot(logt, zdis); hold on; xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel('Time [s]'); ylabel('Altitude relative to slope [m]');
xlim([0 xmax]);
ylim([-inf inf]);
grid on;
legend("Altitude relative to slope", "landing time", "Location", "southwest");
ytickformat('%.1f')
exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_ZZ.eps");
%%

set(gca,'FontSize',Fontsize);  grid on; title("");
xlabel("Time [s]");
ylabel("Calculation time [s]");

% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])

%% save
% saveas(1,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_p.epsc");
% saveas(2,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_q.epsc");
% saveas(3,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_v.eps");
% saveas(4,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_input.eps");
% saveas(7,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_ZZ.eps")