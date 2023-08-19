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
noiseflag = 1;
% Log Dataの読み取りと格納
% log2 = LOGGER('./Data/data030402503.mat');
% log2 = LOGGER('./Data/miidmove_Log(24-Jul-2023_13_38_35).mat');
log = LOGGER('./Data/lidar1deg.mat');
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

%% ノイズ付加
if noiseflag==1
    robot_pe = robot_pe + (0.001*randn(size(robot_pe)));
    robot_qe = robot_qe + (0.0001*randn(size(robot_qe)));
    sensor_data = sensor_data+ (0.002*randn(size(sensor_data)));
end
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
offset_true = [0.1;0.05;0.0];
Rs_true = Rodrigues([0,0,1],pi/12);
w=[1,0,0,9];
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
P_stack = zeros(size(A,2),size(A,2),last-1);%%Pnスタックする変数
JP = zeros(1,last-1); %J=Σ||p^-p||
JX = zeros(1,last-1); %J=Σ||X^-X||
JY = zeros(1,last-1); %J=Σ||Y^-Y||
alpha = 100000;
for j=2:last
    if j == 2
        qt = Eul2Quat(robot_qe(:,j-1));
        qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_pe(:,j-1),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        % qt = Eul2Quat(robot_qe(:,j));
        % qt = qt./vecnorm(qt,2);
        % A = Cf2_sens(robot_pe(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        A(:,ds)=[];
        [Xn,Pn] = param_analysis_eq(A',zeros(size(A,2),1),-1*ones(size(A,1),1),alpha*eye(size(A,2)),0.9999);
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
        JP(1,j-1) = norm(offsetn-offset_true) + norm(Rsn-Rs_true);
        JX(:,j-1) = norm(Xn-X_true);
        Yn = [offsetn;reshape(Rsn,[9,1])];
        JY(:,j-1) = norm(Yn-Y_true);
    else
        qt = Eul2Quat(robot_qe(:,j-1));
        qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_pe(:,j-1),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        % qt = Eul2Quat(robot_qe(:,j));
        % qt = qt./vecnorm(qt,2);
        % A = Cf2_sens(robot_pe(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],(num-1)*pi/ang));
        ds = find(A(2,:)==0);
        A(:,ds)=[];
        [Xn,Pn] = param_analysis_eq(A',Xn,-1*ones(size(A,1),1),Pn,0.9999);
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
    end
end

%% 逐次計算時の共分散行列Pnの対角成分(分散)保存
variance = zeros(size(P_stack,2),size(P_stack,3));
for j=1:size(P_stack,3)
    variance(:,j) = diag(P_stack(:,:,j));
end
%% 交点比較
for i=1:length(robot_pe)
    sp(:,i) = robot_pe(:,i) + eul2rotm(robot_qe(:,i)','XYZ')*offsetn + sensor_data(1,i)*eul2rotm(robot_qe(:,i)','XYZ')*Rsn*[1;0;0];
end
figure(12);
plot(sp(1,:));
hold on;
plot(sp(2,:));
plot(sp(3,:));
legend('x','y','z');
% ss=log.data(1,"sensor.result.sensor_points","s");
% ss = reshape(ss,3,[]);
% plot(ss);
% legend('x','y','z','xt','yt','zt');
hold off ;
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
    fig4=figure(4);
    fig4.Color = 'white';
    plot(sensor_data(1,:));
    hold on;
    plot(sensor_data(num,:));
    % plot(sensor_data(8,:));
    % plot(sensor_data(9,:));
    xlabel('step','FontSize', 14);
    ylabel('Distance of the lidar [m]','FontSize', 14);
    legend('1st','2nd');
    grid on;
    fig5=figure(5);
    fig5.Color = 'white';
    plot(ref_p(1,:),'LineWidth', 2);
    hold on;
    plot(ref_p(2,:),'LineWidth', 2);
    plot(ref_p(3,:),'LineWidth', 2);
    legend('x,y,z');
    hold off;
    xlabel('step');
    ylabel('ref p[m]');
    grid on;
    fig6=figure(6);
    fig6.Color = 'white';
    plot(ref_q(1,:),'LineWidth', 2);
    hold on;
    plot(ref_q(2,:),'LineWidth', 2);
    plot(ref_q(3,:),'LineWidth', 2);
    legend('x','y','z');
    hold off;
    xlabel('step');
    ylabel('ref q');
    grid on;
    fig7=figure(7);
    fig7.Color = 'white';
    for i=1:3
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 alpha]);
    hold off;
    xlabel('step');
    ylabel('variance of wall param');
    legend('a/d','b/d','c/d');
    grid on;
    fig8=figure(8);
    fig8.Color = 'white';
    for i=4:12
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 alpha]);
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('P1*a/d','P2*a/d','P3*a/d','P1*b/d','P2*b/d','P3*b/d','P1*c/d','P2*c/d','P3*c/d');
    grid on;
    fig9=figure(9);
    fig9.Color = 'white';
    for i=13:15
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=19:21
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=25:27
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 alpha]);
    hold off;
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R11*a/d','R21*a/d','R31*a/d','R11*b/d','R21*b/d','R31*b/d','R11*c/d','R21*c/d','R31*c/d');
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    for i=16:18
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=22:24
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    for i=28:30
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 alpha]);
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R12*a/d','R22*a/d','R32*a/d','R12*b/d','R22*b/d','R32*b/d','R12*c/d','R22*c/d','R32*c/d');
    grid on;
    fig11=figure(11);
    fig11.Color = 'white';
    plot(JP,'LineWidth', 2);
    hold on;
    plot(JX,'LineWidth', 2);
    plot(JY,'LineWidth', 2);
    hold off;
    xlabel('step');
    ylabel('evaluation value');
    legend('JP','JX','JY');
    grid on;
end
% %%
% figure(20);
% trisurf(env);
% xlabel('x');
% ylabel('y');
% zlabel('z');

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
