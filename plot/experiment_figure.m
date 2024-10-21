%% 実機実験の結果をplotするファイル
clear;
close all;
%% Initial setting
Fontsize = 15;  
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

load("20241016");

%%
figtype = 2;
Agent = log.Data.agent;

flight_start_idx = find(log.Data.phase==102, 1, 'first');
flight_finish_idx = find(log.Data.phase==102, 1, 'last');
logt = log.Data.t(flight_start_idx:flight_finish_idx);
logt = logt - logt(1);

% initialize data
Est = zeros(12, flight_finish_idx-flight_start_idx+1);
Ref = zeros(9,  flight_finish_idx-flight_start_idx+1);
Sen = zeros(6,  flight_finish_idx-flight_start_idx+1);
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

    Sen(:,i-flight_start_idx+1) = [Agent.estimator.result{i}.state.p;
                Agent.estimator.result{i}.state.q];

    Input(:,i-flight_start_idx+1) = Agent.input{i};

    %InnerInput(:,i-flight_start_idx+1) = Agent.inner_input{i};
end

m = 2; n = 3;
a = 2; b = 2;
if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InnerInput);
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
elseif figtype == 2
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Input(1,:), "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("total thrust", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    %ytickformat('%.1f');
    subplot(m,n,5); plot(logt, Input(2:4,:), "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend('torque roll','torque pitch','torque yaw',"Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    subplot(m,n,6); plot(Est(1,:), Est(2,:), "LineWidth", 1.5); hold on; plot(Ref(1,:), Ref(2,:)); hold off;
    xlabel("x [m]"); ylabel("y [m]"); legend("Estimate", "Reference","Location","best");
    daspect([1 1 1]);
    grid on; xlim([-3, 3]); ylim([-3, 3]);
    % subplot(m,n,6); plot3(Est(1,:), Est(2,:), Est(3,:), "LineWidth", 1.5); hold on; plot(Ref(1,:), Ref(2,:),Ref(3,:), "LineWidth", 1.5); hold off;
    % xlabel("x [m]"); ylabel("y [m]"); zlabel("z [m]"); legend("Estimate", "Reference","Location","best");
    % grid on; xlim([-3, 3]); ylim([-3, 3]); zlim([-3, 3]);
    % subplot(m,n,6); plot3(logt, Input, "LineWidth", 1.5); hold on;
    % xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","best");
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % virtual input
    % subplot(m,n,5); plot(logt, InnerInput); 
    % xlabel("Time [s]"); ylabel("Inner input");
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % subplot(m,n,5); plot(logt, Sen(4:6,:), "LineWidth", 1.5); hold on;
    % xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % subplot(m,n,6); plot(logt, Sen(1:3,:), "LineWidth", 1.5); hold on;
    % xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
elseif figtype == 3
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(a,b,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(a,b,2); plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(a,b,3); plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","best");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    subplot(a,b,4); plot(Est(1,:), Est(2,:), "LineWidth", 1.5); hold on; plot(Ref(1,:), Ref(2,:)); hold off;
    xlabel("x [m]"); ylabel("y [m]"); legend("Estimate", "Reference","Location","best");
    grid on; xlim([-3, 3]); ylim([-3, 3]);
end
%%
set(gca,'FontSize',Fontsize);  grid on; title("");
% xlabel("Time [s]");

set(gcf, "WindowState", "maximized");
set(gcf, "Position", [960 0 960 1000])
%% RMSE誤差
x = rmse(Ref(1,:),Est(1,:)) %位置
y = rmse(Ref(2,:),Est(2,:))
z = rmse(Ref(3,:),Est(3,:))
roll = rmse(Ref(4,:),Est(4,:)) %姿勢角
pitch = rmse(Ref(5,:),Est(5,:))
yaw = rmse(Ref(6,:),Est(6,:))
vx = rmse(Ref(7,:),Est(7,:)) %速度
vy = rmse(Ref(8,:),Est(8,:))
vz = rmse(Ref(9,:),Est(9,:))
%%
figure(100)
plot(logt(1:end-1), diff(logt), 'Linewidth', 1.5)
xlim([-inf inf])
