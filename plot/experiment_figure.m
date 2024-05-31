%% 実機実験の結果をplotするファイル
clear;
close all;
%% Initial setting
cd(strcat(fileparts(matlab.desktop.editor.getActive().Filename), '../../')); % drone/のこと
Fontsize = 15;  
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

% load("Data/experiment/experiment_10_20_P2Px_estimator.mat");
% load("Data/experiment/experiment_10_25_P2Py_estimator.mat");
load("Data/20240528_KMPC_P2Py=1.mat")

%%
flg.figtype = 1;
logAgent = log.Data.agent;
phase = 'flight';
switch phase
    case 'flight'
        start_idx = find(log.Data.phase==102,1,'first');
        finish_idx = find(log.Data.phase==102,1,'last');
    case 'all'
        start_idx = 1;
        finish_idx = find(log.Data.phse==0,1,'first');
end
logt = log.Data.t(start_idx:finish_idx);

% arrayfunで読み込み
Est = cell2mat(arrayfun(@(N) logAgent.estimator.result{N}.state.get(),start_idx:finish_idx,'UniformOutput',false));
Ref = [cell2mat(arrayfun(@(N) logAgent.reference.result{N}.state.p,start_idx:finish_idx,'UniformOutput',false));
        cell2mat(arrayfun(@(N) logAgent.reference.result{N}.state.q,start_idx:finish_idx,'UniformOutput',false))
        cell2mat(arrayfun(@(N) logAgent.reference.result{N}.state.v,start_idx:finish_idx,'UniformOutput',false))];
Input = cell2mat(arrayfun(@(N) logAgent.input{N},start_idx:finish_idx,'UniformOutput',false));
InnerInput = cell2mat(arrayfun(@(N) logAgent.inner_input{N}(:,1:4)',start_idx:finish_idx,'UniformOutput',false));

m = 2; n = 3;
if flg.figtype; figure(1); else subplot(m,n,1); end
plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(2); else subplot(m,n,2); end
plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(3); else subplot(m,n,3); end
plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(4); else subplot(m,n,4); end
plot(logt, InnerInput); 
xlabel("Time [s]"); ylabel("Inner input"); legend("inner_input.roll", "inner_input.pitch", "inner_input.throttle", "inner_input.yaw","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(5); else subplot(m,n,5); end
plot(logt, Input(1,:), "LineWidth", 1.5); hold on;
xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.1f');

if flg.figtype; figure(6); else subplot(m,n,6); end
plot(logt, Input(2:4,:), "LineWidth", 1.5); hold on;
xlabel("Time [s]"); ylabel("Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.1f');

%%
if ~flg.figtype
    set(gcf, "WindowState", "maximized");
    set(gcf, "Position", [960 0 960 1000])
end