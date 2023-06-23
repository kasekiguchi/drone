%% GUI projectの情報を用いたパラメータ解析
%% Initialize settings
% set path
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

load('t50');
len = length(log.Data.agent.sensor.result);
robot_p  = zeros(size(log.Data.agent.sensor.result{1,1}.state.p,1),len);
robot_pt  = zeros(size(log.Data.agent.plant.result{1,1}.state.p,1),len);
robot_vt  = zeros(size(log.Data.agent.plant.result{1,1}.state.v,1),len);
robot_q  = zeros(size(log.Data.agent.sensor.result{1,1}.state.q,1),len);
robot_qt  = zeros(size(log.Data.agent.plant.result{1,1}.state.q,1),len);
sensor_data = zeros(size(log.Data.agent.sensor.result{1,1}.length,1),len);
ref_p = zeros(size(log.Data.agent.reference.result{1, 1}.state.p,1),len);
ref_q = zeros(size(log.Data.agent.reference.result{1, 1}.state.q,1),len);
for i=1:len
robot_p(:,i) = log.Data.agent.sensor.result{1,i}.state.p;
robot_pt(:,i) = log.Data.agent.plant.result{1,i}.state.p;
robot_q(:,i) = log.Data.agent.sensor.result{1,i}.state.q;
robot_qt(:,i) = log.Data.agent.plant.result{1,i}.state.q;
sensor_data(:,i) = log.Data.agent.sensor.result{1,i}.length;
ref_p(:,i) = log.Data.agent.reference.result{1,i}.state.p;
ref_q(:,i) = log.Data.agent.reference.result{1,i}.state.q;
end

%% 解析(回帰分析)
[A,X,Av,Xv] = param_analysis(robot_pt,robot_qt,sensor_data,NaN);
% [A,X,Av,Xv] = param_analysis(robot_pt(:,1000:2500),robot_qt(:,1000:2500),sensor_data(:,1000:2500),NaN);
S = svd(A);% 特異値の計算
%% パラメータの計算
offset_esta = [X(4)/X(1);X(5)/X(1);X(6)/X(1);];
offset_estb = [X(7)/X(2);X(8)/X(2);X(9)/X(2);];
offset_estc = [X(10)/X(3);X(11)/X(3);X(12)/X(3);];
offset_est = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:6);X(7:9);X(10:12)];
% offset_estS = pinv([XS(1)*eye(3);XS(2)*eye(3);XS(3)*eye(3)])*[XS(4:6);XS(7:9);XS(10:12)];
R_sens_est1a = [X(13)/X(1),X(14)/X(1),X(15)/X(1)];
R_sens_est1b = [X(16)/X(2),X(17)/X(2),X(18)/X(2)];
R_sens_est1c = [X(19)/X(3),X(20)/X(3),X(21)/X(3)];
R_sens_est1 = [R_sens_est1a;R_sens_est1b;R_sens_est1c];
%% 図示
if illustration == 1
    fig1=figure(1);
    fig1.Color = 'white';
    plot(robot_p(1,:),'LineWidth', 2);
    hold on;
    plot(robot_p(2,:),'LineWidth', 2);
    plot(robot_p(3,:),'LineWidth', 2);
    legend('x,y,z');
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
    legend('w_x,w_y,w_z');
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
    legend('v_x,v_y,v_z');
    fig4=figure(4);
    fig4.Color = 'white';
    plot(sensor_data);
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
    % Known Parameters
    syms p [3 1] real
    syms Rb [3 3] real
    syms y real 
    % Unknown Parameters
    syms Rs [3 3] real
    syms psb [3 1] real
    syms a b c d real
    if isnan(R_num)
        R_num = RodriguesQuaternion(Eul2Quat([0,0,0]'));
    end
    A = [a b c];
    X = p +Rb*psb + y*Rb*Rs*R_num*[1;0;0];
    %%
    eq = [A d]*[X;1];
    clear Cf
    var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    for j = 1:length(var)
        Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
    end
    Cf = [p1,p2,p3,Cf];
    ds=find(Cf==0);
    Cf(ds)=[];
    var = [a,b,c,var]/d;
    var(ds)=[];
    A = zeros(size(robot_p,2),size(Cf,2));
    B = zeros(size(robot_p,2),1);
    for i =1:size(robot_p,2)
            pb=robot_p(:,i);
            q = robot_q(:,i);
            r = sensor_data(i);
            R = RodriguesQuaternion(Eul2Quat(q));
            Cfc = subs(Cf,{p1, p2, p3, Rb1_1, Rb1_2, Rb1_3, Rb2_1, Rb2_2, Rb2_3, Rb3_1, Rb3_2, Rb3_3, y},{pb(1),pb(2),pb(3),R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1),R(3,2),R(3,3),r});
            A(i,:) = Cfc;
            B(i,:) = -1;
    end
    X = pinv(A)*B;
end
