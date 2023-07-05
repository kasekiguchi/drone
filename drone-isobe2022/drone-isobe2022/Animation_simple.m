close all hidden;
clear all;
clc;

load("experiment_6_20_circle_estimaterdata.mat")

for i = find(log.Data.phase==102,1,'first'):find(log.Data.t,1,'last')
    data.t(1,i-find(log.Data.phase==102,1,'first')+1) = log.Data.t(i,1);                                      %時間t
    data.p(:,i-find(log.Data.phase==102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
end

a1 = animatedline('Color',[0 .7 .7]);
% a2 = animatedline('Color',[0 .5 .5]);
T = 0.02;

% axis([0 20 -1 1])
% x = linspace(0,20,10000);
for k = 1:size(data.p,2)

    % first line
    x = data.p(1,k);
    y = data.p(2,k);
    z = data.p(3,k);
    addpoints(a1,x,y,z);
    grid on

    % update screen
    drawnow limitrate
    view(40,10)
    pause(T);
end