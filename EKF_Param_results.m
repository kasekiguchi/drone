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
log = LOGGER('./Data/ttest_Log(28-Aug-2023_14_22_29).mat');

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

len = length(log.Data.agent.sensor.result);
% ps  = zeros(size(log.Data.agent.estimator.result{1,1}.state.ps,1),len);
% qs  = zeros(size(log.Data.agent.estimator.result{1,1}.state.qs,1),len);
% l  = zeros(size(log.Data.agent.estimator.result{1,1}.state.l,1),len);
P  = zeros(size(log.Data.agent.estimator.result{1,1}.P,1),size(log.Data.agent.estimator.result{1,1}.P,2),len);
% for i=1:len
%     ps(:,i) = log.Data.agent.estimator.result{1,i}.state.ps;
%     qs(:,i) = log.Data.agent.estimator.result{1,i}.state.qs;
%     % l(:,i) = log.Data.agent.estimator.result{1,i}.state.l;
%     P(:,:,i)  = log.Data.agent.estimator.result{1,i}.P;
% end
%% 真値
offset_true = [0.1;0.05;0.0];
Rs_true = Rodrigues([0,0,1],pi/12);
w=[0,1,0,9];
%% 交点比較
% for i=1:length(robot_pe)
%     sp(:,i) = robot_pe(:,i) + eul2rotm(robot_qe(:,i)','XYZ')*ps(:,end) + sensor_data(1,i)*eul2rotm(robot_qe(:,i)','XYZ')*RodriguesQuaternion(Eul2Quat(qs(:,end)))*[1;0;0];
% end
% figure(12);
% plot(sp(1,:));
% hold on;
% plot(sp(2,:));
% plot(sp(3,:));
% legend('x','y','z');
%%
variance = zeros(size(P,2),size(P,3));
for j=1:size(P,3)
    variance(:,j) = diag(P(:,:,j));
end
%% 図示
if illustration == 1
    fig1=figure(1);
    fig1.Color = 'white';
    plot(robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(robot_p(2,:),'LineWidth', 2);
    plot(robot_p(3,:),'LineWidth', 2);
    plot(robot_pe(1,:),'LineWidth', 2);
    plot(robot_pe(2,:),'LineWidth', 2);
    plot(robot_pe(3,:),'LineWidth', 2);
    legend('\it{px}','\it{py}','\it{pz}','\it{pxe}','\it{pye}','\it{pze}','FontSize', 18);
    hold off;
    xlabel('step');
    ylabel('[m]');
    grid on;
    fig2=figure(2);
    fig2.Color = 'white';
    plot(robot_q(1,:),'LineWidth', 2);
    hold on;
    plot(robot_q(2,:),'LineWidth', 2);
    plot(robot_q(3,:),'LineWidth', 2);
    plot(robot_qe(1,:),'LineWidth', 2);
    plot(robot_qe(2,:),'LineWidth', 2);
    plot(robot_qe(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi','\phi_{e}','\theta_{e}','\psi_{e}','FontSize', 18);
    hold off;
    xlabel('step');
    ylabel('angle');
    grid on;
    fig3=figure(3);
    fig3.Color = 'white';
    plot(ref_p(1,:),'LineWidth', 2);
    hold on;
    plot(ref_p(2,:),'LineWidth', 2);
    plot(ref_p(3,:),'LineWidth', 2);
    legend('x','y','z');
    hold off;
    xlabel('step');
    ylabel('ref p[m]');
    grid on;
    fig4=figure(4);
    fig4.Color = 'white';
    plot(ref_q(1,:),'LineWidth', 2);
    hold on;
    plot(ref_q(2,:),'LineWidth', 2);
    plot(ref_q(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi');
    hold off;
    xlabel('step');
    ylabel('ref q');
    grid on;
    % 分散
    fig5=figure(5);
    fig5.Color = 'white';
    plot(variance(1,:),'LineWidth', 2);
    hold on;
    plot(variance(2,:),'LineWidth', 2);
    plot(variance(3,:),'LineWidth', 2);
    plot(variance(4,:),'LineWidth', 2);
    plot(variance(5,:),'LineWidth', 2);
    plot(variance(6,:),'LineWidth', 2);
    hold off;
    xlabel('step');
    ylabel('variance of wall param');
    legend('p_x','p_y','p_z','\phi','\theta','\psi');
    grid on;
    fig6=figure(6);
    fig6.Color = 'white';
    plot(sensor_data(1,:));
    hold on;
    plot(sensor_data(2,:));
    % plot(sensor_data(8,:));
    % plot(sensor_data(9,:));
    xlabel('step','FontSize', 14);
    ylabel('Distance of the lidar [m]','FontSize', 14);
    legend('1st','2nd');
    grid on;
end
