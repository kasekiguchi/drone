%%GUIデータ用グラフプロット
opengl software
close all hidden;
clear all;
%% データのインポート
load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
disp('load finished')

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.x(1,i) = log.Data.agent.estimator.result{i}.state.p(1,1);      %位置x
    data.y(1,i) = log.Data.agent.estimator.result{i}.state.p(2,1);      %位置y
    data.z(1,i) = log.Data.agent.estimator.result{i}.state.p(3,1);      %位置z
    data.xr(1,i) = log.Data.agent.reference.result{i}.state.p(1,1);     %位置xリファレンス
    data.yr(1,i) = log.Data.agent.reference.result{i}.state.p(2,1);     %位置yリファレンス
    data.zr(1,i) = log.Data.agent.reference.result{i}.state.p(3,1);     %位置zリファレンス
    data.qx(1,i) = log.Data.agent.estimator.result{i}.state.q(1,1);     %ロール
    data.qy(1,i) = log.Data.agent.estimator.result{i}.state.q(2,1);     %ピッチ
    data.qz(1,i) = log.Data.agent.estimator.result{i}.state.q(3,1);     %ヨー
    data.vx(1,i) = log.Data.agent.estimator.result{i}.state.v(1,1);     %速度x
    data.vy(1,i) = log.Data.agent.estimator.result{i}.state.v(2,1);     %速度y
    data.vz(1,i) = log.Data.agent.estimator.result{i}.state.v(3,1);     %速度z
    data.wx(1,i) = log.Data.agent.estimator.result{i}.state.w(1,1);     %角速度ロール
    data.wy(1,i) = log.Data.agent.estimator.result{i}.state.w(2,1);     %角速度ピッチ
    data.wz(1,i) = log.Data.agent.estimator.result{i}.state.w(3,1);     %角速度ヨー
    data.u1(1,i) = log.Data.agent.input{i}(1,1);
    data.u2(1,i) = log.Data.agent.input{i}(2,1);
    data.u3(1,i) = log.Data.agent.input{i}(3,1);
    data.u4(1,i) = log.Data.agent.input{i}(4,1);
end


%% 各グラフで出力
serect = 0 %0:各グラフで出力,1:いっぺんに出力
if serect ==0
close all
clc

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

colororder(newcolors)
%位置p
plot(data.t,data.x,'LineWidth',1);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
plot(data.t,data.y,'LineWidth',1);
plot(data.t,data.z,'LineWidth',1);
plot(data.t,data.xr,'LineWidth',1,'LineStyle','--');
plot(data.t,data.yr,'LineWidth',1,'LineStyle','--');
plot(data.t,data.zr,'LineWidth',1,'LineStyle','--');
xlim([data.t(1) data.t(end)])
hold off

%姿勢角q
figure
colororder(newcolors)
plot(data.t,data.qx,'LineWidth',1);
xlabel('Time [s]');
ylabel('q');
hold on
grid on
plot(data.t,data.qy,'LineWidth',1);
plot(data.t,data.qz,'LineWidth',1);
xlim([data.t(1) data.t(end)])
hold off

%速度v
figure
colororder(newcolors)
plot(data.t,data.vx,'LineWidth',1);
xlabel('Time [s]');
ylabel('v');
hold on
grid on
plot(data.t,data.vy,'LineWidth',1);
plot(data.t,data.vz,'LineWidth',1);
xlim([data.t(1) data.t(end)])
hold off

%角速度w
figure
colororder(newcolors)
plot(data.t,data.wx,'LineWidth',1);
xlabel('Time [s]');
ylabel('w');
hold on
grid on
plot(data.t,data.wy,'LineWidth',1);
plot(data.t,data.wz,'LineWidth',1);
xlim([data.t(1) data.t(end)])
hold off

figure
plot(data.x,data.y);

figure
plot3(data.x,data.y,data.z);

else
%% いっぺんに出力
close all

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];
colororder(newcolors)

num = 3;
% xlim([data.t(1) data.t(end)])
subplot(2, num, 1);
p1 = plot(data.t, data.x);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
p2 = plot(data.t, data.y);
p3 = plot(data.t, data.z);
p4 = plot(data.t, data.xr);
p5 = plot(data.t, data.yr);
p6 = plot(data.t, data.zr);
xlim([data.t(1) data.t(end)])
hold off
title('Position p of agent1');
% 姿勢角
subplot(2, num, 2);
p7 = plot(data.t, data.qx);
xlabel('Time [s]');
ylabel('q');
hold on
grid on
p8 = plot(data.t, data.qy);
p9 = plot(data.t, data.qz);
xlim([data.t(1) data.t(end)])
hold off
title('Attitude q of agent1');
% 速度
subplot(2, num, 3);
p10 = plot(data.t, data.vx);
xlabel('Time [s]');
ylabel('v');
hold on
grid on
p11 = plot(data.t, data.vy);
p12 = plot(data.t, data.vz);
xlim([data.t(1) data.t(end)])
hold off
title('Velocity v of agent1');
% 角速度
subplot(2, num, 4);
p13 = plot(data.t, data.wx);
xlabel('Time [s]');
ylabel('w');
hold on
grid on
p14 = plot(data.t, data.wy);
p15 = plot(data.t, data.wz);
xlim([data.t(1) data.t(end)])
hold off
title('Angular velocity w of agent1');

subplot(2,num,5);
plot(data.x,data.y);
xlabel('x');
ylabel('y');

subplot(2,num,6);
plot3(data.x,data.y,data.z);
xlabel('x');
ylabel('y');
zlabel('z');


set([p4,p5,p6],'LineStyle','--','LineWidth',1);
set([p1,p2,p3,p7,p8,p9,p10,p11,p12,p13,p14,p15],'LineWidth',1);
end