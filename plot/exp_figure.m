%%% 実機実験の結果をplotするファイル
%% Initial settingclear;
clear;
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

%%
clear
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

disp("Loading data...");
% load("Data/experiment/experiment_10_20_P2Px_estimator.mat");
% load("Data/experiment/experiment_10_25_P2Py_estimator.mat");
% load("Data/20240528_KMPC_P2Py=1.mat")
% filename = '20240627_KMPC_hovering_H20_mex';

filename = '0716_KMPC_hovering_warui';
% filename = 'test_HLMPC_0707_7';
loadfile = strcat("Data/", filename, ".mat");
% load(loadfile);
log = LOGGER(loadfile); % loggerの形で収納できる

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
flg.figtype = 0; % 0:subplot
flg.savefig = 0;
flg.animation_save = 0;
flg.animation = 0;
flg.timerange = 1;
flg.plotmode = 2; % 1:inner_input, 2:xy, 3:xyz
phase = 2; % 1:flight, 2:all

fig = FIGURE_EXP(struct('logger',log,'fExp',0),struct('flg',flg,'phase',phase,'filename',filename));
% fig = fig.main_figure();
% fig = fig.make_mpc_plot();
% [x, xr] = fig.main_mpc('HL', [-1 1; -2 2; 0 1.1]);
% app = app.logger, app.fExp の構造体を作ればよい

%% save
if flg.savefig
    % 上書き防止
    if isfile(strcat(pwd, savefolder, savename, '.png'))
        warning('Stop saving figure because exist same name file'); % すでにファイルがある場合は保存をやめる
    else
        fprintf('Saving figure. \n');
        saveas(1, strcat(pwd, savefolder, savename), 'png');
        % saveas(100, strcat(pwd, savefolder, savename, 'calc'), 'png'); % calc time
    end
end

%% 保管場所
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
rmse_x = rmse(fig.data.Est(1:9,:), fig.data.Ref(1:9,:), 2);
error = abs(fig.data.Est(1:9,:) - fig.data.Ref(1:9,:));
max_error = max(error, [], 2);
% disp(filename);
fprintf('FileName: %s \n', filename);
fprintf('RMSE: x=%.4f, y=%.4f, z=%.4f \n', rmse_x(1), rmse_x(2), rmse_x(3));
fprintf('MAX error: x=%.4f, y=%.4f, z=%.4f \n', max_error(1), max_error(2), max_error(3));
% csv
% fprintf('RMSE: %.4f, %.4f, %.4f \n', rmse_x(1), rmse_x(2), rmse_x(3));
% fprintf('MAX error: %.4f, %.4f, %.4f \n', max_error(1), max_error(2), max_error(3));

%%