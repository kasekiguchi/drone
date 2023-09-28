
fMC = 0; % MCかどうか
fsave = 0; % 保存するかどうか figureを個別に出力しsave_pathに保存
mkdir C:/Users/student/Documents/students/komatsu/MPC; % 保存するフォルダを作成　コメントアウトして自分で作成してもOK
save_path = "C:/Users/student/Documents/students/komatsu/MPC"; % 保存するフォルダのパス

close all

set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

%%

if exist('gui') == 1
    len = gui.logger.k;
    logData = gui.logger.Data;
    te = gui.time.te;
else
    len = length(logData.t)-1;
    logData = log.Data;
    te = log.k * 0.025;
end

for i = 1:len
    Data(:,i) = logData.agent.estimator.result{i}.state.get();
    RData(:,i) = logData.agent.reference.result{i}.state.get();
    Idata(:,i) = logData.agent.input{i};
end

logt = logData.t;
logt = logt(1:end);
Edata = Data(1:3,:);
Qdata = Data(4:6,:);
Vdata = Data(7:9,:);
Wdata = Data(10:12,:);

Rdata = RData(1:3,:);
Rdata = [Rdata; zeros(9, len)];

Diff = Edata - Rdata(1:3, :);
cutT = 0;

Fontsize = 15;  xmax = te;
%%
close all
if fsave ~= 1
    m = 2; n = 2;
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    % atiitude 0.2915 rad = 16.69 deg
    subplot(m,n,2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    % velocity
    subplot(m,n,3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    if fMC == 1
        % input
        subplot(m,n,4); 
        plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
        xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
        ytickformat('%.1f')
    else
        % input transform
        Param = gui.agent.parameter; % なければ適当に実行
        Trans = [1 1 1 1;-Param.ly, -Param.ly, (Param.Ly - Param.ly), (Param.Ly - Param.ly); Param.lx, -(Param.Lx-Param.lx), Param.lx, -(Param.Lx-Param.lx); Param.km1, -Param.km2, -Param.km3, Param.km4];
        input_torque = Trans * Idata;
        subplot(m,n,4);
        plot(logt, input_torque, "LineWidth", 1.5);
        xlabel("Time [s]"); ylabel("Torque input [N, Nm]");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
    end
    set(gcf, "WindowState", "maximized");
else
    figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    % atiitude 0.2915 rad = 16.69 deg
    figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--');  hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    % velocity
    figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    
    if fMC == 1
        % input
        figure(4); 
        plot(logt, Idata, "LineWidth", 1.5); hold on; xline(cutT, ':', 'Color', 'blue', 'LineWidth', 2); hold off;
        xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
        ytickformat('%.1f')
    else
        % input transform
        Param = gui.agent.parameter; % なければ適当に実行
        Trans = [1 1 1 1;-Param.ly, -Param.ly, (Param.Ly - Param.ly), (Param.Ly - Param.ly); Param.lx, -(Param.Lx-Param.lx), Param.lx, -(Param.Lx-Param.lx); Param.km1, -Param.km2, -Param.km3, Param.km4];
        input_torque = Trans * Idata;
        figure(4);
        plot(logt, input_torque, "LineWidth", 1.5);
        xlabel("Time [s]"); ylabel("Torque input [N, Nm]");
        grid on; xlim([0 xmax]); ylim([-inf inf]);
    end
    %% save
    saveas(1,strcat(save_path, "/position.jpg"));
    saveas(2,strcat(save_path, "/attitude.jpg"));
    saveas(3,strcat(save_path, "/velocity.jpg"));
    saveas(4,strcat(save_path, "/input.jpg"));
end
% figure(6)
% % average
% Average = sum(data.calT(2:end-1,1)) / length(data.calT(2:end-1,1))
% AverageCal = repmat(Average, length(data.calT(1:end-1)),1);  
% plot(logt, data.calT(1:end-1,1), logt, AverageCal);
% xlabel("Time [s]"); ylabel("Calculation time [s]");

% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])

