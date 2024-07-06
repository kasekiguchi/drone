function [] = make_figure_exp(app, filename, phase)
%-- 実機実験の結果をplotするファイル
% filename : 保存ファイル名
% phase    : プロットの範囲. 1=flight, 2=all

Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

log = app.logger;
% flight phase
% 115:start
% 97 :arming
% 116:takeoff q no data
% 102:flight
% 108:landing
% 0:stop or quit

%% save setting
savename = strcat(filename, '_all');
savefolder = '\Data\Exp_figure_image\';
%%
close all
clear Ref
flg.figtype = 0; % 0:subplot
flg.savefig = 0;
flg.animation_save = 0;
flg.animation = 0;
flg.timerange = 1;
flg.plotmode = 3; % 1:inner_input, 2:xy, 3:xyz
logAgent = log.Data.agent; % inner_input用
% phase = 1; % 1:flight, 2:all
switch phase
    case 1
        start_idx = find(log.Data.phase==102,1,'first');
        finish_idx = find(log.Data.phase==102,1,'last')-1;
    case 2
        start_idx = 1;
        finish_idx = find(log.Data.phase==0,1,'first')-1;
        takeoff_idx.start = find(log.Data.phase==116,1,'first');
        takeoff_idx.finish = find(log.Data.phase==116,1,'last');
end
% tt = log.Data.t(start_idx:finish_idx);
logt = log.data(0,"t",[],"ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
calt = logt;

% setting time range. flg.timerange == 1なら 0 ~ flight時間に変更
if flg.timerange
    % logt = linspace(0, log.Data.t(finish_idx)-log.Data.t(start_idx), length(logt));
    logt = logt - logt(1);
end

% arrayfunで読み込み
disp('Storing data...');
Est = [log.data(1,"p","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"q","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"v","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"w","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])'];
Sen = [log.data(1,"p","s","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"q","s","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])'];
Input = log.data(1,"input",[],"ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';

Ref = [log.data(1,"p","r","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
    zeros(size(Est(1:3,:)));
    log.data(1,"v","r","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])'];

disp('Plotting start...');
m = 2; n = 3;
if flg.figtype; figure(1); else subplot(m,n,1); sgtitle(strcat(strrep(filename,'_','-')));end
plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(2); else subplot(m,n,2); end
plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(3); else subplot(m,n,3); end
plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(4); else subplot(m,n,4); end
plot(logt, Input(1,:), "LineWidth", 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.1f');

if flg.figtype; figure(5); else subplot(m,n,5); end
plot(logt, Input(2:4,:), "LineWidth", 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.3f');

if flg.figtype; figure(6); else subplot(m,n,6); end
% calculation time
plot(logt(1:end-1), diff(calt), 'LineWidth', 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
yline(0.025, 'Color', 'red', 'LineWidth', 1.5); hold off;
ytickformat('%.1f');

if m*n > 6
if flg.figtype; figure(8); else subplot(m,n,8); end
plotrange = 1.5;
if flg.plotmode == 1
    InnerInput = cell2mat(arrayfun(@(N) logAgent.inner_input{N}(:,1:4)',start_idx:finish_idx,'UniformOutput',false));
    plot(logt, InnerInput); 
    background_color(phase, -0.1, gca, logt, log.Data.phase); 
    xlabel("Time [s]"); ylabel("Inner input"); legend("inner_input.roll", "inner_input.pitch", "inner_input.throttle", "inner_input.yaw","Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
elseif flg.plotmode == 2
    plot(Est(1,:), Est(2,:)); hold on; plot(Est(1,1), Est(2,1), '*', 'MarkerSize', 10); plot(Est(1,end), Est(2,end), '*', 'MarkerSize', 10); hold off;
    xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex');
    legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
    grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]);
elseif flg.plotmode == 3
    plot3(Est(1,:), Est(2,:), Est(3,:)); hold on; plot3(Est(1,1), Est(2,1), Est(3,1), '*', 'MarkerSize', 10); plot3(Est(1,end), Est(2,end), Est(3,end), '*', 'MarkerSize', 10); hold off;
    xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex'); zlabel('$$z$$', 'Interpreter', 'latex');
    legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
    grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]); zlim([0 inf]);
end
end

%
if ~flg.figtype % subplotなら
    set(gcf, "WindowState", "maximized");
    set(gcf, "Position", [960 0 960 1000])
end

%% sensor
% figure(7);
% sel = 1:3;
% plot(logt, Est(sel,:), '-', 'LineWidth', 1.5); hold on; 
% plot(logt, Sen(sel,:), '--', 'LineWidth', 1.5);
% plot(logt, Ref(sel,:), '-.', 'LineWidth', 1.5); hold off;
% grid on; xlabel('Time [s]'); ylabel('Estimator, Sensor, Reference [m]')
% legend('Est.x', 'Est.y', 'Est.z', 'Sen.x', 'Sen.y', 'Sen.z', 'Ref.x', 'Ref.y', 'Ref.z');
% 
% maxerror_x = max(abs(Est(1,:) - Sen(1,:)));
% maxerror_y = max(abs(Est(2,:) - Sen(2,:)));
% maxerror_z = max(abs(Est(3,:) - Sen(3,:)));
% fprintf('Sensor error: %f, %f, %f \n', maxerror_x, maxerror_y, maxerror_z);

%% RMSE
rmse_x = rmse(Est(1:9,:), Ref(1:9,:), 2);
error = abs(Est(1:9,:) - Ref(1:9,:));
max_error = max(error, [], 2);
% disp(filename);
fprintf('FileName: %s \n', filename);
fprintf('RMSE: x=%.4f, y=%.4f, z=%.4f \n', rmse_x(1), rmse_x(2), rmse_x(3));
fprintf('MAX error: x=%.4f, y=%.4f, z=%.4f \n', max_error(1), max_error(2), max_error(3));
% csv
% fprintf('RMSE: %.4f, %.4f, %.4f \n', rmse_x(1), rmse_x(2), rmse_x(3));
% fprintf('MAX error: %.4f, %.4f, %.4f \n', max_error(1), max_error(2), max_error(3));

%% save
if flg.savefig
    % 上書き防止
    if isfile(strcat(pwd, savefolder, savename, '.png'))
        warning('Stop saving figure because exist same name file'); % すでにファイルがある場合は保存をやめる
    else
        fprintf('Saving figure. \n');
        saveas(1, strcat(pwd, savefolder, savename), 'png');
        saveas(100, strcat(pwd, savefolder, savename, 'calc'), 'png'); % calc time
    end
end

%% animation
% clear logger
if flg.animation == 1
    % flightだけも可能
    logger.p = Est(1:3,:)';
    logger.q = Est(4:6,:)';
    logger.u = Input';
    logger.r = Ref(1:3,:)';
    logger.t = logt';
    drone = DRAW_DRONE_MOTION(logger,"target",1,"opt_plot",[]);
    if flg.animation_save; anipara = struct("target",1,"opt_plot",[],"mp4",flg.animation_save);
    else;                  anipara = struct("target",1,"opt_plot",[]);
    end
    drone.animation(logger, anipara);
end

%% function
function background_color(phase, yoffset, gca, logt, logphase)
    txt = {''};
    font_size = 10;
    % yoffset = -0.1;
    switch phase
        case 1 %flight
            % Square_coloring(log.Data.t([find(log.Data.phase == 102, 1), find(log.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca); % flight phase
            Square_coloring([logt(1);logt(end)], [0.9 1.0 1.0],[],[],gca); % flight phase
            txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];
        case 2 %all time
            Square_coloring(logt([find(logphase == 116, 1), find(logphase == 116, 1, 'last')]),[],[],[],gca); 
            txt = [txt(:)', {'{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'}]; % take off phase
            Square_coloring(logt([find(logphase == 102, 1), find(logphase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca);
            txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];   % flight phase
            Square_coloring(logt([find(logphase == 108, 1), find(logphase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],gca); 
            txt = [txt(:)', {'{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'}];  % landing phase
        otherwise
    end
    text(gca().XLim(2) - (gca().XLim(2) - gca().XLim(1)) * 0.45, gca().YLim(2) + (gca().YLim(2) - gca().YLim(1)) * yoffset, txt, 'FontSize', font_size);
    xlabel("Time [s]"); ylabel("Calculation time [s]"); xlim([0 logt(end-1)])
end
end