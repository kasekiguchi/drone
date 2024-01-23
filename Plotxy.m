%% GUI projectの情報を用いたパラメータ解析
% EKFによるパラメータ推定の結果確認
%% Initialize settings
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
% cd(cf); close all hidden; clear all; userpath('clear');
% 
% close all;
%% フラグ設定
illustration= 1; %1で図示，0で非表示
log = LOGGER('./Data/u_correct1212_1.mat');
O_func = @(x,u) On3_1_new(x,u);
% log = LOGGER('./Data/Log(17-Oct-2023_00_40_58).mat');
f_png=0;
f_eps=1;
f_offset = 0;
f_O = 0;
f_wall = 0;
f_PDAF = 0;
%% ログ
tspan = [0 ,100];
maxt = 30;
dt = 0.01;
% tspan = [0 99];xlim([0, maxt]);
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
%% RMSE
RMSE_P=sqrt(mse(robot_p,robot_pe));
RMSE_Q=sqrt(mse(robot_q,robot_qe));
RMSE_V=sqrt(mse(robot_v,robot_ve));
RMSE_W=sqrt(mse(robot_w,robot_we));
RMSE_all = [RMSE_P;RMSE_Q;RMSE_V;RMSE_W]
RMSE_P=sqrt(mse(robot_p(:,((maxt/dt)-500):end),robot_pe(:,((maxt/dt)-500):end)));
RMSE_Q=sqrt(mse(robot_q(:,((maxt/dt)-500):end),robot_qe(:,((maxt/dt)-500):end)));
RMSE_V=sqrt(mse(robot_v(:,((maxt/dt)-500):end),robot_ve(:,((maxt/dt)-500):end)));
RMSE_W=sqrt(mse(robot_w(:,((maxt/dt)-500):end),robot_we(:,((maxt/dt)-500):end)));
RMSE_end = [RMSE_P;RMSE_Q;RMSE_V;RMSE_W]
%% 
last=length(robot_pe);
len = length(log.Data.agent.sensor.result);
P  = zeros(size(log.Data.agent.estimator.result{1,1}.P,1),size(log.Data.agent.estimator.result{1,1}.P,2),len-1);
A  = zeros(size(log.Data.agent.estimator.result{1,2}.A,1),size(log.Data.agent.estimator.result{1,2}.A,2),len-1);
C  = zeros(size(log.Data.agent.estimator.result{1,2}.C,1),size(log.Data.agent.estimator.result{1,2}.C,2),len-1);

fig1=figure(1);
fig1.Color = 'white';
plot(robot_pe(1,:),robot_pe(2,:),'LineWidth', 2);
hold on;
plot(robot_p(1,:),robot_p(2,:),'LineWidth', 2);
plot(ref_p(1,:),ref_p(2,:),'LineWidth', 2);
hold off;
lgd1=legend('estimated value','true value','reference','FontSize', 16);
xlabel('x [m]','FontSize', 16)
ylabel('y [m]','FontSize', 16);
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
grid on;
set(gca,'FontSize',14);
pbaspect([1 1 1]);
pass2 = 'C:\Users\student\Desktop\Nozaki\inputs'; %P:192.168.100.20 PC
saveas(fig1, fullfile(pass2, 'xyg.eps'), 'epsc');
saveas(fig1, fullfile(pass2, 'xyg.png'));