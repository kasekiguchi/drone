opengl software
close all hidden;
clear all;
clc;

load("experiment_6_20_circle_estimaterdata.mat")

for i = 1:find(log.Data.phase==108,1,'first')-find(log.Data.phase==102,1,'first')+1
    data.t(1,i) = log.Data.t(i+find(log.Data.t>18,1,'first'),1);                                      %時間t
    data.x(1,i) = log.Data.agent.estimator.result{i+find(log.Data.phase==102,1,'first')-1}.state.p(1,1);      %位置x
    data.y(1,i) = log.Data.agent.estimator.result{i+find(log.Data.phase==102,1,'first')-1}.state.p(2,1);      %位置y
    data.z(1,i) = log.Data.agent.estimator.result{i+find(log.Data.phase==102,1,'first')-1}.state.p(3,1);
end
%% 

% plot3(data.x,data.y,data.z);
% grid on
% zlim([0.5 1.3])

plot(data.x,data.y);
grid 
xlabel('x [m]');
ylabel('y [m]');
ax = gca;
fontSize = 16; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 
