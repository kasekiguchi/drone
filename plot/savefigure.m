%%
SigmaData = zeros(4, te/dt);
close all
fprintf("%f秒\n", totalT)
Fontsize = 15;  xmax = 15;
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
Rdata = logger.data(1, "p", "r")';
Rdata = zeros(12, size(logt, 1));
% IV = zeros(4, size(logt, 1));
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

% Bestcost = data.bestcost(:,1:length(logt));
if fsave == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    ylabel("Position [m]")
    legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference", "landing time", "Location","northwest");
    % yyaxis right
    % plot(logt, Eachcost(8,:)); 
    % plot(logt, data.survive(1,end-1)', '.', 'MarkerSize', 2)
    xlabel("Time [s]");  
    grid on; xlim([0 xmax]); %ylim([0 5000]);

    % atiitude 0.2915 rad = 16.69 deg
    % figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2);  hold off;
    % xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "landing time", "Location","northwest");
    % grid on; xlim([0 xmax]); ylim([-0.6 0.6]);

    figure(2); plot(Edata(1,:), Edata(2,:)); hold on; plot(Rdata(1,:), Rdata(2,:), '--'); hold off;
    xlim([0 10])
    daspect([1 1 1]);
    legend("Estimate", "Reference");
    xlabel("$$X$$", "Interpreter", "latex"); ylabel("$$Y$$", "Interpreter", "latex")

    % velocity
    figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "landing time", "Location","southwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % input
    figure(4); 
    plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw", "landing time", "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf 5.5]);
    ytickformat('%.1f')
    
    if ~isempty(data.input_v)
        IV = data.input_v(:, 1:length(logt));
        figure(7); plot(logt, IV); legend("input1", "input2", "input3", "input4");
        xlabel("Time [s]"); ylabel("input.V");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
    % saveas(5, "../../Komatsu/MCMPC/InputV", "png");
    end
    
    % figure(20);
    % plot(logt, Eachcost(7:10,:)); xlim([0 xmax])
    % legend("Z.cost", "X.cost", "Y.cost", "PHI.cost", "Location", "northwest");
else
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(100)
    subplot(m,n,1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    ylabel("Position [m]")
    legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference", "landing time", "Location","northeast");
    % yyaxis right
    % plot(logt, Eachcost(8,:)); 
    % plot(logt, data.survive(1,end-1)', '.', 'MarkerSize', 2)
    xlabel("Time [s]");  
    grid on; xlim([0 xmax]); %ylim([0 5000]);
    % 
    subplot(m,n,4); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2);  hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "landing time", "Location","northeast");
    grid on; xlim([0 xmax]); ylim([-inf inf]);

    subplot(m,n,2); plot3(Edata(1,:), Edata(2,:), Edata(3,:)); hold on; plot3(Rdata(1,:), Rdata(2,:), Rdata(3,:), '--'); hold off;
    daspect([1 1 1]);
    legend("Estimate", "Reference");
    xlabel("$$X$$", "Interpreter", "latex"); ylabel("$$Y$$", "Interpreter", "latex")
    view(2)

    % velocity
    subplot(m,n,3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--');  xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "landing time", "Location","northeast");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % input
    subplot(m,n,6); 
    plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw", "landing time", "Location","northeast");
    grid on; xlim([0 xmax]); ylim([-inf 5.5]);
    ytickformat('%.1f')

    % % error
    % subplot(m,m,4)
    % error = Edata(1:3, :) - Rdata(1:3, :);
    % plot(logt, error);
    % xlim([0 xmax]);
    % xlabel("Time [s]"); ylabel("Error [m]");
    
    if ~isempty(data.input_v)
        IV = data.input_v(:, 1:length(logt));
        subplot(m,n,5); plot(logt, IV); legend("input1", "input2", "input3", "input4","Location","northeast");
        xlabel("Time [s]"); ylabel("input.V");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
    % saveas(5, "../../Komatsu/MCMPC/InputV", "png");
    end
    % 
    % subplot(m,n,6);
    % plot(logt, Bestcost); xlim([0 xmax])
    % legend("Z.cost", "X.cost", "Y.cost", "PHI.cost", "Location", "northeast");
    % xlabel("Time [s]"); ylabel("Cost");

    if ~fMC
        data.param.Maxparticle_num = 0;
    end
    title(strcat('N: ', num2str(data.param.Maxparticle_num)));

    % set(gcf, "WindowState", "maximized");
    set(gcf, "Position", [960 0 960 1000])

    %%
    % savename = 'HLMCMPC-linear-compare-good'
    % saveas(gcf, strcat('../../png_save/', savename), 'png');
end

%% 評価値の比較
% figure(22);
% plot(logt, Bestcost(1,:), logt, sum(Bestcost(2:5,:), 1)); legend("All", "SUM");

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

% 
% figure(6)
% % average
% Average = sum(data.calT(6:end-1,1)) / length(data.calT(6:end-1,1))
% AverageCal = repmat(Average, length(data.calT(1:end-1)),1);  
% plot(logt(6:end), data.calT(6:end-1,1), logt, AverageCal);
% xlabel("Time /s"); ylabel("Calculation time /s");
% ylim([0.018 0.026])

% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])

%% Position RMSE
strRMSE = ["x"; "y"; "z"];
Est = [Edata; Qdata; Vdata];
Ref = [Rdata(1:9, :)];
dataRMSE = '    x,        y,        z,        roll,     pitch,    yaw,      vx,       vy,       vz';
disp(dataRMSE);
dataRMSE = rmse(Est, Ref, 2)';
disp(dataRMSE);
data.rmse = dataRMSE;

%% Animation video
% close all;
% agent(1).animation(logger,"target",1); 

%% save
data.totalT = totalT;
data.time = time;
data_now = datestr(datetime('now'), 'yyyymmdd');
% Title = strcat(['HLMCMPC-', 'N'], num2str(data.param.Maxparticle_num), '-', data.param.H, 's-', datestr(datetime('now'), 'HHMMSS'));
% Outputdir = strcat('../../students/komatsu/simdata/', data_now, '/');
mkdir(strcat('../../students/komatsu/simdata/', data_now, '/'));

% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/HLMCMPC-N-1000_constraints_circle.mat'), "agent", "data", "logger", "-v7.3")
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")