%% GUI projectの情報を用いたパラメータ解析
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
cd(cf); close all hidden; clear all; userpath('clear');

%% フラグ設定
illustration= 1; %1で図示，0で非表示

%% Log Dataの読み取りと格納

%log = LOGGER('./Data/100_2noise_Log(27-Jun-2023_16_37_16).mat');
log = LOGGER('./Data/Log(28-Jun-2023_18_01_42).mat');
%%
tspan = [0.1 99];
robot_p  = log.data(1,"p","s","ranget",tspan)';
robot_pt  = log.data(1,"p","p","ranget",tspan)';
robot_vt  = log.data(1,"v","p","ranget",tspan)';
robot_q  = log.data(1,"q","s","ranget",tspan)';
robot_qt  = log.data(1,"q","p","ranget",tspan)';
sensor_data = (log.data(1,"length","s","ranget",tspan))';
ref_p = log.data(1,"p","r","ranget",tspan)';
ref_q = log.data(1,"q","r","ranget",tspan)';

%% 不要データの除去
nanIndices = isnan(sensor_data);
ds = find(nanIndices==1);
sensor_data(:,ds) = [];
robot_p(:,ds) = [];
robot_pt(:,ds) = [];
robot_q (:,ds) = [];
robot_qt(:,ds) = [];

%% 解析(回帰分析)
[A,X,Av,Xv] = param_analysis(robot_pt(:,1:end-1),robot_qt(:,1:end-1),sensor_data(1,2:end),NaN);
% [A2,X2,Av2,Xv2] = param_analysis(robot_pt,robot_qt,sensor_data(2,:),RodriguesQuaternion(Eul2Quat([0,0,pi/180]')));
% maxt = size(robot_p,2);
% [A2,X2,Av2,Xv2] = param_analysis(robot_pt(:,1000:maxt),robot_qt(:,1000:maxt),sensor_data(:,1000:maxt),NaN);
% [A4,X4,Av,Xv] = param_analysis(robot_pt(:,2:maxt),robot_qt(:,2:maxt),sensor_data(:,2:maxt),NaN);
S = svd(A)'% 特異値の計算
%% パラメータの計算
%X(1:3) = X(1:3)/vecnorm(X(1:3));
offset_esta = [X(4)/X(1);X(5)/X(1);X(6)/X(1);];
offset_estb = [X(7)/X(2);X(8)/X(2);X(9)/X(2);];
offset_estc = [X(10)/X(3);X(11)/X(3);X(12)/X(3);];
offset_est = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:12)]
% offset_estS = pinv([XS(1)*eye(3);XS(2)*eye(3);XS(3)*eye(3)])*[XS(4:6);XS(7:9);XS(10:12)];
R_sens_est1a = [X(13)/X(1),X(14)/X(1),X(15)/X(1)]';
R_sens_est1b = [X(16)/X(2),X(17)/X(2),X(18)/X(2)]';
R_sens_est1c = [X(19)/X(3),X(20)/X(3),X(21)/X(3)]';
R_sens_est1 = [R_sens_est1a,R_sens_est1b,R_sens_est1c];
R1x = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(13:21)];
R1x = R1x/vecnorm(R1x)

R1y = R1x + [0;1;0];
R1y = R1y/vecnorm(R1y);
R1z = cross(R1x,R1y);
R1y = cross(R1z,R1y);
R1 = [R1x R1y R1z];
%pb + Rb* + Rb*R1x;
ad = pinv(R1x)*X(13:15);
bd = pinv(R1x)*X(16:18);
cd = pinv(R1x)*X(19:21);
abcd = [ad bd cd];
vecnorm(abcd)
-abcd/vecnorm(abcd)

ps = pinv([ad*eye(3); bd*eye(3); cd*eye(3)])*[X(4:12)];
pb = robot_pt;
qt = Eul2Quat(robot_qt);
y = sensor_data;
ps
ps = offset_est
%%
sp = pb + quat_times_vec(qt,ps) + y.*quat_times_vec(qt,R1x);
plot(sp')
hold on
%%
ss=log.data(1,"sensor.result.sensor_points","s","ranget",tspan);
ss = reshape(ss,3,[]);

%tt=log.data(1,"t",[]);
plot(ss');

%%
ps = [0.1;0;0];
R1 = Rodrigues([0 1 0],pi/6);
R1x = R1(:,1);
s = gui.agent.sensor.lidar;
       p = pb + quat_times_vec(qt,ps);   % センサー位置
      % %% ここは工夫の余地あり．idsを絞れればそれだけ早くなる．
d = zeros(1,size(p,2));
       e = quat_times_vec(qt,R1x); % センサーの向き
      for i = 1:size(p,2)
      % p = pb + RodriguesQuaternion(Eul2Quat(robot_qt(:,i)))*ps;   % センサー位置
      % e = RodriguesQuaternion(Eul2Quat(robot_qt(:,i)))*R1x; % センサーの向き
      % p = pb + RodriguesQuaternion(qt(:,i))*ps;   % センサー位置
      % e = RodriguesQuaternion(qt(:,i))*R1x; % センサーの向き
      rp = s.ic - p(:,i)';               % 内心への相対位置
      ip1 = sum(rp .* s.fn, 2) < 0; % 「内積が負の壁」が見える向きの壁面
      Pi = s.inverse_matrices(p(:,i), ip1);
      %ip2 = rp*e > 0; % 「内積が正の壁」がレーザー方向にある壁
      ids = ip1;                      % & ip2;

      d(i) = s.cross_point(e(:,i), Pi);
      end
      plot(d')
      hold on 
      plot(y)

      %%
% offset_esta2 = [X2(4)/X2(1);X2(5)/X2(1);X2(6)/X2(1);];
% offset_estb2 = [X2(7)/X2(2);X2(8)/X2(2);X2(9)/X2(2);];
% offset_estc2 = [X2(10)/X2(3);X2(11)/X2(3);X2(12)/X2(3);];
% offset_est2 = pinv([X2(1)*eye(3);X2(2)*eye(3);X2(3)*eye(3)])*[X2(4:12)];
% % offset_estS = pinv([XS(1)*eye(3);XS(2)*eye(3);XS(3)*eye(3)])*[XS(4:6);XS(7:9);XS(10:12)];
% R_sens_est1a2 = [X2(13)/X2(1),X2(14)/X2(1),X2(15)/X2(1)]';
% R_sens_est1b2 = [X2(16)/X2(2),X2(17)/X2(2),X2(18)/X2(2)]';
% R_sens_est1c2 = [X2(19)/X2(3),X2(20)/X2(3),X2(21)/X2(3)]';
% R_sens_est12 = [R_sens_est1a2,R_sens_est1b2,R_sens_est1c2];
% 
% 
% offset_esta4 = [X4(4)/X4(1);X4(5)/X4(1);X4(6)/X4(1);];
% offset_estb4 = [X4(7)/X4(2);X4(8)/X4(2);X4(9)/X4(2);];
% offset_estc4 = [X4(10)/X4(3);X4(11)/X4(3);X4(12)/X4(3);];
% offset_est4= pinv([X4(1)*eye(3);X4(2)*eye(3);X4(3)*eye(3)])*[X4(4:12)];
% % offset_estS = pinv([XS(1)*eye(3);XS(2)*eye(3);XS(3)*eye(3)])*[XS(4:6);XS(7:9);XS(10:12)];
% R_sens_est1a4 = [X4(13)/X4(1),X4(14)/X4(1),X4(15)/X4(1)]';
% R_sens_est1b4 = [X4(16)/X4(2),X4(17)/X4(2),X4(18)/X4(2)]';
% R_sens_est1c4 = [X4(19)/X4(3),X4(20)/X4(3),X4(21)/X4(3)]';
% R_sens_est14 = [R_sens_est1a4,R_sens_est1b4,R_sens_est1c4];
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
    plot(sensor_data(3,:));
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
end

%% 関数たち
function [A,X,Cf,var] = param_analysis(robot_p, robot_q, sensor_data,R_num)
    % % Known Parameters
    % syms p [3 1] real
    % syms Rb [3 3] real
    % syms y real 
    % % Unknown Parameters
    % syms Rs [3 3] real
    % syms psb [3 1] real
    % syms a b c d real
    % if isnan(R_num)
    %     R_num = RodriguesQuaternion(Eul2Quat([0,0,0]'));
    % end
    % A = [a b c];
    % X = p +Rb*psb + y*Rb*Rs*R_num*[1;0;0];
    % %%
    % eq = [A d]*[X;1];
    % clear Cf
    % var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    % for j = 1:length(var)
    %     Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
    % end
    % Cf = [p1,p2,p3,Cf];
    % ds=find(Cf==0);
    % Cf(ds)=[];
    % var = [a,b,c,var]/d;
    % var(ds)=[];
    % A = zeros(size(robot_p,2),size(Cf,2));
    % for i =1:size(robot_p,2)
    %         pb=robot_p(:,i);
    %         q = robot_q(:,i);
    %         r = sensor_data(i);
    %         R = RodriguesQuaternion(Eul2Quat(q));
    %         Cfc = subs(Cf,{p1, p2, p3, Rb1_1, Rb1_2, Rb1_3, Rb2_1, Rb2_2, Rb2_3, Rb3_1, Rb3_2, Rb3_3, y},{pb(1),pb(2),pb(3),R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1),R(3,2),R(3,3),r});
    %         A(i,:) = Cfc;
    % end
    Cf=[];
   var = [];
   qt = Eul2Quat(robot_q);
   qt = qt./vecnorm(qt,2);
    A = Cfa(robot_p,qt,sensor_data,eye(3))';
    X = pinv(A)*(-1*ones(size(A,1),1));
end
