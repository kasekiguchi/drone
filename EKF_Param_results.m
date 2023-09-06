%% GUI projectの情報を用いたパラメータ解析
% EKFによるパラメータ推定の結果確認
%% Initialize settings
% set path
% clear
% cf = pwd;
% if contains(mfilename('fullpath'),"mainGUI")
%   cd(fileparts(mfilename('fullpath')));
% else
%   tmp = matlab.desktop.editor.getActive; 
%   cd(fileparts(tmp.Filename));
% end
% [~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
% cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
% % cd(cf); close all hidden; clear all; userpath('clear');

%% フラグ設定
illustration= 1; %1で図示，0で非表示
log = LOGGER('./Data/time1500_Log(06-Sep-2023_12_02_02).mat');
flag_png=0;
%% ログ
tspan = [0 ,100];
% tspan = [0 99];
robot_p  = log.data(1,"p","p")';
robot_pe  = log.data(1,"p","e")';
robot_q  = log.data(1,"q","p")';
robot_qe  = log.data(1,"q","e")';
sensor_data = (log.data(1,"length","s"))';
ref_p = log.data(1,"p","r")';
ref_q = log.data(1,"q","r")';
robot_v  = log.data(1,"v","p")';
robot_ve  = log.data(1,"v","e")';
robot_w  = log.data(1,"w","p")';
robot_we  = log.data(1,"w","e")';
%% 
last=length(robot_pe);
len = length(log.Data.agent.sensor.result);
ps  = zeros(size(log.Data.agent.estimator.result{1,1}.state.ps,1),len);
qs  = zeros(size(log.Data.agent.estimator.result{1,1}.state.qs,1),len);
% l  = zeros(size(log.Data.agent.estimator.result{1,1}.state.l,1),len);
P  = zeros(size(log.Data.agent.estimator.result{1,1}.P,1),size(log.Data.agent.estimator.result{1,1}.P,2),len);
for i=1:len
    ps(:,i) = log.Data.agent.estimator.result{1,i}.state.ps;
    qs(:,i) = log.Data.agent.estimator.result{1,i}.state.qs;
    % l(:,i) = log.Data.agent.estimator.result{1,i}.state.l;
    P(:,:,i)  = log.Data.agent.estimator.result{1,i}.P;
end
steps=1:length(robot_pe);
time = 0.01*steps;
%% 真値
offset_true = [0.01;0.01;0.01];
Rs_true = Rodrigues([0,0,1],pi/2);
w=[0,1,0,-9];
% 交点比較
for i=1:length(robot_pe)
    sp(:,i) = robot_pe(:,i) + eul2rotm(robot_qe(:,i)','XYZ')*ps(:,end) + sensor_data(1,i)*eul2rotm(robot_qe(:,i)','XYZ')*RodriguesQuaternion(Eul2Quat(qs(:,end)))*[1;0;0];
end
fig12=figure(12);
fig12.Color = 'white';
plot(time,sp(1,:));
hold on;
plot(time,sp(2,:));
plot(time,sp(3,:));
% legend('x','y','z');
ss=log.data(1,"sensor.result.sensor_points","s");
ss=zeros(3,last);
for i2=1:last
    ss(:,i2)=log.Data.agent.sensor.result{1,i2}.sensor_points(:,1);
end
plot(time,ss(1,:),'LineWidth', 2);
plot(time,ss(2,:),'LineWidth', 2);
plot(time,ss(3,:),'LineWidth', 2);
legend('x','y','z','x_t','y_t','z_t','FontSize', 18);
xlabel('time [s]','FontSize', 16);
ylabel('Coordinates of intersection [m]','FontSize', 16);
hold off ;

ye = zeros(1,size(sensor_data,2));
for j=1:length(robot_pe)
    ye(j) = (-w(4)-w(1:3)*(robot_pe(:,j) + eul2rotm(robot_qe(:,j)','XYZ')*ps(:,end)))/(w(1:3)*(eul2rotm(robot_qe(:,j)','XYZ')*RodriguesQuaternion(Eul2Quat(qs(:,end)))*[1;0;0]));
end
fig20=figure(20);
fig20.Color = 'white';
plot(time,sensor_data(1,:));
hold on;
plot(time,ye(1,:));
xlabel('time [s]','FontSize', 16)
ylabel('Distance of the lidar [m]','FontSize', 16);
legend('true','estimate','FontSize', 18);
grid on;
%%
variance = zeros(size(P,2),size(P,3));
for j=1:size(P,3)
    variance(:,j) = diag(P(:,:,j));
end
%% RMSE
MSE_P=mse(robot_p,robot_pe);
MSE_Q=mse(robot_q,robot_qe);

% %% 可観測性みる
% A = log.Data.agent.estimator.result{1,2}.A;
% C = log.Data.agent.estimator.result{1,2}.C;
% n = size(A, 1); % 状態ベクトルの次元
% O = []; % 可観測性行列を初期化
% % システムの次元を取得する
% [n, ~] = size(A);
% 
% % 可観測性行列 O を計算する
% O = [];
% for i = 0:(n-1)
%     O = [O; C * (A^i)];
% end
% 
% % 可観測性行列 O のランクを計算する
% rank_O = rank(O);
% 
% % システムの次元からランクを引いて不可観測部分空間の次元を計算する
% unobservable_dimension = n - rank_O;
% 
% % 可観測部分空間と不可観測部分空間を計算する
% observable_subspace = null(O);  % 可観測部分空間
% % 不可観測部分空間を計算する
% unobservable_subspace = null(A - observable_subspace' * C');  % 不可観測部分空間
%% 図示
if illustration == 1
    fig1=figure(1);
    fig1.Color = 'white';
    plot(time,robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_p(2,:),'LineWidth', 2);
    plot(time,robot_p(3,:),'LineWidth', 2);
    plot(time,robot_pe(1,:),'LineWidth', 2);
    plot(time,robot_pe(2,:),'LineWidth', 2);
    plot(time,robot_pe(3,:),'LineWidth', 2);
    legend('\it{px}','\it{py}','\it{pz}','\it{px_e}','\it{py_e}','\it{pz_e}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('position \it{p} [m]','FontSize', 16);
    grid on;
    fig2=figure(2);
    fig2.Color = 'white';
    plot(time,robot_q(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_q(2,:),'LineWidth', 2);
    plot(time,robot_q(3,:),'LineWidth', 2);
    plot(time,robot_qe(1,:),'LineWidth', 2);
    plot(time,robot_qe(2,:),'LineWidth', 2);
    plot(time,robot_qe(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi','\phi_{e}','\theta_{e}','\psi_{e}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('angle \it{q} [rad]','FontSize', 16);
    grid on;
    fig3=figure(3);
    fig3.Color = 'white';
    plot(time,ref_p(1,:),'LineWidth', 2);
    hold on;
    plot(time,ref_p(2,:),'LineWidth', 2);
    plot(time,ref_p(3,:),'LineWidth', 2);
    legend('x','y','z');
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('ref p[m]','FontSize', 16);
    grid on;
    fig4=figure(4);
    fig4.Color = 'white';
    plot(time,ref_q(1,:),'LineWidth', 2);
    hold on;
    plot(time,ref_q(2,:),'LineWidth', 2);
    plot(time,ref_q(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi');
    hold off;
    xlabel('step');
    ylabel('ref q');
    grid on;
    % 分散
    fig5=figure(5);
    fig5.Color = 'white';
    plot(time,variance(1,:),'LineWidth', 2);
    hold on;
    plot(time,variance(2,:),'LineWidth', 2);
    plot(time,variance(3,:),'LineWidth', 2);
    plot(time,variance(4,:),'LineWidth', 2);
    plot(time,variance(5,:),'LineWidth', 2);
    plot(time,variance(6,:),'LineWidth', 2);
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('variance of wall param','FontSize', 16);
    legend('p_x','p_y','p_z','\phi','\theta','\psi');
    grid on;
    fig6=figure(6);
    fig6.Color = 'white';
    plot(time,sensor_data(1,:));
    hold on;
    plot(time,sensor_data(2,:));
    % plot(sensor_data(8,:));
    % plot(sensor_data(9,:));
    xlabel('time [s]','FontSize', 16)
    ylabel('Distance of the lidar [m]','FontSize', 16);
    legend('1st','2nd','FontSize', 18);
    grid on;
    fig7=figure(7);
    fig7.Color = 'white';
    plot(time,robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_p(2,:),'LineWidth', 2);
    plot(time,robot_p(3,:),'LineWidth', 2);
    plot(time,robot_pe(1,:),'LineWidth', 2);
    plot(time,robot_pe(2,:),'LineWidth', 2);
    plot(time,robot_pe(3,:),'LineWidth', 2);
    legend('\it{p_x}','\it{p_y}','\it{p_z}','\it{p_{ex}}','\it{p_{ey}}','\it{p_{ez}}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('position \it{p} [m]','FontSize', 16);
    xlim([0, 20]);
    grid on;
    fig8=figure(8);
    fig8.Color = 'white';
    plot(time,robot_q(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_q(2,:),'LineWidth', 2);
    plot(time,robot_q(3,:),'LineWidth', 2);
    plot(time,robot_qe(1,:),'LineWidth', 2);
    plot(time,robot_qe(2,:),'LineWidth', 2);
    plot(time,robot_qe(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi','\phi_{e}','\theta_{e}','\psi_{e}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('angle \it{q} [rad]','FontSize', 16);
    xlim([0, 20]);
    grid on;
    fig9=figure(9);
    fig9.Color = 'white';
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    hold on;
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,ps(1,:),'LineWidth', 3);
    plot(time,ps(2,:),'LineWidth', 3);
    plot(time,ps(3,:),'LineWidth', 3);
    legend('\it{psb_{x}}','\it{psb_{y}}','\it{psb_{z}}','\it{psb_{ex}}','\it{psb_{ey}}','\it{psb_{ez}}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('\it{p}_{SB} [m]','FontSize', 16);
    % xlim([0, 20]);
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    plot(time,0*ones(size(time)),'LineWidth', 3);
        hold on;
    plot(time,0*ones(size(time)),'LineWidth', 3);
    plot(time,(pi/2)*ones(size(time)),'LineWidth', 3);
    plot(time,qs(1,:),'LineWidth', 3);
    plot(time,qs(2,:),'LineWidth', 3);
    plot(time,qs(3,:),'LineWidth', 3);
    % xlim([0, 20]);
    ylim([0 2]);
    legend('qs_{\phi}','qs_{\theta}','qs_{\psi}','qs_{e \phi}','qs_{e \theta}','qs_{e \psi}','FontSize', 18);
    xlabel('time [s]','FontSize', 16)
    ylabel('\it{q}_S [rad]','FontSize', 16);
    hold off;
    fig11=figure(11);
    fig11.Color = 'white';
    plot(time,robot_v(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_v(2,:),'LineWidth', 2);
    plot(time,robot_v(3,:),'LineWidth', 2);
    plot(time,robot_ve(1,:),'LineWidth', 2);
    plot(time,robot_ve(2,:),'LineWidth', 2);
    plot(time,robot_ve(3,:),'LineWidth', 2);
    legend('\it{v_x}','\it{v_y}','\it{v_z}','\it{v_{ex}}','\it{v_{ey}}','\it{v_{ez}}','FontSize', 18);
    xlim([0, 20]);
    hold off;
    fig13=figure(13);
    fig13.Color = 'white';
    plot(time,robot_w(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_w(2,:),'LineWidth', 2);
    plot(time,robot_w(3,:),'LineWidth', 2);
    plot(time,robot_we(1,:),'LineWidth', 2);
    plot(time,robot_we(2,:),'LineWidth', 2);
    plot(time,robot_we(3,:),'LineWidth', 2);
    legend('\it{w}','\it{w}','\it{w}','\it{w_{e \phi}}','\it{w_{e \theta}}','\it{w_{e \psi}}','FontSize', 18);
    xlim([0, 20]);
    hold off;
end
if flag_png==1
    pass2 = 'C:\Users\yuika\Desktop\修士\中間発表\ppt';
    saveas(fig7, fullfile(pass2, 'EKF_pos.png'));
    saveas(fig8, fullfile(pass2, 'EKF_ang.png'));
    saveas(fig1, fullfile(pass2, 'EKF_posAll.png'));
    saveas(fig9, fullfile(pass2, 'EKF_psb.png'));
    saveas(fig10, fullfile(pass2, 'EKF_qs.png'));
    saveas(fig2, fullfile(pass2, 'EKF_angAll.png'));
    saveas(fig12, fullfile(pass2, 'EKF_inst.png'));
    saveas(fig11, fullfile(pass2, 'EKF_v.png'));
    saveas(fig13, fullfile(pass2, 'EKF_w.png'));
end