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
load("Data/Exp_saigen_20240517_P2P_y.mat")

%%
figtype = 2;
Agent = log.Data.agent;

flight_start_idx = find(log.Data.phase==102, 1, 'first');
flight_finish_idx = find(log.Data.phase==102, 1, 'last');
logt = log.Data.t(flight_start_idx:flight_finish_idx);

% initialize data
Est = zeros(12, flight_finish_idx-flight_start_idx+1);
Ref = zeros(9,  flight_finish_idx-flight_start_idx+1);
Input = zeros(4,flight_finish_idx-flight_start_idx+1);
InnerInput = zeros(8, flight_finish_idx-flight_start_idx+1);
for i = flight_start_idx:flight_finish_idx
    Est(:,i-flight_start_idx+1) = [Agent.estimator.result{i}.state.p;
                Agent.estimator.result{i}.state.q;
                Agent.estimator.result{i}.state.v;
                Agent.estimator.result{i}.state.w];

    Ref(:,i-flight_start_idx+1) = [Agent.reference.result{i}.state.p;
                Agent.reference.result{i}.state.q;
                Agent.reference.result{i}.state.v];

    Input(:,i-flight_start_idx+1) = Agent.input{i};

    InnerInput(:,i-flight_start_idx+1) = Agent.inner_input{i};
end

m = 2; n = 2;
if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InnerInput);
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
elseif figtype == 2
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    % subplot(m,n,5); plot(logt, InnerInput); 
    % xlabel("Time [s]"); ylabel("Inner input");
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
end
%%
set(gca,'FontSize',Fontsize);  grid on; title("");
xlabel("Time [s]");

set(gcf, "WindowState", "maximized");
set(gcf, "Position", [960 0 960 1000])