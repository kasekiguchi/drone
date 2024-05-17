%%
% SigmaData = zeros(4, te/dt);
% te = 10;
close all
% fprintf("%f秒\n", totalT)
Fontsize = 15;  
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

%% Importing data
if exist("app") ~= 7        % GUI実行中
    logt = app.logger.Data.t;
    xmax = app.time.t-app.time.dt;
    logAgent = app.logger.Data.agent;
% elseif exist("log") == 1    % matを読み込んだ
%     flg = 1;
%     logt = log.Data.t(1:find(log.Data.t(2:end)==0, 1, 'first'));
%     xmax = log.Data.t(find(log.Data.t(2:end)==0, 1, 'first'));
%     logAgent = log.Data.agent;
else                        % GUIを閉じた
    logt = gui.logger.Data.t;
    xmax = gui.time.t-gui.time.dt;
    logAgent = gui.logger.Data.agent;
end

for i = 1:length(logt)
    Data(:,i) = logAgent.estimator.result{i}.state.get();
    RData(:,i) = logAgent.controller.result{i}.xr(:,1);
    Idata(:,i) = logAgent.input{i};
    InputV(:,i) = logAgent.controller.result{i}.input_v;
end

logt = logt(1:end-1); % time
Pdata = Data(1:3,:); % position
Qdata = Data(4:6,:); % attitude
Vdata = Data(7:9,:); % velocity
Wdata = Data(10:12,:); % angular velocity
Rdata = [RData(1:12,:); RData(17:19, :)]; % X, acceralation

Diff = Pdata - Rdata(1:3, :);
cutT = 0;
close all

m = 3; n = 2;

% exportgraphics(gcf, "path"); % save image file
% saveas(fig_number,"path")

if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Pdata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Idata, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InputV); legend("Z", "X", "Y", "YAW");
elseif figtype == 2
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Pdata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Idata, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    subplot(m,n,5); plot(logt, InputV); legend("Z", "X", "Y", "YAW");
    xlabel("Time [s]"); ylabel("Imaginary input");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
end
%%
set(gca,'FontSize',Fontsize);  grid on; title("");
xlabel("Time [s]");

set(gcf, "WindowState", "maximized");
set(gcf, "Position", [960 0 960 1000])