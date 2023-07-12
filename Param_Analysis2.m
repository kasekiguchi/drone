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

%% Log Dataの読み取りと格納
log = LOGGER('./Data/2wall_1015_Log(10-Jul-2023_14_31_32).mat');
% log = LOGGER('./Data/onlyxyz_Log.mat');
%% ログ
tspan = [0 ,100];
% tspan = [0 99];
robot_p  = log.data(1,"p","s")';
robot_pt  = log.data(1,"p","p")';
robot_vt  = log.data(1,"v","p")';
robot_q  = log.data(1,"q","s")';
robot_qt  = log.data(1,"q","p")';
sensor_data = (log.data(1,"length","s"))';
ref_p = log.data(1,"p","r")';
ref_q = log.data(1,"q","r")';

%% 不要データの除去
nanIndices = isnan(sensor_data(1,:));
ds = find(nanIndices==1);
sensor_data(:,ds) = [];
robot_p(:,ds) = [];
robot_pt(:,ds) = [];
robot_q (:,ds) = [];
robot_qt(:,ds) = [];


%% 解析(回帰分析)
end1=10000;
num = 3;%2本目センサのいっぽん目からの本数
[A,X,At,Xt] = param_analysis(robot_pt(:,1:end1-1),robot_qt(:,1:end1-1),sensor_data(1,2:end1),eye(3));

%% 1本目でのパラ推定，固有値計算
offset = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:12)];
Rsx = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*X(13:21);
S = svd(A)';% 特異値の計算

%% 1本目の情報使って2本目の計算
num = 2;
[A2,X2,A2t,X2t] = param_analysis1known(robot_pt(:,1:end1-1),robot_qt(:,1:end1-1),sensor_data(num,2:end1),RodriguesQuaternion(Eul2Quat([0,0,(num-1)*pi/20]')),offset,Rsx);
%% 2本目でのパラ推定，固有値計算
Rsy = pinv([X2(1)*eye(3);X2(2)*eye(3);X2(3)*eye(3)])*X2(4:12);
Rsz = cross(Rsx/vecnorm(Rsx),Rsy/vecnorm(Rsy));
Rs = [Rsx,Rsy,Rsz];
%% 逐次最小(2ほんの情報それぞれで)＆逐次パラメータ計算

P_stack = zeros(size(A,2),size(A,2),size(A,1));
P_stack2 = zeros(size(A2,2),size(A2,2),size(A2,1));

for j=1:1:length(A)
    if j ==1
        [Xn,Pn] = param_analysis_eq(A(j,:)',zeros(size(A,2),1),eye(size(A,2)));
        P_stack(:,:,j) = Pn;
        offset_eq = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsx_eq = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*Xn(13:21);
        [X2n,P2n] = param_analysis_eq(A2(j,:)',zeros(size(A2,2),1),eye(size(A2,2)));
        P_stack2(:,:,j) = P2n;
        Rsy_eq = pinv([X2n(1)*eye(3);X2n(2)*eye(3);X2n(3)*eye(3)])*X2n(4:12);
        Rsz_eq = cross(Rsx_eq/vecnorm(Rsx_eq),Rsy_eq/vecnorm(Rsy_eq));
        Rs_eq = [Rsx_eq,Rsy_eq,Rsz_eq];
    else
        [Xn,Pn] = param_analysis_eq(A(j,:)',Xn,Pn);
        P_stack(:,:,j) = Pn;
        offset_eq = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*[Xn(4:12)];
        Rsx_eq = pinv([Xn(1)*eye(3);Xn(2)*eye(3);Xn(3)*eye(3)])*Xn(13:21);
        [X2n,P2n] = param_analysis_eq(A2(j,:)',X2n,P2n);
        P_stack2(:,:,j) = P2n;
        Rsy_eq = pinv([X2n(1)*eye(3);X2n(2)*eye(3);X2n(3)*eye(3)])*X2n(4:12);
        Rsz_eq = cross(Rsx_eq/vecnorm(Rsx_eq),Rsy_eq/vecnorm(Rsy_eq));
        Rs_eq = [Rsx_eq,Rsy_eq,Rsz_eq];
    end
end

%% 分散の保存
variance1 = zeros(size(P_stack,2),size(P_stack,3));
for j=1:size(P_stack,3)
    variance1(:,j) = diag(P_stack(:,:,j));
end
variance2 = zeros(size(P_stack2(4:end,4:end,:),2),size(P_stack2,3));
for j=1:size(P_stack2,3)
    variance2(:,j) = diag(P_stack2(4:end,4:end,j));
end
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
    plot(robot_vt(1,:),'LineWidth', 2);
    hold on;
    plot(robot_vt(2,:),'LineWidth', 2);
    plot(robot_vt(3,:),'LineWidth', 2);
    legend('\it{v}_{\it{\phi}}','\it{v}_{\it{\theta}}','\it{v}_{\it{\psi}}','FontSize', 18);
    fig4=figure(4);
    fig4.Color = 'white';
    plot(sensor_data(1,:));
    hold on;
    plot(sensor_data(2,:));
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
        plot(variance1(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 1]);
    hold off;
    xlabel('step');
    ylabel('variance of wall param');
    legend('a/d','b/d','c/d');
    grid on;
    fig8=figure(8);
    fig8.Color = 'white';
    for i=4:12
        plot(variance1(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 1]);
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('P1*a/d','P2*a/d','P3*a/d','P1*b/d','P2*b/d','P3*b/d','P1*c/d','P2*c/d','P3*c/d');
    grid on;
    fig9=figure(9);
    fig9.Color = 'white';
    for i=13:21
        plot(variance1(i,:),'LineWidth', 2);
        hold on;
    end
    ylim([0 1]);
    hold off;
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R11*a/d','R21*a/d','R31*a/d','R11*b/d','R21*b/d','R31*b/d','R11*c/d','R21*c/d','R31*c/d');
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    for i=1:9
        plot(variance2(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    ylim([0 1]);
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R12*a/d','R22*a/d','R32*a/d','R12*b/d','R22*b/d','R32*b/d','R12*c/d','R22*c/d','R32*c/d');
    grid on;
end

%% 関数たち
function [A,X,Cf,var] = param_analysis(robot_p, robot_q, sensor_data,R_num)
    syms p [3 1] real
    syms Rb [3 3] real
    syms y real 
    syms Rs [3 3] real
    syms Rn [3 3] real
    syms psb [3 1] real
    syms a b c d real
    
    A = [a b c];
    X = p +Rb*psb + y*Rb*Rs*[1;0;0];
    eq =[A d]*[X;1];
    var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    for i = 1:length(var)
        Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
    end
    Cf = [p1,p2,p3,Cf];
    ds=find(Cf==0);
    Cf(ds)=[];
    var = [a,b,c,var]/d;
    var(ds)=[];
    simplify(eq/d - Cf*var' ) 
    qt = Eul2Quat(robot_q);
    qt = qt./vecnorm(qt,2);
    A = Cfa(robot_p,qt,sensor_data,R_num)';
    ds = find(A(1,:)==0);
    A(:,ds) = [];
    X = pinv(A)*(-1*ones(size(A,1),1));
end
function [A,X,Cf,var] = param_analysis1known(robot_p, robot_q, sensor_data,R_num,Psb,R1)
    syms p [3 1] real
    syms Rb [3 3] real
    syms y real 
    syms Rs1 [3 1] real
    syms Rs23 [3 2] real
    syms Rn [3 3] real
    syms psb [3 1] real
    syms a b c d real
    
    A = [a b c];
    X = p +Rb*psb + y*Rb*[Rs1,Rs23]*Rn*[1;0;0];
    
    %%
    eq =[A d]*[X;1];
    var=[reshape(a*Rs23,1,numel(Rs23)),reshape(b*Rs23,1,numel(Rs23)),reshape(c*Rs23,1,numel(Rs23))];
    for i = 1:length(var)
    Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
    end
    Cf = [(Rb*psb)'+(Rn1_1*y*Rb*Rs1)'+[p1,p2,p3],Cf];
    % Cf = [p1,p2,p3,Cf];
    ds=find(Cf==0)
    Cf(ds)=[];
    var = [a,b,c,var]/d;
    var(ds)=[];
    simplify(eq/d - Cf*var' ) 
    qt = Eul2Quat(robot_q);
    qt = qt./vecnorm(qt,2);
    A = Cf1known(robot_p,qt,sensor_data,R_num,Psb,R1)';
    ds = find(A(1,:)==0);
    A(:,ds) = [];
    Cf(ds)=[];
    var(ds)=[];
    X = pinv(A)*(-1*ones(size(A,1),1));
end
