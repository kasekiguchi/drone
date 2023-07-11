%% GUI projectの情報を用いたパラメータ解析
% pinv([A;A2])*-1*ones でパラメータ推定するやつ
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
[A,X,At,Xt] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(1,2:end),eye(3));
num = 2;
[A2,X2,A2t,X2t] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(num,2:end),RodriguesQuaternion(Eul2Quat([0,0,(num-1)*pi/20]')));
% [A3,X3,A3t,X3t] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(3,2:end),RodriguesQuaternion(Eul2Quat([0,0,2*pi/20]')));
% [A4,X4,A4t,X4t] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(8,2:end),RodriguesQuaternion(Eul2Quat([0,0,7*pi/20]')));
% [A5,X5,A5t,X5t] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(9,2:end),RodriguesQuaternion(Eul2Quat([0,0,8*pi/20]')));
% [A0,X02,At0,Xt0] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(1,2:end),RodriguesQuaternion(Eul2Quat([0,0,pi/180]')));
%% 不要ぱらの除去
ds = find(A2(1,:)==0);
A2(:,ds) = [];
A(:,ds) = [];
At(:,ds) = [];
A2t(:,ds) = [];
Xt(:,ds) = [];
X2t(:,ds) = [];
X12 = pinv([A;A2])*(-1*ones(size([A;A2],1),1));
%固有値計算
S = svd(A)';% 特異値の計算
A12 = [A;A2];
% A12 = [A,A2(:,16:18),A2(:,22:24),A2(:,28:30)];
X12 = pinv(A12)*(-1*ones(size(A12,1),1));
%% 逐次最小
% P_stack = zeros(size(A,2),size(A,2),size(A,1));
% P_stack2 = zeros(size(A2,2),size(A2,2),size(A2,1));
% P_stack12 = zeros(size(A12,2),size(A12,2),size(A12,1));
% for j=1:1:length(A12)
%     if j ==1
%         [Xn,Pn] = param_analysis_eq(A(j,:)',zeros(size(A,2),1),eye(size(A,2)));
%         [Xn2,Pn2] = param_analysis_eq(A2(j,:)',zeros(size(A2,2),1),eye(size(A2,2)));
%         [Xn12,Pn12] = param_analysis_eq(A12(j,:)',zeros(size(A12,2),1),eye(size(A12,2)));
%         P_stack(:,:,j) = Pn;
%         P_stack2(:,:,j) = Pn2;
%         P_stack12(:,:,j) = Pn12;
%     else
%         [Xn,Pn] = param_analysis_eq(A(j,:)',Xn,Pn );
%         [Xn2,Pn2] = param_analysis_eq(A2(j,:)',Xn2,Pn2);
%         [Xn12,Pn12] = param_analysis_eq(A12(j,:)',Xn12,Pn12);
%         P_stack(:,:,j) = Pn;
%         P_stack2(:,:,j) = Pn2;
%         P_stack12(:,:,j) = Pn12;
%     end
% end

% %% 分散の保存
% variance = zeros(size(P_stack,2),size(P_stack,3));
% for j=1:size(P_stack,3)
%     variance(:,j) = diag(P_stack(:,:,j));
% end
%% パラメータの計算
offset_est = pinv([X12(1)*eye(3);X12(2)*eye(3);X12(3)*eye(3)])*[X12(4:12)];
Rsx = pinv([X12(1)*eye(3);X12(2)*eye(3);X12(3)*eye(3)])*[X12(13:15);X12(19:21);X12(25:27)];
Rsy = pinv([X12(1)*eye(3);X12(2)*eye(3);X12(3)*eye(3)])*[X12(16:18);X12(22:24);X12(28:30)];
Rsz = cross(Rsx/vecnorm(Rsx),Rsy/vecnorm(Rsy));
Rs = [Rsx,Rsy,Rsz];
% R1y = R1x + [0;1;0];
% R1y = R1y/vecnorm(R1y);
% R1z = cross(R1x,R1y);
% R1y = cross(R1z,R1y);
% R1 = [R1x R1y R1z];
% %pb + Rb* + Rb*R1x;
% ad = pinv(R1x)*X(13:15);
% bd = pinv(R1x)*X(16:18);
% cd = pinv(R1x)*X(19:21);
% abcd = [ad bd cd];
% vecnorm(abcd);
% -abcd/vecnorm(abcd);
% ps = offset_est;
% pb = robot_pt;
% qt = Eul2Quat(robot_qt);
% y = sensor_data;
%% 交点比較
% sp = pb + quat_times_vec(qt,ps) + y.*quat_times_vec(qt,R1x);
% figure(8);
% plot(sp')
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
    legend('x,y,z');
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
    hold off;
    xlabel('step');
    ylabel('variance of wall param');
    legend('a/d','b/d','c/d');
    grid on;
    fig8=figure(8);
    fig8.Color = 'white';
    for i=4:6
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('P1*a/d','P2*a/d','P3*a/d');
    grid on;
    fig9=figure(9);
    fig9.Color = 'white';
    for i=13:15
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R11*a/d','R21*a/d','R31*a/d');
    grid on;
    fig10=figure(10);
    fig10.Color = 'white';
    for i=16:18
        plot(variance(i,:),'LineWidth', 2);
        hold on;
    end
    hold off;
    xlabel('step');
    ylabel('variance of offset*wallparam');
    legend('R12*a/d','R22*a/d','R32*a/d');
    grid on;
end

%% 関数たち
function [A,X,Cf,var] = param_analysis(robot_p, robot_q, sensor_data,R_num)
   syms p [3 1] real
   syms Rb [3 3] real
   syms y real 
    
   syms R_sens [3 3] real
   syms psb [3 1] real
   syms a b c d real
   A = [a b c];
   X = p +Rb*psb + y*Rb*R_sens*R_num*[1;0;0];
   %%
   eq = [A d]*[X;1];
   clear Cf
   var=[a.*psb',b.*psb',c.*psb',reshape(a*R_sens,1,numel(R_sens)),reshape(b*R_sens,1,numel(R_sens)),reshape(c*R_sens,1,numel(R_sens))];
   for j = 1:length(var)
     Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
   end
   Cf = [p1,p2,p3,Cf];
   ds=find(Cf==0);    
   Cf(ds)=[];
   var = [a,b,c,var]/d;
   var(ds)=[];
   qt = Eul2Quat(robot_q);
   qt = qt./vecnorm(qt,2);
   A = Cfa(robot_p,qt,sensor_data,R_num)';
   ds = find(A(1,:)==0);
   % A(:,ds) = [];
   X = pinv(A)*(-1*ones(size(A,1),1));
end

