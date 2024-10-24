%2022のexperiment_figure

%% 実機実験の結果をplotするファイル
clear;
close all;
%% Initial setting
Fontsize = 16;  
set(0, 'defaultAxesFontSize',16);
set(0,'defaultTextFontsize',16);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

load("sl1023dame3syudou_Log(23-Oct-2024_16_32_26).mat");

% load("hl0729_rig3_miyatipc_no-sindou_Log(29-Jul-2024_18_41_45).mat");%
% load("sl1004hun_diag([200000,10000,100,10,10,10]),[0.005]_Log(04-Oct-2024_17_04_52).mat");
% load("Data/Eikyu_0514_result/demo_logger_0517.mat");%2回目の実験
% load("Data/Eikyu_0514_result/momoseHL_miyake_0514.mat");%単純HL@momose
%log = logger;%永久用（↓とどっちかをコメントアウト）
% log =gui.logger.Data;%gui用
%%
figtype = 2;%1でグラフを1タブづつ，2で1タブにグラフを多数．
Agent = log.Data.agent;

% arming_start_idx = find(log.Data.phase==102, 1, 'first');%フライト開始からのグラフにできる．↓と切り替え
arming_start_idx = find(log.Data.phase==115, 1, 'first');%プログラム開始からのグラフ，↑と切り替え
takeoff_start_idx = find(log.Data.phase==116, 1, 'first');%テイクオフ開始
flight_start_idx = find(log.Data.phase==102, 1, 'first');%フライト開始
takeoff_finish_idx = find(log.Data.phase==116, 1, 'last');
flight_finish_idx = find(log.Data.phase==102, 1, 'last');%)の後に-1000すれば1000フレーム前で切れる．ランディングおす1フレーム前
 logt = log.Data.t(arming_start_idx:flight_finish_idx);

%logt=linspace(0,logt(end)-logt(1),flight_finish_idx-arming_start_idx+1);%ここコメントアウトしたら0sからじゃなくなる

% initialize data
Est = zeros(12, flight_finish_idx-arming_start_idx+1);
Road_est = zeros(9, flight_finish_idx-arming_start_idx+1);
Ref = zeros(3,  flight_finish_idx-arming_start_idx+1);
Input = zeros(4,flight_finish_idx-arming_start_idx+1);
InnerInput = zeros(8, flight_finish_idx-arming_start_idx+1);
Step_time=zeros(flight_finish_idx-arming_start_idx+1,1);%アーミングからフライト
Flight_step_time=zeros(flight_finish_idx-flight_start_idx+1,1);%フライトステップのみ

Z_1=zeros(2,flight_finish_idx-arming_start_idx+1);
Z_2=zeros(6,flight_finish_idx-arming_start_idx+1);
Z_3=zeros(6,flight_finish_idx-arming_start_idx+1);
Z_4=zeros(2,flight_finish_idx-arming_start_idx+1);
for i = arming_start_idx:flight_finish_idx
    Est(:,i-arming_start_idx+1) = [Agent.estimator.result{i}.state.p;
                Agent.estimator.result{i}.state.q;
                Agent.estimator.result{i}.state.v;
                Agent.estimator.result{i}.state.w];
     Road_est(:,i-arming_start_idx+1) = [Agent.estimator.result{i}.state.pL;
                 Agent.estimator.result{i}.state.vL;
                 Agent.estimator.result{i}.state.wL];
    Ref(:,i-arming_start_idx+1) = [Agent.reference.result{i}.state.p];

    Input(:,i-arming_start_idx+1) = Agent.input{i};
% cul_step_time(i)=logt(1,i)-logt(1,i-1);
kari_logt=[0;logt(1:end-1)];
    Step_time= logt-kari_logt;
    
     InnerInput(:,i-arming_start_idx+1) = Agent.inner_input{i};
     if isfield(Agent.controller.result{flight_start_idx}, 'Z1')%Agent.controller.result{flight_start_idx}.Z1 ~= 0
z_ari=1;%zを求める場合は1になる．
    else 
    z_ari=0;
    end
      if z_ari ==1 && i >=flight_start_idx
      Z_1(:,i-arming_start_idx+1)=[Agent.controller.result{i}.Z1];
      Z_2(:,i-arming_start_idx+1)=[Agent.controller.result{i}.Z2];
      Z_3(:,i-arming_start_idx+1)=[Agent.controller.result{i}.Z3];
      Z_4(:,i-arming_start_idx+1)=[Agent.controller.result{i}.Z4];
      end
end
count_gross_over_0025=length( find( Step_time >= 0.025 ) )
count_persentage_over_0025=length( find( Step_time >= 0.025 ) )/length(Step_time)
Flight_step_time=Step_time(flight_start_idx:flight_finish_idx);
Flight_step_time_average=mean(Flight_step_time)
%%
%↓RMSE計算試作

% Parameters
A = 0; % フライト開始からの秒数 (例: 12秒後)
B = 0; % AからB秒間で計算 (例: 10秒)=0でフライト最後まで
C = 16; % テイクオフからの秒数 (例: 16秒後)
D = 17.339; % CからのD秒間で計算 (例: 6秒)=0でテイクオフ最後まで

% Calculate RMSE for flight only
flight_times = logt - logt(flight_start_idx); % フライト開始からの時間
RMSE_x_flight_only = 0;
RMSE_y_flight_only = 0;
RMSE_z_flight_only = 0;

for i = flight_start_idx:flight_finish_idx
    RMSE_x_flight_only = RMSE_x_flight_only + (Est(1, i-arming_start_idx+1) - Ref(1, i-arming_start_idx+1))^2;
    RMSE_y_flight_only = RMSE_y_flight_only + (Est(2, i-arming_start_idx+1) - Ref(2, i-arming_start_idx+1))^2;
    RMSE_z_flight_only = RMSE_z_flight_only + (Est(3, i-arming_start_idx+1) - Ref(3, i-arming_start_idx+1))^2;
end
num_samples_flight_only = flight_finish_idx - flight_start_idx + 1;
RMSE_x_flight_only = sqrt(RMSE_x_flight_only / num_samples_flight_only);
RMSE_y_flight_only = sqrt(RMSE_y_flight_only / num_samples_flight_only);
RMSE_z_flight_only = sqrt(RMSE_z_flight_only / num_samples_flight_only);

% Calculate RMSE for flight start + A seconds, B seconds period
idx_A_seconds = find(flight_times >= A, 1, 'first');
if isempty(idx_A_seconds)
    idx_A_seconds = length(flight_times); % A秒後のデータが存在しない場合は最後のデータを使う
end
idx_B_end = find(flight_times >= A + B, 1, 'first');
if isempty(idx_B_end)||B==0
    idx_B_end = flight_finish_idx; % B秒後のデータが存在しない場合or=0はフライト終了時のデータを使う
end

RMSE_x_after_A_B = 0;
RMSE_y_after_A_B = 0;
RMSE_z_after_A_B = 0;

for i = idx_A_seconds:idx_B_end
    RMSE_x_after_A_B = RMSE_x_after_A_B + (Est(1, i-arming_start_idx+1) - Ref(1, i-arming_start_idx+1))^2;
    RMSE_y_after_A_B = RMSE_y_after_A_B + (Est(2, i-arming_start_idx+1) - Ref(2, i-arming_start_idx+1))^2;
    RMSE_z_after_A_B = RMSE_z_after_A_B + (Est(3, i-arming_start_idx+1) - Ref(3, i-arming_start_idx+1))^2;
end
num_samples_after_A_B = idx_B_end - idx_A_seconds + 1;
RMSE_x_after_A_B = sqrt(RMSE_x_after_A_B / num_samples_after_A_B);
RMSE_y_after_A_B = sqrt(RMSE_y_after_A_B / num_samples_after_A_B);
RMSE_z_after_A_B = sqrt(RMSE_z_after_A_B / num_samples_after_A_B);

% Calculate RMSE for takeoff start + C seconds, D seconds period
takeoff_times = logt - logt(takeoff_start_idx); % テイクオフからの時間
takeoff_times = takeoff_times(1:takeoff_finish_idx); % テイクオフからの時間
idx_C_seconds = find(takeoff_times >= C, 1, 'first');
if isempty(idx_C_seconds)
    idx_C_seconds = length(takeoff_times); % C秒後のデータが存在しない場合は最後のデータを使う
end
idx_D_end = find(takeoff_times >= C + D, 1, 'first');
if isempty(idx_D_end)||D==0
    idx_D_end = takeoff_finish_idx; % D秒後のデータが存在しないor=0の場合はテイクオフ終了時のデータを使う
end

RMSE_x_after_C_D = 0;
RMSE_y_after_C_D = 0;
RMSE_z_after_C_D = 0;

for i = idx_C_seconds:idx_D_end
    RMSE_x_after_C_D = RMSE_x_after_C_D + (Est(1, i-arming_start_idx+1) - Ref(1, i-arming_start_idx+1))^2;
    RMSE_y_after_C_D = RMSE_y_after_C_D + (Est(2, i-arming_start_idx+1) - Ref(2, i-arming_start_idx+1))^2;
    RMSE_z_after_C_D = RMSE_z_after_C_D + (Est(3, i-arming_start_idx+1) - Ref(3, i-arming_start_idx+1))^2;
end
num_samples_after_C_D = idx_D_end - idx_C_seconds + 1;
RMSE_x_after_C_D = sqrt(RMSE_x_after_C_D / num_samples_after_C_D);
RMSE_y_after_C_D = sqrt(RMSE_y_after_C_D / num_samples_after_C_D);
RMSE_z_after_C_D = sqrt(RMSE_z_after_C_D / num_samples_after_C_D);

% Display results
fprintf('Flight-only RMSE for x direction: %.4f [m]\n', RMSE_x_flight_only);
fprintf('Flight-only RMSE for y direction: %.4f [m]\n', RMSE_y_flight_only);
fprintf('Flight-only RMSE for z direction: %.4f [m]\n', RMSE_z_flight_only);

fprintf('RMSE for x direction after %d seconds from flight start for %d seconds: %.4f [m]\n', A, B, RMSE_x_after_A_B);
fprintf('RMSE for y direction after %d seconds from flight start for %d seconds: %.4f [m]\n', A, B, RMSE_y_after_A_B);
fprintf('RMSE for z direction after %d seconds from flight start for %d seconds: %.4f [m]\n', A, B, RMSE_z_after_A_B);

fprintf('RMSE for x direction after %d seconds from takeoff for %d seconds: %.4f [m]\n', C, D, RMSE_x_after_C_D);
fprintf('RMSE for y direction after %d seconds from takeoff for %d seconds: %.4f [m]\n', C, D, RMSE_y_after_C_D);
fprintf('RMSE for z direction after %d seconds from takeoff for %d seconds: %.4f [m]\n', C, D, RMSE_z_after_C_D);


%↑RMSE計算試作
takeoff_start_time=logt(takeoff_start_idx);
flight_start_time=logt(flight_start_idx);
fprintf('Takeoff start time = %.4f [s] Flight start time = %.4f [s]\n', takeoff_start_time, flight_start_time);
%%
% m = 2; n = 3;
if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Est(4:6,:)); %hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Attitude [rad]",'Interpreter','latex'); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Est(7:9,:)); %hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Velocity [m/s]",'Interpreter','latex'); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Input [N]",'Interpreter','latex'); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InnerInput(1:4,:));legend("lever.roll","lever.pitch", "lever.thorottle", "lever.yaw",'Interpreter','latex');
%    figure(5); plot(logt, InnerInput);legend("1","2", "3", "4","5","6", "7", "8",'Interpreter','latex');
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Inner input",'Interpreter','latex'); 
    grid on; xlim([logt(1), logt(end)]); ylim([0 1000]);
    ytickformat('%.1f');
    %以下三宅整備中1/2
    figure(6); plot(Est(1,:), Est(2,:)); hold on; plot(Ref(1,:), Ref(2,:), '--'); hold off;
    grid on;xticks(-2:0.5:2);yticks(-2:0.5:2); xlim([-2.0, 2.0]); ylim([-2.0, 2.0]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Reference",'Interpreter','latex');
    %ytickformat('%.1f');
    % Title = 
    %荷物のプロット↓
    figure(7); plot(logt, Road_est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Load position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    %機体と荷物のxy重ねて表示↓
    figure(8); plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--'); hold off;
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load",'Interpreter','latex');
    grid on;xticks(-2:0.5:2);yticks(-2:0.5:2); xlim([-3.0, 3.0]); ylim([-3.0, 3.0]);pbaspect([1 1 1]);
    %目標軌道と機体と荷物のxy重ねて表示↓
    figure(9); plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
    grid on;xticks(-2:0.5:2);yticks(-2:0.5:2); xlim([-2.0, 2.0]); ylim([-2.0, 2.0]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Reference",'Interpreter','latex');
    %目標軌道と機体と荷物のxyz重ねて表示↓
    figure(10);  plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:)), hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state","$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
        %各ステップにおける計算時間表示↓
    figure(11);  plot(logt, Step_time); 
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Step time [s]",'Interpreter','latex'); legend("step time",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
 if z_ari==1
 figure(12);  plot(logt, Z_1); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi_1$$",'Interpreter','latex'); legend("$$\xi_1.1$$","$$\xi_1.2$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

     figure(13);  plot(logt, Z_2); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi_2$$",'Interpreter','latex'); legend("$$\xi_2.1$$","$$\xi_2.2$$","$$\xi_2.3$$","$$\xi_2.4$$","$$\xi_2.5$$","$$\xi_2.6$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

     figure(14);  plot(logt, Z_3); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi~3$$",'Interpreter','latex'); legend("$$\xi_3.1$$","$$\xi_3.2$$","$$\xi_3.3$$","$$\xi_3.4$$","$$\xi_3.5$$","$$\xi_3.6$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
 
     figure(15);  plot(logt, Z_4); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi_4$$",'Interpreter','latex'); legend("$$\xi_4.1$$","$$\xi_4.2$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

 end
elseif figtype == 2
%牽引物あり↓かつｚなし
if z_ari==0
    m = 2; n = 3;
 plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:)), hold off;
      subplot(m,n,1);  plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:)), hold off;
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state","$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
      grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 

    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    %牽引物なし↓
    % subplot(m,n,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    %  xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    %  grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Est(4:6,:)); %hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Attitude [rad]",'Interpreter','latex'); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Est(7:9,:)); %hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Velocity [m/s]",'Interpreter','latex'); legend("$$vx$$", "$$vy$$", "$$vz$$", "$$vx.ref$$", "$$vy.ref$$", "$$vz.ref$$", "Location","southwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Input [N]",'Interpreter','latex'); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
        subplot(m,n,5); plot(logt, InnerInput(1:4,:));
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Inner input",'Interpreter','latex');legend("lever.roll","lever.pitch", "lever.thorottle", "lever.yaw",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

    %↓三宅整備中2/2ドローン上から
    % subplot(m,n,5); plot(Est(1,:), Est(2,:)); hold on; plot(Ref(1,:), Ref(2,:), '--'); hold off;
    % xlabel("x [m]"); ylabel("y [m]"); %legend("x.state", "y.state");
    % grid on; xlim([-inf, inf]); ylim([-inf inf]);
    % subplot(m,n,5);
    % plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % grid on; xlim([-inf, inf]); ylim([-inf inf]);pbaspect([1 1 1]);
    % xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load","Reference of Load",'Interpreter','latex');
    % title("Position x-y"); 
    %ドローンの牽引物ｘｙ
    subplot(m,n,6);
    plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
    grid on; xlim([-2.0, 2.0]); ylim([-2.0, 2.0]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Load", "Reference",'Interpreter','latex');
    
else
%z_ari
m = 3; n = 3;
plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:)), hold off;
      subplot(m,n,1);  plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:)), hold off;
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state","$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
      grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 

    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    %牽引物なし↓
    % subplot(m,n,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    %  xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    %  grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Est(4:6,:)); %hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Attitude [rad]",'Interpreter','latex'); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Est(7:9,:)); %hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Velocity [m/s]",'Interpreter','latex'); legend("$$vx$$", "$$vy$$", "$$vz$$", "$$vx.ref$$", "$$vy.ref$$", "$$vz.ref$$", "Location","southwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Input [N]",'Interpreter','latex'); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    subplot(m,n,5); plot(logt, InnerInput(1:4,:));
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Inner input",'Interpreter','latex');legend("lever.roll","lever.pitch", "lever.thorottle", "lever.yaw",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    %↓三宅整備中2/2ドローン上から
    % subplot(m,n,5); plot(Est(1,:), Est(2,:)); hold on; plot(Ref(1,:), Ref(2,:), '--'); hold off;
    % xlabel("x [m]"); ylabel("y [m]"); %legend("x.state", "y.state");
    % grid on; xlim([-inf, inf]); ylim([-inf inf]);
    % subplot(m,n,5);
    % plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % grid on; xlim([-inf, inf]); ylim([-inf inf]);pbaspect([1 1 1]);
    % xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load","Reference of Load",'Interpreter','latex');
    % title("Position x-y"); 
    %ドローンの牽引物ｘｙ
    subplot(m,n,6);
    plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
    grid on; xlim([-2.0, 2.0]); ylim([-2.0, 2.0]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Load", "Reference",'Interpreter','latex');
    
subplot(m,n,7);plot(logt, Z_1); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi~1$$~($$z$$ direction)",'Interpreter','latex'); legend("$$\xi1.1$$","$$\xi1.2$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

    subplot(m,n,8);  plot(logt, Z_2); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");$
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi~2$$~($$x$$ direction)",'Interpreter','latex'); legend("$$\xi2.1$$","$$\xi2.2$$","$$\xi2.3$$","$$\xi2.4$$","$$\xi2.5$$","$$\xi2.6$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

     subplot(m,n,9);  plot(logt, Z_3); 
     % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
      xlabel("Time [s]",'Interpreter','latex'); ylabel("$$\xi~3$$~($$y$$ direction)",'Interpreter','latex'); legend("$$\xi3.1$$","$$\xi3.2$$","$$\xi3.3$$","$$\xi3.4$$","$$\xi3.5$$","$$\xi3.6$$",  "Location","northwest",'Interpreter','latex');
     grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
end
    figure(10);  plot(logt, Step_time); 
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Step time [s]",'Interpreter','latex'); legend("step time",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
end
%%
set(gca,'FontSize',Fontsize);  grid on; title("");
%xlabel("Time [s]");%x軸が勝手にTimeになっていたので消した

set(gcf, "WindowState", "maximized");
set(gcf, "Position", [960 0 960 1000])