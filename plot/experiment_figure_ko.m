%2022のexperiment_figure

%% 実機実験の結果をplotするファイル
clear;
close all;
%% Initial setting
Fontsize = 15;  
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

load("0801nabu_temoti_8goutai_Log(01-Aug-2024_11_51_01).mat");
% load("hl0729_rig3_miyatipc_no-sindou_Log(29-Jul-2024_18_41_45).mat");%
%load("sl800_hovering_Log(01-Jul-2024_16_33_08).mat");
% load("Data/Eikyu_0514_result/demo_logger_0517.mat");%2回目の実験
% load("Data/Eikyu_0514_result/momoseHL_miyake_0514.mat");%単純HL@momose
%log = logger;%永久用（↓とどっちかをコメントアウト）
% log =gui.logger.Data;%gui用
%%
figtype = 1;%1でグラフを1タブづつ，2で1タブにグラフを多数．
Agent = log.Data.agent;

% arming_start_idx = find(log.Data.phase==102, 1, 'first');%フライト開始からのグラフにできる．↓と切り替え
arming_start_idx = find(log.Data.phase==115, 1, 'first');%アーミング開始↑と切り替え
flight_start_idx = find(log.Data.phase==102, 1, 'first');%フライト開始
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
for i = arming_start_idx:flight_finish_idx
    Est(:,i-arming_start_idx+1) = [Agent.estimator.result{i}.state.p;
                Agent.estimator.result{i}.state.q;
                Agent.estimator.result{i}.state.v;
                Agent.estimator.result{i}.state.w];
    % Road_est(:,i-arming_start_idx+1) = [Agent.estimator.result{i}.state.pL;
    %             Agent.estimator.result{i}.state.vL;
    %             Agent.estimator.result{i}.state.wL];
    Ref(:,i-arming_start_idx+1) = [Agent.reference.result{i}.state.p];

    Input(:,i-arming_start_idx+1) = Agent.input{i};
% cul_step_time(i)=logt(1,i)-logt(1,i-1);
kari_logt=[0;logt(1:end-1)];
    Step_time= logt-kari_logt;
    
    InnerInput(:,i-arming_start_idx+1) = Agent.inner_input{i};
end
count_gross_over_0025=length( find( Step_time >= 0.025 ) )
count_persentage_over_0025=length( find( Step_time >= 0.025 ) )/length(Step_time)
Flight_step_time=Step_time(flight_start_idx:flight_finish_idx);
Flight_step_time_average=mean(Flight_step_time)
m = 4; n = 3;
if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Est(4:6,:)); %hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Est(7:9,:)); %hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InnerInput);legend("1","2", "3", "4","5","6", "7", "8");
    xlabel("Time [s]"); ylabel("Inner Input"); 
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    %以下三宅整備中1/2
    figure(6); plot(Road_est(1,:), Road_est(2,:)); hold on; plot(Ref(1,:), Ref(2,:), '--'); hold off;
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Estimeter", "Reference",'Interpreter','latex');
    grid on; xlim([-3.0, 3.0]); ylim([-3.0, 3.0]);pbaspect([1 1 1]);
    %ytickformat('%.1f');
    % Title = 
    %荷物のプロット↓
    figure(7); plot(logt, Road_est(1:3,:)); hold on; plot(logt, Ref(1:3,:), '--'); hold off;
    xlabel("Time [s]",'Interpreter','latex'); ylabel("Load position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    %機体と荷物のxy重ねて表示↓
    figure(8); plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--'); hold off;
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load",'Interpreter','latex');
    grid on; xlim([-3.0, 3.0]); ylim([-3.0, 3.0]);pbaspect([1 1 1]);
    %目標軌道と機体と荷物のxy重ねて表示↓
    figure(9); plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
    grid on; xlim([-3.0, 3.0]); ylim([-3.0, 3.0]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load","Reference of Load",'Interpreter','latex');
    %目標軌道と機体と荷物のxyz重ねて表示↓
    figure(10);  plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:));, hold off;
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state","$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
        %各ステップにおける計算時間表示↓
    figure(11);  plot(logt, Step_time); 
    % xlabel("x [m]"); ylabel("y [m]"); legend("Drone", "Load","Reference of Load");
     xlabel("Time [s]",'Interpreter','latex'); ylabel("step time [s]",'Interpreter','latex'); legend("step time",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
elseif figtype == 2
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Est(4:6,:)); %hold on; plot(logt, Ref(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Est(7:9,:)); %hold on; plot(logt, Ref(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","southwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Input, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","northwest");
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    ytickformat('%.1f');
    % % virtual input
    % subplot(m,n,5); plot(logt, InnerInput); 
    % xlabel("Time [s]"); ylabel("Inner input");legend("z","roll", "pitch", "yaw");%キャプション間違ってるかも
    % grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    %↓三宅整備中2/2ドローン上から
    % subplot(m,n,5); plot(Est(1,:), Est(2,:)); hold on; plot(Ref(1,:), Ref(2,:), '--'); hold off;
    % xlabel("x [m]"); ylabel("y [m]"); %legend("x.state", "y.state");
    % grid on; xlim([-inf, inf]); ylim([-inf inf]);
    subplot(m,n,5);
    plot(Est(1,:), Est(2,:)); hold on; plot(Road_est(1,:), Road_est(2,:), '--');plot(Ref(1,:), Ref(2,:), '--'), hold off;
    grid on; xlim([-inf, inf]); ylim([-inf inf]);pbaspect([1 1 1]);
    xlabel('$$x$$ [m]','Interpreter','latex'); ylabel("$$y$$ [m]",'Interpreter','latex'); legend("Drone", "Load","Reference of Load",'Interpreter','latex');
    title("Position x-y"); 
    %ドローン荷物ｘｙｚ
    subplot(m,n,6);
    plot(logt, Road_est(1:3,:), '--'); hold on; plot(logt, Est(1:3,:), '--');plot(logt, Ref(1:3,:));, hold off;
     xlabel("Time [s]",'Interpreter','latex'); ylabel("Position [m]",'Interpreter','latex'); legend("$$x$$.Load state", "$$y$$.Load state", "$$z$$.Load state","$$x$$.Drone state", "$$y$$.Drone state", "$$z$$.Drone state", "$$x$$.Reference", "$$y$$.Reference", "$$z$$.Reference",  "Location","northwest",'Interpreter','latex');
    grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
    title("Position x-y-z"); 
end
%%
set(gca,'FontSize',Fontsize);  grid on; title("");
%xlabel("Time [s]");%x軸が勝手にTimeになっていたので消した

set(gcf, "WindowState", "maximized");
set(gcf, "Position", [960 0 960 1000])