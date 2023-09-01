%% GUI projectの情報を用いたパラメータ解析
% 2つの交点式から一括でパラメータ推定するやつ
%% Initialize settings
% set path
clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
% cd(cf); close all hidden; clear all; userpath('clear');

%% フラグ設定
illustration= 1; %1で図示，0で非表示
flag_eps=0;
flag_png=0;
% Log Dataの読み取りと格納
% log2 = LOGGER('./Data/data030402503.mat');
% log2 = LOGGER('./Data/miidmove_Log(24-Jul-2023_13_38_35).mat');
log = LOGGER('./Data/RLS_result_0904.mat');
% log = LOGGER('./Data/nomove_little_Log(14-Jul-2023_00_53_31).mat');

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


% 
% %
% robot_p2  = log2.data(1,"p","p")';
% robot_pe2  = log2.data(1,"p","e")';
% robot_q2  = log2.data(1,"q","p")';
% robot_qe2  = log2.data(1,"q","e")';
% sensor_data2 = (log2.data(1,"length","s"))';
% ref_p2 = log2.data(1,"p","r")';
% ref_q2 = log2.data(1,"q","r")';
% % 
% robot_p  = [robot_p,robot_p2(:,5:end)];
% robot_pe  = [robot_pe,robot_pe2(:,5:end)];
% robot_q  = [robot_q,robot_q2(:,5:end)];
% robot_qe  = [robot_qe,robot_qe2(:,5:end)];
% sensor_data = [sensor_data,sensor_data2(:,5:end)]; 
% ref_p = [ref_p,ref_p2(:,5:end)];
% ref_q = [ref_q,ref_q2(:,5:end)];

%% 不要データの除去
nanIndices = isnan(sensor_data(1,:));
ds = find(nanIndices==1);
sensor_data(:,ds) = [];
robot_p(:,ds) = [];
robot_pe(:,ds) = [];
robot_q (:,ds) = [];
robot_qe(:,ds) = [];
ds0= find(robot_pe(1,:)==0);
sensor_data(:,ds) = [];
robot_p(:,ds0) = [];
robot_pe(:,ds0) = [];
robot_q (:,ds0) = [];
robot_qe(:,ds0) = [];
%% パラメータ真値
% offset_true = [0.1;0.05;0.0];
offset_true = [0.1;0.1;0.1];
% Rs_true = Rodrigues([0,0,1],pi/12);
% Rs_true = Rodrigues([1,1,1],pi/20);
Rs_true = Rodrigues([0,0,1],pi/2);
qst = [0;0;pi/2];
% w=[1,0,0,9];
w=[0,1,0,-9];
X_true  = -1*[w(1)/w(4);w(2)/w(4);w(3)/w(4);
           offset_true(1)*w(1)/w(4);offset_true(2)*w(1)/w(4);offset_true(3)*w(1)/w(4);offset_true(1)*w(2)/w(4);offset_true(2)*w(2)/w(4);offset_true(3)*w(2)/w(4);offset_true(1)*w(3)/w(4);offset_true(2)*w(3)/w(4);offset_true(3)*w(3)/w(4);
           Rs_true(1,1)*w(1)/w(4);Rs_true(2,1)*w(1)/w(4);Rs_true(3,1)*w(1)/w(4);Rs_true(1,2)*w(1)/w(4);Rs_true(2,2)*w(1)/w(4);Rs_true(3,2)*w(1)/w(4);
           Rs_true(1,1)*w(2)/w(4);Rs_true(2,1)*w(2)/w(4);Rs_true(3,1)*w(2)/w(4);Rs_true(1,2)*w(2)/w(4);Rs_true(2,2)*w(2)/w(4);Rs_true(3,2)*w(2)/w(4);
           Rs_true(1,1)*w(3)/w(4);Rs_true(2,1)*w(3)/w(4);Rs_true(3,1)*w(3)/w(4);Rs_true(1,2)*w(3)/w(4);Rs_true(2,2)*w(3)/w(4);Rs_true(3,2)*w(3)/w(4);];
Y_true = [offset_true;reshape(Rs_true,[9,1])];
%% 解析(回帰分析)
last=length(robot_pe);
num = 3;%2本目センサのいっぽん目からの本数
ang = 180;
%% 一括でパラ推定
[~,~,At,Xt] = param_analysis2(robot_pe(:,2),robot_qe(:,2),sensor_data(1,3),sensor_data(num,3),Rodrigues([0,0,1],(num-1)*pi/ang));
A_stack=[];
for i=2:1:last
    qt = Eul2Quat(robot_qe(:,i-1));%正規
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_pe(:,i-1),qt,sensor_data(1,i),sensor_data(num,i),Rodrigues([0,0,1],(num-1)*pi/ang));
    % qt = Eul2Quat(robot_qe(:,i));
    % qt = qt./vecnorm(qt,2);
    % A = Cf2_sens(robot_pe(:,i),qt,sensor_data(1,i),sensor_data(num,i),Rodrigues([0,0,1],(num-1)*pi/ang));
    ds = find(A(2,:)==0);
    A(:,ds)=[];
    A_stack=[A_stack;A];
end

%% 疑似逆
X = pinv(A_stack)*(-1*ones(size(A_stack,1),1));
offset = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:12)];
Rsx = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(13:15);X(19:21);X(25:27)];
Rsx = Rsx/vecnorm(Rsx);
Rsy = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(16:18);X(22:24);X(28:30)];
Rsy = Rsy/vecnorm(Rsy);
Rsz = cross(Rsx,Rsy);
Rs = [Rsx,Rsy,Rsz];
%% 一括でパラ推定逐次
alpha = 100000;
P_stack = alpha*ones(size(A,2),size(A,2),last);%%Pnスタックする変数
JP = ones(1,last); %J=Σ||p^-p||
JX = ones(1,last); %J=Σ||X^-X||
JY = ones(1,last); %J=Σ||Y^-Y||
JY = ones(1,last); %J=Σ||Y^-Y||
psb = zeros(3,last-1); %J=Σ||Y^-Y||
qs = zeros(3,last-1);
for j=2:last
    if j == 2
        qt = Eul2Quat(robot_qe(:,j-1));
        qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_pe(:,j-1),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        % qt = Eul2Quat(robot_qe(:,j));
        % qt = qt./vecnorm(qt,2);
        % A = Cf2_sens(robot_pe(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        A(:,ds)=[];
        [Xn,Pn] = RLS(A,zeros(size(A,2),1),-1*ones(size(A,1),1),alpha*eye(size(A,2)),1);
        P_stack(:,:,j-1) = Pn;
        offsetn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsxn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(13:15);Xn(19:21);Xn(25:27)];
        Rsxn = Rsxn/vecnorm(Rsxn);
        Rsyn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(16:18);Xn(22:24);Xn(28:30)];
        Rsyn = Rsyn/vecnorm(Rsyn);
        % Rszn = cross(Rsxn/vecnorm(Rsxn),Rsyn/vecnorm(Rsyn));
        Rszn = cross(Rsxn,Rsyn);
        Rsn = [Rsxn,Rsyn,Rszn];
        % 評価
        JP(1,j) = norm(offsetn-offset_true) + norm(Rsn-Rs_true);
        JX(:,j) = norm(Xn-X_true);
        Yn = [offsetn;reshape(Rsn,[9,1])];
        JY(:,j) = norm(Yn-Y_true);
        psb(:,j)=offsetn;
        qs(:,j)=rotm2eul(Rsn,'XYZ')';
    else
        qt = Eul2Quat(robot_qe(:,j-1));
        qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_pe(:,j-1),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        % qt = Eul2Quat(robot_qe(:,j));
        % qt = qt./vecnorm(qt,2);
        % A = Cf2_sens(robot_pe(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        ds = find(A(2,:)==0);
        A(:,ds)=[];
        [Xn,Pn] = RLS(A,Xn,-1*ones(size(A,1),1),Pn,1);
        P_stack(:,:,j-1) = Pn;
        offsetn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsxn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(13:15);Xn(19:21);Xn(25:27)];
        Rsxn = Rsxn/vecnorm(Rsxn);
        Rsyn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(16:18);Xn(22:24);Xn(28:30)];
        Rsyn = Rsyn/vecnorm(Rsyn);
        Rszn = cross(Rsxn,Rsyn);
        % Rszn = cross(Rsxn/vecnorm(Rsxn),Rsyn/vecnorm(Rsyn));
        Rsn = [Rsxn,Rsyn,Rszn];
        % 評価
        JP(:,j-1) = norm(offsetn-offset_true) + norm(Rsn-Rs_true);
        JX(:,j-1) = norm(Xn-X_true);
        Yn = [offsetn;reshape(Rsn,[9,1])];
        JY(:,j-1) = norm(Yn-Y_true);
        psb(:,j)=offsetn;
        qs(:,j)=rotm2eul(Rsn,'XYZ')';
    end
end
P_stack(:,:,last) =Pn;%%Pnスタックする変数
JP(:,last) =norm(offsetn-offset_true) + norm(Rsn-Rs_true); %J=Σ||p^-p||
JX(:,last) = norm(Xn-X_true); %J=Σ||X^-X||
JY(:,last) = norm(Yn-Y_true);
%% 逐次計算時の共分散行列Pnの対角成分(分散)保存
variance = zeros(size(P_stack,2),size(P_stack,3));
for j=1:size(P_stack,3)
    variance(:,j) = diag(P_stack(:,:,j));
end
%%
steps=1:length(robot_pe);
time = 0.01*steps;
%% 交点比較
for i=1:length(robot_pe)
    sp(:,i) = robot_pe(:,i) + eul2rotm(robot_qe(:,i)','XYZ')*offsetn + sensor_data(1,i)*eul2rotm(robot_qe(:,i)','XYZ')*Rsn*[1;0;0];
end
fig12=figure(12);
fig12.Color = 'white';
plot(time,sp(1,:),'LineWidth', 2);
hold on;
plot(time,sp(2,:),'LineWidth', 2);
plot(time,sp(3,:),'LineWidth', 2);
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
    legend('\it{px}','\it{py}','\it{pz}','\it{pxe}','\it{pye}','\it{pze}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
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
    fig4=figure(4);
    fig4.Color = 'white';
    plot(time,sensor_data(1,1:9999));
    hold on;
    plot(time,sensor_data(num,1:9999));
    % plot(sensor_data(8,:));
    % plot(sensor_data(9,:));
    xlabel('step','FontSize', 16);
    ylabel('Distance of the lidar [m]','FontSize', 16);
    legend('1st','2nd','FontSize', 18);
    xlim([0, 20]);
    grid on;
    fig5=figure(5);
    fig5.Color = 'white';
    plot(time,ref_p(1,1:9999),'LineWidth', 2);
    hold on;
    plot(time,ref_p(2,1:9999),'LineWidth', 2);
    plot(time,ref_p(3,1:9999),'LineWidth', 2);
    legend('x','y','z','FontSize', 16);
    hold off;
    xlim([0, 20]);
    xlabel('time [s]','FontSize', 16);
    ylabel('reference position [m]','FontSize', 16);
    grid on;
    fig6=figure(6);
    fig6.Color = 'white';
    plot(time,ref_q(1,1:9999),'LineWidth', 2);
    hold on;
    plot(time,ref_q(2,1:9999),'LineWidth', 2);
    plot(time,ref_q(3,1:9999),'LineWidth', 2);
    xlim([0, 20]);
    legend('\phi','\theta','\psi','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('reference angle [rad]','FontSize', 16);
    grid on;
    fig7=figure(7);
    fig7.Color = 'white';
    for i=1:3
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 alpha]);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('variance of wall param','FontSize', 16);
    legend('a/d','b/d','c/d','FontSize', 18);
    grid on;
    fig8=figure(8);
    fig8.Color = 'white';
    for i=4:12
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 alpha]);
    xlabel('time [s]','FontSize', 16);
    ylabel('variance of offset*wallparam','FontSize', 16);
    legend('PSB1*a/d', 'PSB2*a/d', 'PSB3*a/d', ...
       'PSB1*b/d', 'PSB2*b/d', 'PSB3*b/d', ...
       'PSB1*c/d', 'PSB2*c/d', 'PSB3*c/d', ...
       'FontSize', 18);
    grid on;
    fig9=figure(9);
    fig9.Color = 'white';
    for i=13:15
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=19:21
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=25:27
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 alpha]);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('variance of offset*wallparam','FontSize', 16);
    % legend('R11*a/d','R21*a/d','R31*a/d','R11*b/d','R21*b/d','R31*b/d','R11*c/d','R21*c/d','R31*c/d','FontSize', 18);
    legend('RS1,1*a/d', 'RS2,1*a/d', 'RS3,1*a/d', ...
       'RS1,1*b/d', 'RS2,1*b/d', 'RS3,1*b/d', ...
       'RS1,1*c/d', 'RS2,1*c/d', 'RS3,1*c/d', ...
       'FontSize', 18);
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    for i=16:18
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=22:24
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=28:30
        plot(time,variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 alpha]);
    xlabel('time [s]','FontSize', 16);
    ylabel('variance of offset*wallparam','FontSize', 16);
    legend('RS1,2*a/d', 'RS2,2*a/d', 'RS3,2*a/d', ...
       'RS1,2*b/d', 'RS2,2*b/d', 'RS3,2*b/d', ...
       'RS1,2*c/d', 'RS2,2*c/d', 'RS3,2*c/d', ...
       'FontSize', 18);
    grid on;
    fig11=figure(11);
    fig11.Color = 'white';
    plot(JP,'LineWidth', 2);
    hold on;
    plot(time,JX,'LineWidth', 2);
    plot(time,JY,'LineWidth', 2);
    hold off;
    xlabel('time [s]');
    ylabel('evaluation value');
    legend('JP','JX','JY','FontSize', 18);
    grid on;
   fig13=figure(13);
    fig13.Color = 'white';
    plot(time,robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(time,robot_p(2,:),'LineWidth', 2);
    plot(time,robot_p(3,:),'LineWidth', 2);
    plot(time,robot_pe(1,:),'LineWidth', 2);
    plot(time,robot_pe(2,:),'LineWidth', 2);
    plot(time,robot_pe(3,:),'LineWidth', 2);
    legend('\it{px}','\it{py}','\it{pz}','\it{pxe}','\it{pye}','\it{pze}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('position \it{p}[m]','FontSize', 16);
    xlim([0, 20]);
    grid on;
    fig14=figure(14);
    fig14.Color = 'white';
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
    fig20=figure(20);
    fig20.Color = 'white';
    plot(time,psb(1,:),'LineWidth', 2);
    hold on;
    plot(time,psb(2,:),'LineWidth', 2);
    plot(time,psb(3,:),'LineWidth', 2);
    plot(time,offset_true(1,:),'LineWidth', 2);
    plot(time,offset_true(2,:),'LineWidth', 2);
    plot(time,offset_true(3,:),'LineWidth', 2);
    legend('{p^}_{SB1}','{p^}_{SB2}','{p^}_{SB3}','{p}_{SB1}','{p}_{SB2}','{p}_{SB3}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('angle \it{q} [rad]','FontSize', 16);
    xlim([0, 20]);
    grid on;
    fig21=figure(21);
    fig21.Color = 'white';
    plot(time,qs(1,:),'LineWidth', 2);
    hold on;
    plot(time,qs(2,:),'LineWidth', 2);
    plot(time,qs(3,:),'LineWidth', 2);
    plot(time,qst(1,:),'LineWidth', 2);
    plot(time,qst(2,:),'LineWidth', 2);
    plot(time,qst(3,:),'LineWidth', 2);
    legend('{q^}_{S1}','{q^}_{S2}','{q^}_{S3}','{q}_{S1}','{q}_{S2}','{q}_{S3}','FontSize', 18);
    hold off;
    xlabel('time [s]','FontSize', 16);
    ylabel('angle \it{q} [rad]','FontSize', 16);
    xlim([0, 20]);
    grid on;

end
% %%
% figure(20);
% trisurf(env);
% xlabel('x');
% ylabel('y');
% zlabel('z');
%%
if flag_eps==1
    pass = 'C:\Users\yuika\Desktop\修士\中間発表\latex2e\latex2e\output\fig';
    saveas(fig13, fullfile(pass, 'RLS_pos.eps'), 'epsc');
    saveas(fig14, fullfile(pass, 'RLS_ang.eps'), 'epsc');
    saveas(fig4, fullfile(pass, 'RLS_sens.eps'), 'epsc');
    saveas(fig5, fullfile(pass, 'RLS_refp.eps'), 'epsc');
    saveas(fig6, fullfile(pass, 'RLS_refq.eps'), 'epsc');
    saveas(fig7, fullfile(pass, 'RLS_var1.eps'), 'epsc');
    saveas(fig8, fullfile(pass, 'RLS_var2.eps'), 'epsc');
    saveas(fig9, fullfile(pass, 'RLS_var3.eps'), 'epsc');
    saveas(fig10, fullfile(pass, 'RLS_var4.eps'), 'epsc');
    saveas(fig12, fullfile(pass, 'RLS_inst.eps'), 'epsc');
end
if flag_png==1
    pass2 = 'C:\Users\yuika\Desktop\修士\中間発表\ppt';
    saveas(fig13, fullfile(pass2, 'RLS_pos.png'));
    saveas(fig14, fullfile(pass2, 'RLS_ang.png'));
    saveas(fig4, fullfile(pass2, 'RLS_sens.png'));
    saveas(fig5, fullfile(pass2, 'RLS_refp.png'));
    saveas(fig6, fullfile(pass2, 'RLS_refq.png'));
    saveas(fig7, fullfile(pass2, 'RLS_var1.png'));
    saveas(fig8, fullfile(pass2, 'RLS_var2.png'));
    saveas(fig9, fullfile(pass2, 'RLS_var3.png'));
    saveas(fig10, fullfile(pass2, 'RLS_var4.png'));
    saveas(fig12, fullfile(pass2, 'RLS_inst.png'));
    saveas(fig20, fullfile(pass2, 'RLS_psb.png'));
    saveas(fig21, fullfile(pass2, 'RLS_qs.png'));
end
% %% Cross
% log = LOGGER('./Data/RLC_badbig.mat');
% robot_pe2  = log.data(1,"p","e")';
% robot_qe2  = log.data(1,"q","e")';
% sensor_data2 = (log.data(1,"length","s"))';
% %% 交点比較
% for i=1:length(robot_pe)
%     sp2(:,i) = robot_pe2(:,i) + eul2rotm(robot_qe2(:,i)','XYZ')*offsetn + sensor_data2(1,i)*eul2rotm(robot_qe2(:,i)','XYZ')*Rsn*[1;0;0];
% end
% fig20=figure(20);
% fig20.Color = 'white';
% plot(time,sp2(1,:),'LineWidth', 2);
% hold on;
% plot(time,sp2(2,:),'LineWidth', 2);
% plot(time,sp2(3,:),'LineWidth', 2);
% % legend('x','y','z');
% ss2=log.data(1,"sensor.result.sensor_points","s");
% ss2=zeros(3,last);
% for i3=1:last
%     ss2(:,i3)=log.Data.agent.sensor.result{1,i3}.sensor_points(:,1);
% end
% plot(time,ss2(1,:),'LineWidth', 2);
% plot(time,ss2(2,:),'LineWidth', 2);
% plot(time,ss2(3,:),'LineWidth', 2);
% legend('x','y','z','x_t','y_t','z_t','FontSize', 18);
% xlabel('time [s]','FontSize', 16);
% ylabel('Coordinates of intersection [m]','FontSize', 16);
% hold off ;
%%
function [A,X,Cf,var] = param_analysis2(robot_p, robot_q, sensor_data,sensor_data2,R_num)
    syms p [3 1] real
    syms Rb [3 3] real
    syms y y2 real 
    syms Rs [3 3] real
    syms Rn [3 3] real
    syms psb [3 1] real
    syms a b c d real
    
    A = [a b c];
    X = p +Rb*psb + y*Rb*Rs*[1;0;0];
    X2 = p +Rb*psb + y2*Rb*Rs*Rn*[1;0;0];
    %%
    eq =[A d]*[X;1];
    eq2 =[A d]*[X2;1];
    var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    for i = 1:length(var)
    Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
    end
    for i = 1:length(var)
    Cf2(i) = subs(simplify(eq2-subs(expand(eq2),var(i),0)),var(i),1);
    end
    Cf = [p1,p2,p3,Cf];
    Cf2 = [p1,p2,p3,Cf2];
    Cf12 =[Cf;Cf2];
    var = [a,b,c,var]/d;
    simplify([eq/d;eq2/d] - Cf12*var' ) 
    qt = Eul2Quat(robot_q);
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_p,qt,sensor_data,sensor_data2,R_num);
    ds = find(A(2,:)==0);
    Cf(ds)=[];
    var(ds)=[];
    A(:,ds)=[];
    X = pinv(A)*(-1*ones(size(A,1),1));
end
