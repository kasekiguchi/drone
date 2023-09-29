%%
SigmaData = zeros(4, te/dt);
close all
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
    Rdata(:, R) = data.xr{R}(1:12, 1); % cell2matにはできない　ホライズンがあるからcellオンリー
end
% if fHL == 1
%     Rdata = logger.data(1, "p", "r")';
%     Rdata = [Rdata; zeros(9, 400)];
% end
Diff = Edata - Rdata(1:3, :);
cutT = 0;
close all

m = 3; n = 2;

Eachcost = data.eachcost(:,1:end-1);

% figure(1)
% Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
ylabel("Position [m]")
legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference", "landing time", "Location","northwest");
% yyaxis right
% plot(logt, Eachcost(8,:)); 
% plot(logt, data.survive(1,end-1)', '.', 'MarkerSize', 2)
% xlabel("Time [s]"); ylabel("Eval"); 
% grid on; xlim([0 xmax]); ylim([0 5000]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_p.eps");
% title("Time change of Position"); 
% atiitude 0.2915 rad = 16.69 deg
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2);  hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "landing time", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-0.6 0.6]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_q.eps");
% title("Time change of Atiitude");
% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "landing time", "Location","southwest");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_v.eps");
% title("Time change of Velocity"); 
% input
figure(4); 
plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw", "landing time", "Location","northwest");
grid on; xlim([0 xmax]); ylim([-inf 5.5]);
ytickformat('%.1f')

if ~isempty(data.input_v)
    IV = data.input_v(:, 1:end-1);
    figure(7); plot(logt, IV); legend("input1", "input2", "input3", "input4");
    xlabel("Time [s]"); ylabel("input.V");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
% saveas(5, "../../Komatsu/MCMPC/InputV", "png");
end
%%
% zdis = (Edata(3,:) - (3/10 .* Edata(1,:)+0.1)) .* cos(atan(3/10));
% figure(7);
% plot(logt, zdis); hold on; xline(2.825, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
% xlabel('Time [s]'); ylabel('Altitude relative to slope [m]');
% xlim([0 xmax]);
% ylim([-inf inf]);
% grid on;
% legend("Altitude relative to slope", "landing time", "Location", "southwest");
% ytickformat('%.1f')
% exportgraphics(gcf, "D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_ZZ.eps");
%%
% 
% set(gca,'FontSize',Fontsize);  grid on; title("");
% xlabel("Time [s]");


% figure(6)
% % average
% Average = sum(data.calT(2:end-1,1)) / length(data.calT(2:end-1,1))
% AverageCal = repmat(Average, length(data.calT(1:end-1)),1);  
% plot(logt, data.calT(1:end-1,1), logt, AverageCal);
% xlabel("Time [s]"); ylabel("Calculation time [s]");

% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])

%% Position RMSE
strRMSE = ["x"; "y"; "z"];
dataRMSE = rmse(Edata, Rdata(1:3,:), 2)'
% RMSE = [strRMSE, dataRMSE]

%% Animation video
% close all;
% agent(1).animation(logger,"target",1); 

%% save
data_now = datestr(datetime('now'), 'yyyymmdd');
Title = strcat(['HLMCMPC-', '-N'], num2str(data.param.Maxparticle_num), '-', data.param.H, 's-', datestr(datetime('now'), 'HHMMSS'));
Outputdir = strcat('../../students/komatsu/simdata/', data_now, '/');
if exist(Outputdir) ~= 7
    mkdir ../../students/komatsu/simdata/20230910/
end

% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")
% saveas(1,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_p.epsc");
% saveas(2,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_q.epsc");
% saveas(3,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_v.eps");
% saveas(4,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_input.eps");
% saveas(7,"D:\Documents\OneDrive - 東京都市大学 Tokyo City University\研究室_2023\SICE2023_小松祥己\fig\slope_ZZ.eps")