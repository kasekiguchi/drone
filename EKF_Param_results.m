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

%% フラグ設定
illustration= 1; %1で図示，0で非表示
log = LOGGER('./Data/Log(25-Oct-2023_18_05_11).mat');
% log = LOGGER('./Data/Log(17-Oct-2023_00_40_58).mat');
flag_png=0;
flag_eps=0;
flag_offset = 1;
flag_O = 0;
flag_wall = 0;
%% ログ
tspan = [0 ,100];
maxt = 60;
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
RMSE_P=sqrt(mse(robot_p(:,((maxt/0.01)-1000):end),robot_pe(:,((maxt/0.01)-1000):end)));
RMSE_Q=sqrt(mse(robot_q(:,((maxt/0.01)-1000):end),robot_qe(:,((maxt/0.01)-1000):end)));
RMSE_V=sqrt(mse(robot_v(:,((maxt/0.01)-1000):end),robot_ve(:,((maxt/0.01)-1000):end)));
RMSE_W=sqrt(mse(robot_w(:,((maxt/0.01)-1000):end),robot_we(:,((maxt/0.01)-1000):end)));
[RMSE_P;RMSE_Q;RMSE_V;RMSE_W]
%% 
last=length(robot_pe);
len = length(log.Data.agent.sensor.result);
P  = zeros(size(log.Data.agent.estimator.result{1,1}.P,1),size(log.Data.agent.estimator.result{1,1}.P,2),len-1);
A  = zeros(size(log.Data.agent.estimator.result{1,2}.A,1),size(log.Data.agent.estimator.result{1,2}.A,2),len-1);
C  = zeros(size(log.Data.agent.estimator.result{1,2}.C,1),size(log.Data.agent.estimator.result{1,2}.C,2),len-1);
if flag_offset == 1
ps  = zeros(size(log.Data.agent.estimator.result{1,1}.state.ps,1),len);
qs  = zeros(size(log.Data.agent.estimator.result{1,1}.state.qs,1),len);
% l  = zeros(size(log.Data.agent.estimator.result{1,1}.state.l,1),len);
u  = zeros(size(log.Data.agent.input{1,1},1),len);
param = log.Data.agent.estimator.result{1,2}.param;
% l  = zeros(size(log.Data.agent.estimator.result{1,1}.state.l,1),len);
for i=1:len
    ps(:,i) = log.Data.agent.estimator.result{1,i}.state.ps;
    qs(:,i) = log.Data.agent.estimator.result{1,i}.state.qs;
    % l(:,i) = log.Data.agent.estimator.result{1,i}.state.l;
    P(:,:,i)  = log.Data.agent.estimator.result{1,i}.P;
    u(:,i) = log.Data.agent.input{1,i};
end

for i=2:len
    A(:,:,i)  = log.Data.agent.estimator.result{1,i}.A;
    C(:,:,i)  = log.Data.agent.estimator.result{1,i}.C;
end
end
for i = 1:length(qs)
qs(1,i) = roundpi(qs(1,i)) ;
qs(2,i) = roundpi(qs(2,i)) ;
qs(3,i) = roundpi(qs(3,i)) ;
end
if flag_wall == 1
    l  = zeros(size(log.Data.agent.estimator.result{1,1}.state.l,1),len);
for i=1:len
    l(:,i) = log.Data.agent.estimator.result{1,i}.state.l;
end
end
steps=1:length(robot_pe);
time = 0.01*steps;
meanps = [mean(ps(1,((maxt/0.01)-1000):end)),mean(ps(2,((maxt/0.01)-1000):end)),mean(ps(3,((maxt/0.01)-1000):end))]
meanqs = [mean(qs(1,((maxt/0.01)-1000):end)),mean(qs(2,((maxt/0.01)-1000):end)),mean(qs(3,((maxt/0.01)-1000):end))]
%%
 fig9=figure(9);
    fig9.Color = 'white';
    plot(time,ps(1,:),'LineWidth', 3);
        hold on;
    plot(time,ps(2,:),'LineWidth', 3);
    plot(time,ps(3,:),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    lgd=legend('\it{psb_{xe}}','\it{psb_{ye}}','\it{psb_{ze}}','\it{psb_{x}}','\it{psb_{y}}','\it{psb_{z}}','FontSize', 18,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlim([0, maxt]);
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{p}_{SB} [m]','FontSize', 16);
%     ylim([-1, 1]);
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    plot(time,qs(1,:),'LineWidth', 3);
    hold on;
    plot(time,qs(2,:),'LineWidth', 3);
    plot(time,qs(3,:),'LineWidth', 3);
     plot(time,0*ones(size(time)),'LineWidth', 3);
    plot(time,0*ones(size(time)),'LineWidth', 3);
    plot(time,(pi/2)*ones(size(time)),'LineWidth', 3);
    xlim([0, maxt]);
%     ylim([-1 2]);
    lgd = legend('qs_{\phi e}','qs_{\theta e}','qs_{\psi e}','qs_{\phi}','qs_{\theta}','qs_{\psi}','FontSize', 18,'Location', 'Best');
    lgd.NumColumns = 2;
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{q}_S [rad]','FontSize', 16);
    hold off;
%% 真値
if flag_offset==1
offset_true = [0.01;0.01;0.01];
Rs_true = Rodrigues([0,0,1],pi/2);
w=[0,1,0,-9];
% 交点比較
for i=1:length(robot_pe)
    sp(:,i) = robot_pe(:,i) + eul2rotm(robot_qe(:,i)','XYZ')*ps(:,i) + sensor_data(1,i)*eul2rotm(robot_qe(:,i)','XYZ')*RodriguesQuaternion(Eul2Quat(qs(:,i)))*[1;0;0];
end
fig12=figure(12);
fig12.Color = 'white';
plot(time,sp(1,:));
hold on;
plot(time,sp(2,:));
plot(time,sp(3,:));
xlim([0 maxt]);
% legend('x','y','z');
ss=log.data(1,"sensor.result.sensor_points","s");
ss=zeros(3,last);
for i2=1:last
    ss(:,i2)=log.Data.agent.sensor.result{1,i2}.sensor_points(:,1);
end
plot(time,ss(1,:),'LineWidth', 2);
plot(time,ss(2,:),'LineWidth', 2);
plot(time,ss(3,:),'LineWidth', 2);
lgd = legend('x','y','z','x_t','y_t','z_t','FontSize', 16,'Location', 'Best');
lgd.NumColumns = 2;
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
legend('true','estimate','FontSize', 16,'Location', 'Best');
grid on;
end
%% 可観測性
% 可観測性行列 O を計算する(線形のやつで)
Ob = [];
n=18;
num = 20;
for i = 0 : (n-1)
    Ob = [Ob; C(:,:,num-i) * (A(:,:,num-i)^i)];
end
Xo_ = null(Ob,"rational");
rank(Ob);
RankOl = zeros(1,length(robot_pe));
for i=1:length(robot_pe)
    Ol = obsv(A(:,:,i),C(:,:,i));
    RankOl(i) = rank(Ol);
end
Ol = obsv(A(:,:,2),C(:,:,2));
rank(Ol)
%% 非線形システムの可観測性
if flag_O == 1
tmpmethod = str2func(get_model_name("RPY 12"));
% fmethod = @(t,x,p) [tmpmethod(t,x,p); zeros(6,1)];
fmethod = @(t,x,p) [tmpmethod(t,x,p); zeros(10,1)];
wall_param = [0,1,0,-9];
% hmethod = @(x,p) H_18_2(x,wall_param,p);
hmethod = @(x,p) H_18(x,p);
% x = sym('x',[18,1]);
x = sym('x',[22,1]);
u = sym('u',[4,1]);
syms x [22 1]
syms u [4 1]
f=fmethod(x,u,param);
h = hmethod(x,param);
syms q [21 1]
for i=1:3
    if i == 1
        Lfh = h;
        q(1:8*i) = Lfh;
    else
        Lfh = jacobian(Lfh,x)*f;
        q(1+8*(i-1):8*i)= Lfh;
        i
    end
end
On = jacobian(q,x);
matlabFunction(On,'File','On3_1','vars',{x,u})
end
Rank = zeros(1,len);
minS = zeros(1,len);
maxS = zeros(1,len);
D = zeros(1,len);
if flag_wall == 1
    S = zeros(22,len);
    x = [robot_pe(:,1);robot_qe(:,1);robot_ve(:,1);robot_we(:,1);ps(:,1);qs(:,1);l(:,1)];
    On = zeros(size(On3_w(x,u(:,1)),1),size(On3_w(x,u(:,1)),2),len);
    for i=1:len
%     x = [robot_pe(:,i);robot_qe(:,i);robot_ve(:,i);robot_we(:,i);ps(:,i);qs(:,i)];
        x = [robot_pe(:,i);robot_qe(:,i);robot_ve(:,i);robot_we(:,i);ps(:,i);qs(:,i);l(:,i)];
        On(:,:,i) = On3_l1(x,u(:,i));
        Rank(i) = rank(On3_w(x,u(:,i)));
        S(:,i) = svd(On(:,:,i));
        minS(i) = min(S(:,i));
        maxS(i) = max(S(:,i));
        D(i) = 1/(maxS(i)/minS(i));
    end
else
    U = zeros(21,21,len);
    V = zeros(18,18,len);
    S = zeros(18,len);
    x = [robot_pe(:,1);robot_qe(:,1);robot_ve(:,1);robot_we(:,1);ps(:,1);qs(:,1)];
    On = zeros(size(On3_l1(x,u(:,1)),1),size(On3_l1(x,u(:,1)),2),len);
    for i=1:len
%     x = [robot_pe(:,i);robot_qe(:,i);robot_ve(:,i);robot_we(:,i);ps(:,i);qs(:,i)];
        x = [robot_pe(:,i);robot_qe(:,i);robot_ve(:,i);robot_we(:,i);ps(:,i);qs(:,i)];
        On(:,:,i) = On3_l1(x,u(:,i));
        Rank(i) = rank(On3_l1(x,u(:,i)));
        S(:,i) = svd(On(:,:,i));
        [U(:,:,i),~,V(:,:,i)] = svd(On(:,:,i));
        minS(i) = min(S(:,i));
        maxS(i) = max(S(:,i));
        D(i) = 1/(maxS(i)/minS(i));
    end
end
 
%% 図示
if illustration == 1
    fig18=figure(18);
    fig18.Color = 'white';
    plot(time,robot_pe(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_pe(2,:),'LineWidth', 2);
    plot(time,robot_pe(3,:),'LineWidth', 2);
    plot(time,robot_p(1,:),'LineWidth', 2);
    plot(time,robot_p(2,:),'LineWidth', 2);
    plot(time,robot_p(3,:),'LineWidth', 2);
    lgd=legend('\it{x_e}','\it{y_e}','\it{z_e}','\it{x}','\it{y}','\it{z}','FontSize', 16,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('position \it{p} [m]','FontSize', 16);
    grid on;
    fig2=figure(2);
    fig2.Color = 'white';
    plot(time,robot_qe(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_qe(2,:),'LineWidth', 2);
    plot(time,robot_qe(3,:),'LineWidth', 2);
    plot(time,robot_q(1,:),'LineWidth', 2);
    plot(time,robot_q(2,:),'LineWidth', 2);
    plot(time,robot_q(3,:),'LineWidth', 2);
    lgd=legend('\phi_{e}','\theta_{e}','\psi_{e}','\phi','\theta','\psi','FontSize', 16,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('orientation \it{q} [rad]','FontSize', 16);
    grid on;
    fig3=figure(3);
    fig3.Color = 'white';
    plot(time,ref_p(1,:),'LineWidth', 2);
    hold on;
    plot(time,ref_p(2,:),'LineWidth', 2);
    plot(time,ref_p(3,:),'LineWidth', 2);
    legend('x','y','z','Location', 'Best','FontSize', 16);
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('refernce of position [m]','FontSize', 16);
    xlim([0, maxt]);
    grid on;
    fig4=figure(4);
    fig4.Color = 'white';
    plot(time,ref_q(1,:),'LineWidth', 2);
    hold on;
    plot(time,ref_q(2,:),'LineWidth', 2);
    plot(time,ref_q(3,:),'LineWidth', 2);
    legend('\phi','\theta','\psi','Location', 'Best');
    xlabel('time [s]','FontSize', 16)
    ylabel('refernce of orientation [ang]','FontSize', 16);
    xlim([0, maxt]);
    hold off;
    grid on;
    lgd=legend('\phi','\theta','\psi','Location', 'Best','FontSize', 16);
    lgd.NumColumns = 2;
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
    legend('1st','2nd','FontSize', 16,'Location', 'Best');
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
    lgd=legend('\it{x}','\it{y}','\it{z}','\it{x_e}','\it{y_e}','\it{z_e}','FontSize', 16,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlabel('time [s]','FontSize', 16)
    ylabel('position \it{p} [m]','FontSize', 16);
    xlim([0, maxt]);
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
    lgd=legend('\phi','\theta','\psi','\phi_{e}','\theta_{e}','\psi_{e}','FontSize', 16,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('orientation \it{q} [rad]','FontSize', 16);
    xlim([0, maxt]);
    ylim([-1 1]);
    grid on;
    if flag_offset==1
    fig9=figure(9);
    fig9.Color = 'white';
    plot(time,ps(1,:),'LineWidth', 3);
        hold on;
    plot(time,ps(2,:),'LineWidth', 3);
    plot(time,ps(3,:),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    plot(time,0.01*ones(size(time)),'LineWidth', 3);
    lgd=legend('\it{psb_{xe}}','\it{psb_{ye}}','\it{psb_{ze}}','\it{psb_{x}}','\it{psb_{y}}','\it{psb_{z}}','FontSize', 18,'Location', 'Best');
    lgd.NumColumns = 2;
    hold off;
    xlim([0, maxt]);
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{p}_{SB} [m]','FontSize', 16);
%     ylim([-1, 1]);
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    plot(time,qs(1,:),'LineWidth', 3);
    hold on;
    plot(time,qs(2,:),'LineWidth', 3);
    plot(time,qs(3,:),'LineWidth', 3);
     plot(time,0*ones(size(time)),'LineWidth', 3);
    plot(time,0*ones(size(time)),'LineWidth', 3);
    plot(time,(pi/2)*ones(size(time)),'LineWidth', 3);
    xlim([0, maxt]);
%     ylim([-1 2]);
    lgd = legend('qs_{\phi e}','qs_{\theta e}','qs_{\psi e}','qs_{\phi}','qs_{\theta}','qs_{\psi}','FontSize', 18,'Location', 'Best');
    lgd.NumColumns = 2;
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{q}_S [rad]','FontSize', 16);
    hold off;
    end
    fig11=figure(11);
    fig11.Color = 'white';
    plot(time,robot_ve(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_ve(2,:),'LineWidth', 2);
    plot(time,robot_ve(3,:),'LineWidth', 2);
    plot(time,robot_v(1,:),'LineWidth', 2);
    plot(time,robot_v(2,:),'LineWidth', 2);
    plot(time,robot_v(3,:),'LineWidth', 2);
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{v} [m/s]','FontSize', 16);
    lgd=legend('\it{v_{xe}}','\it{v_{ye}}','\it{v_{ze}}','\it{v_x}','\it{v_y}','\it{v_z}','FontSize', 18,'Location', 'Best');
    lgd.NumColumns = 2;
    xlim([0, maxt]);
    hold off;
    fig13=figure(13);
    fig13.Color = 'white';
    plot(time,robot_we(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_we(2,:),'LineWidth', 2);
    plot(time,robot_we(3,:),'LineWidth', 2);
    plot(time,robot_w(1,:),'LineWidth', 2);
    plot(time,robot_w(2,:),'LineWidth', 2);
    plot(time,robot_w(3,:),'LineWidth', 2);
    xlabel('time [s]','FontSize', 16);
    ylabel('\it{w} [rad/s]','FontSize', 16);
    lgd13=legend('\it{w_{\phi e}}','\it{w_{\theta e}}','\it{w_{\psi e}}','\it{w_{\phi}}','\it{w_{\theta}}','\it{w_{\psi}}','FontSize', 18,'Location', 'Best');
    lgd13.NumColumns = 2;
    xlim([0, maxt]);
    hold off;
    fig14=figure(14);
    fig14.Color = 'white';
    plot(time,RankOl,'LineWidth', 2);
    hold on;
    plot(time,Rank,'LineWidth', 2);
    xlabel('time [s]','FontSize', 16)
    ylabel('rank of observability matrix','FontSize', 16);
    legend('Method 1','Method 2','FontSize', 18,'Location', 'Best');
    hold off;
    xlim([0, maxt]);
    fig15=figure(15);
    fig15.Color = 'white';
    plot(time,minS,'LineWidth', 2);
    xlabel('time [s]','FontSize', 16)
    ylabel('Minimum Singular Value','FontSize', 16);
    xlim([0, maxt]);
    hold off;
    fig16=figure(16);
    fig16.Color = 'white';
    plot(S(:,last),'x','LineWidth', 5);
    xlabel('Singular Value','FontSize', 16)
    ylabel(' Value','FontSize', 16);
    hold off;
    fig17=figure(17);
    fig17.Color = 'white';
    plot(time,S(15,:),'LineWidth', 2);
    hold on;
    plot(time,S(16,:),'LineWidth', 2);
    plot(time,S(17,:),'LineWidth', 2);
    plot(time,S(18,:),'LineWidth', 2);
    xlabel('time [s]','FontSize', 16)
    ylabel('Value','FontSize', 16);
    xlim([0, maxt]);
    legend('15','16','17','18','Location', 'Best');
    hold off;
    fig1 = figure(1);
    fig1.Color = 'white';
    hold on;
    log.plot({1, "input", ""});
    if flag_wall == 1
        fig30=figure(30);
        fig30.Color = 'white';
        plot(time,l(1,:),'LineWidth', 3);
        hold on;
        plot(time,l(2,:),'LineWidth', 3);
        plot(time,l(3,:),'LineWidth', 3);
        plot(time,l(4,:),'LineWidth', 3);
        % xlim([0, 30]);
        ylim([0 2]);
        legend('a','b','c','d','FontSize', 18,'Location', 'Best');
        xlabel('time [s]','FontSize', 16)
        ylabel('value','FontSize', 16);
        xlim([0, maxt]);
        hold off;
    end
    fig31 = figure(31);
    fig31.Color = 'white';
    plot(time,D,'LineWidth', 3);
    xlabel('time [s]','FontSize', 16);
    ylabel('Condition number \it{D}','FontSize', 16);
    xlim([0, maxt]);

end
if flag_png==1
%     pass2 = 'C:\Users\yuika\Desktop\修士\中間発表\ppt';
    pass2 = 'C:\Users\student\Desktop\Nozaki'; %P:192.168.100.20 PC
    saveas(fig7, fullfile(pass2, 'EKF_pos.png'));
    saveas(fig8, fullfile(pass2, 'EKF_ang.png'));
    saveas(fig18, fullfile(pass2, 'EKF_posAll.png'));
    saveas(fig2, fullfile(pass2, 'EKF_angAll.png'));
    saveas(fig11, fullfile(pass2, 'EKF_v.png'));
    saveas(fig13, fullfile(pass2, 'EKF_w.png'));
    saveas(fig14, fullfile(pass2, 'rankO.png'));
    saveas(fig15, fullfile(pass2, 'minS.png'));
    saveas(fig16, fullfile(pass2, 'Singular_Value.png'));
    saveas(fig17, fullfile(pass2, 'S_15_18.png'));
    if flag_offset == 1
        saveas(fig9, fullfile(pass2, 'EKF_psb.png'));
        saveas(fig10, fullfile(pass2, 'EKF_qs.png'));
        saveas(fig12, fullfile(pass2, 'EKF_inst.png'));
    end 

%     saveas(fig7, fullfile(pass2, 'EKF_pos_b.png'));
%     saveas(fig8, fullfile(pass2, 'EKF_ang_b.png'));
%     saveas(fig18, fullfile(pass2, 'EKF_posAll_b.png'));
%     saveas(fig2, fullfile(pass2, 'EKF_angAll_b.png'));
%     saveas(fig11, fullfile(pass2, 'EKF_v_b.png'));
%     saveas(fig13, fullfile(pass2, 'EKF_w_b.png'));
%     saveas(fig14, fullfile(pass2, 'rankO_b.png'));
%     saveas(fig15, fullfile(pass2, 'minS_b.png'));
%     saveas(fig16, fullfile(pass2, 'Singular_Value_b.png'));
%     saveas(fig17, fullfile(pass2, 'S_15_18_b.png'));
%     if flag_offset == 1
%         saveas(fig9, fullfile(pass2, 'EKF_psb_b.png'));
%         saveas(fig10, fullfile(pass2, 'EKF_qs_b.png'));
%         saveas(fig12, fullfile(pass2, 'EKF_inst_b.png'));
%     end   
end
if flag_eps==1
    pass2 = 'C:\Users\student\Desktop\Nozaki'; %P:192.168.100.20 PC
    saveas(fig7, fullfile(pass2, 'EKF_pos.eps'), 'epsc');
    saveas(fig8, fullfile(pass2, 'EKF_ang.eps'), 'epsc');
    saveas(fig18, fullfile(pass2, 'EKF_posAll.eps'), 'epsc');
    saveas(fig2, fullfile(pass2, 'EKF_angAll.eps'), 'epsc');
    saveas(fig11, fullfile(pass2, 'EKF_v.eps'), 'epsc');
    saveas(fig13, fullfile(pass2, 'EKF_w.eps'), 'epsc');
    saveas(fig14, fullfile(pass2, 'rankO.eps'), 'epsc');
    saveas(fig15, fullfile(pass2, 'minS.eps'), 'epsc');
    saveas(fig16, fullfile(pass2, 'Singular_Value.eps'), 'epsc');
    saveas(fig17, fullfile(pass2, 'S_15_18.eps'), 'epsc');
    saveas(fig31, fullfile(pass2, 'condN.eps'), 'epsc');
    if flag_offset == 1
        saveas(fig9, fullfile(pass2, 'EKF_psb.eps'), 'epsc');
        saveas(fig10, fullfile(pass2, 'EKF_qs.eps'), 'epsc');
        saveas(fig12, fullfile(pass2, 'EKF_inst.eps'), 'epsc');
    end   
    
%     saveas(fig7, fullfile(pass2, 'EKF_pos_b.eps'), 'epsc');
%     saveas(fig8, fullfile(pass2, 'EKF_ang_b.eps'), 'epsc');
%     saveas(fig18, fullfile(pass2, 'EKF_posAll_b.eps'), 'epsc');
%     saveas(fig2, fullfile(pass2, 'EKF_angAll_b.eps'), 'epsc');
%     saveas(fig11, fullfile(pass2, 'EKF_v_b.eps'), 'epsc');
%     saveas(fig13, fullfile(pass2, 'EKF_w_b.eps'), 'epsc');
%     saveas(fig14, fullfile(pass2, 'rankO_b.eps'), 'epsc');
%     saveas(fig15, fullfile(pass2, 'minS_b.eps'), 'epsc');
%     saveas(fig16, fullfile(pass2, 'Singular_Value_b.eps'), 'epsc');
%     saveas(fig17, fullfile(pass2, 'S_15_18_b.eps'), 'epsc');
%     saveas(fig31, fullfile(pass2, 'condN_b.eps'), 'epsc');
%     if flag_offset == 1
%         saveas(fig9, fullfile(pass2, 'EKF_psb_b.eps'), 'epsc');
%         saveas(fig10, fullfile(pass2, 'EKF_qs_b.eps'), 'epsc');
%         saveas(fig12, fullfile(pass2, 'EKF_inst_b.eps'), 'epsc');
%     end   
end

function rounded_radians = roundpi(radians)
    % ラジアンを-piからpiの範囲に丸める関数
    while radians < -pi
        radians = radians + 2*pi;
    end
    while radians >= pi
        radians = radians - 2*pi;
    end
    rounded_radians = radians;
end