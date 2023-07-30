%% 実データを用いたパラメータ解析
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

%% Log Dataの読み取りと格納
num_logs = 1; % ログの数
log_data = cell(1, num_logs); % ログデータを格納するセル配列

% 2回目
% log_data{1} = readtable('2023-07-24-15-02-31_est.csv'); % ログファイルを読み込んでセル配列に格納
% log_data{2} = readtable('2023-07-24-15-05-06_est.csv');
% log_data{3} = readtable('2023-07-24-15-06-39_est.csv');
% log_data{4} = readtable('2023-07-24-15-07-59_est.csv');

%1回目
log_data{1} = readtable('20230719_2.csv');

% ログを横に連結
robot_p = [];
robot_v = [];
robot_q = [];
sensor_data = [];

for i = 1:num_logs
    % ログから各データを抽出
    robot_p_i = [log_data{i}.Xhat0, log_data{i}.Xhat1, log_data{i}.Xhat2]';
    robot_v_i = [log_data{i}.Xhat6, log_data{i}.Xhat7, log_data{i}.Xhat8]';
    robot_q_i = [log_data{i}.Xhat3, log_data{i}.Xhat4, log_data{i}.Xhat5]';
    sensor_data_i = [log_data{i}.scan1Y0, log_data{i}.scan2Y0, log_data{i}.scan3Y0, log_data{i}.scan4Y0]';
    
    % ログを横に連結
    robot_p = horzcat(robot_p, robot_p_i);
    robot_v = horzcat(robot_v, robot_v_i);
    robot_q = horzcat(robot_q, robot_q_i);
    sensor_data = horzcat(sensor_data, sensor_data_i);
end

% robot_q = robot_q-[0;0;pi/2];
%% 不要データの除去
% nanIndices = isnan(sensor_data(1,:));
% ds = find(nanIndices==1);
ds=find(sensor_data(1,:)==0);
sensor_data(:,ds) = [];
robot_p(:,ds) = [];
robot_q(:,ds) = [];
robot_v(:,ds) = [];

%% パラメータ真値
offset_true = [0;0;0];
Rs_true = Rodrigues([0,0,1],0);
w=[0,1,0,2.645];
X_true  = -1*[w(1)/w(4);w(2)/w(4);w(3)/w(4);
           offset_true(1)*w(1)/w(4);offset_true(2)*w(1)/w(4);offset_true(3)*w(1)/w(4);offset_true(1)*w(2)/w(4);offset_true(2)*w(2)/w(4);offset_true(3)*w(2)/w(4);offset_true(1)*w(3)/w(4);offset_true(2)*w(3)/w(4);offset_true(3)*w(3)/w(4);
           Rs_true(1,1)*w(1)/w(4);Rs_true(2,1)*w(1)/w(4);Rs_true(3,1)*w(1)/w(4);Rs_true(1,2)*w(1)/w(4);Rs_true(2,2)*w(1)/w(4);Rs_true(3,2)*w(1)/w(4);
           Rs_true(1,1)*w(2)/w(4);Rs_true(2,1)*w(2)/w(4);Rs_true(3,1)*w(2)/w(4);Rs_true(1,2)*w(2)/w(4);Rs_true(2,2)*w(2)/w(4);Rs_true(3,2)*w(2)/w(4);
           Rs_true(1,1)*w(3)/w(4);Rs_true(2,1)*w(3)/w(4);Rs_true(3,1)*w(3)/w(4);Rs_true(1,2)*w(3)/w(4);Rs_true(2,2)*w(3)/w(4);Rs_true(3,2)*w(3)/w(4);];
Y_true = [offset_true;reshape(Rs_true,[9,1])];

%% 解析(回帰分析)
last=length(robot_p);
num = 2;%2本目センサのいっぽん目からの本数
ang = 720;
snum = [0,10,20,30];
Reb = Rodrigues([0,0,1],pi/2);%esimatorからrobotへの回転
qeb = [0;0;pi/2];%esimatorからrobotへの姿勢オフセット
%% 一括でパラ推定
[~,~,At,Xt] = param_analysis2(robot_p(:,1),(robot_q(:,1)),sensor_data(1,1),sensor_data(num,1),Rodrigues([0,0,1],snum(num)*pi/360));
A_stack=[];
for i=1:last
    qt = Eul2Quat((robot_q(:,i)));
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_p(:,i),qt,sensor_data(1,i),sensor_data(num,i),Rodrigues([0,0,1],snum(num)*pi/360));
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
% Rsz = cross(Rsx/vecnorm(Rsx),Rsy/vecnorm(Rsy));
Rs = [Rsx,Rsy,Rsz];
%% 一括でパラ推定逐次
P_stack = zeros(size(A,2),size(A,2),last);%%Pnスタックする変数
JP = zeros(1,last); %J=Σ||p^-p||
JX = zeros(1,last); %J=Σ||X^-X||
JY = zeros(1,last); %J=Σ||Y^-Y||
alpha=100000;
for j=1:last
    if j == 1
        qt = Eul2Quat((robot_q(:,j)));
        qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_p(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],snum(num)*pi/360));
        A(:,ds)=[];
        [Xn,Pn] = param_analysis_eq(A',zeros(size(A,2),1),-1*ones(size(A,1),1),alpha*eye(size(A,2)),0.9999);
        P_stack(:,:,j) = Pn;
        offsetn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsxn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(13:15);Xn(19:21);Xn(25:27)];
        Rsxn = Rsxn/vecnorm(Rsxn);
        Rsyn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(16:18);Xn(22:24);Xn(28:30)];
        Rsyn = Rsyn/vecnorm(Rsyn);
        Rszn = cross(Rsxn,Rsyn);
        % Rszn = cross(Rsxn/vecnorm(Rsxn),Rsyn/vecnorm(Rsyn));
        Rsn = [Rsxn,Rsyn,Rszn];
        % 評価
        JP(1,j) = norm(offsetn-offset_true) + norm(Rsn-Rs_true);
        JX(:,j) = norm(Xn-X_true);
        Yn = [offsetn;reshape(Rsn,[9,1])];
        JY(:,j) = norm(Yn-Y_true);
    else
        qt = Eul2Quat((robot_q(:,j)));
        % qt = qt./vecnorm(qt,2);
        A = Cf2_sens(robot_p(:,j),qt,sensor_data(1,j),sensor_data(num,j),Rodrigues([0,0,1],snum(num)*pi/360));
        ds = find(A(2,:)==0);
        A(:,ds)=[];
        [Xn,Pn] = param_analysis_eq(A',Xn,-1*ones(size(A,1),1),Pn,0.9999);
        P_stack(:,:,j) = Pn;
        offsetn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsxn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(13:15);Xn(19:21);Xn(25:27)];
        Rsxn = Rsxn/vecnorm(Rsxn);
        Rsyn = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(16:18);Xn(22:24);Xn(28:30)];
        Rsyn = Rsyn/vecnorm(Rsyn);
        Rszn = cross(Rsxn,Rsyn);
        % Rsz = cross(Rsxn/vecnorm(Rsxn),Rsyn/vecnorm(Rsyn));
        Rsn = [Rsxn,Rsyn,Rszn];
        % 評価
        JP(:,j) = norm(offsetn-offset_true) + norm(Rsn-Rs_true);
        JX(:,j) = norm(Xn-X_true);
        Yn = [offsetn;reshape(Rsn,[9,1])];
        JY(:,j) = norm(Yn-Y_true);
    end
end

%% 逐次計算時の共分散行列Pnの対角成分(分散)保存
variance = zeros(size(P_stack,2),size(P_stack,3));
for j=1:size(P_stack,3)
    variance(:,j) = diag(P_stack(:,:,j));
end

%% 交点比較
for i=1:length(robot_p)
    sp(:,i) = robot_p(:,i) + eul2rotm(((robot_q(:,i)))','XYZ')*offset + sensor_data(1,i)*eul2rotm(((robot_q(:,i)))','XYZ')*Rsn*[1;0;0];
    spt(:,i) = robot_p(:,i) + eul2rotm(((robot_q(:,i)))','XYZ')*offset_true + sensor_data(1,i)*eul2rotm(((robot_q(:,i)))','XYZ')*Rs_true*[1;0;0];
end
figure(12);
plot(sp(1,:));
hold on;
plot(sp(2,:));
plot(sp(3,:));
legend('x','y','z');
hold off;
figure(13);
plot(spt(1,:));
hold on;
plot(spt(2,:));
plot(spt(3,:));
hold off ;
legend('x','y','z');
% hold on
% ss=log.data(1,"sensor.result.sensor_points","s");
% ss = reshape(ss,3,[]);
% %tt=log.data(1,"t",[]);
% plot(ss');
%% 図示
if illustration == 1
    fig1=figure(1);
    fig1.Color = 'white';
    plot(robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(robot_p(2,:),'LineWidth', 2);
    plot(robot_p(3,:),'LineWidth', 2);
    legend('\it{px}','\it{py}','\it{pz}','FontSize', 18);
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
    legend('\it{w}_{\it{\phi}}','\it{w}_{\it{\theta}}','\it{w}_{\it{\psi}}','FontSize', 18);
    hold off;
    xlabel('step');
    ylabel('angle');
    grid on;
    fig3=figure(3);
    fig3.Color = 'white';
    plot(robot_v(1,:),'LineWidth', 2);
    hold on;
    plot(robot_v(2,:),'LineWidth', 2);
    plot(robot_v(3,:),'LineWidth', 2);
    legend('\it{v}_{\it{\phi}}','\it{v}_{\it{\theta}}','\it{v}_{\it{\psi}}','FontSize', 18);
    fig4=figure(4);
    fig4.Color = 'white';
    for i =1:length(snum)
        name = ['sensor',num2str(i)];
        plot(sensor_data(i,:),'Displayname',name,'LineWidth', 2);
        hold on;
    end
    xlabel('step','FontSize', 14);
    ylabel('Distance of the lidar [m]','FontSize', 14);
    legend show
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
    ylim([0 1])
    xlabel('step');
    ylabel('evaluation value');
    legend('JP','JX','JY');
    grid on;
end


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