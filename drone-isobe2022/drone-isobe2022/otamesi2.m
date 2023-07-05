close all hidden;
clear all;
clc;

load("simulation_7_5_saddle.mat")

for i = 1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);                                      %時間t
    data.p(:,i) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
end

a1 = animatedline('Color',[0 .7 .7]);
% a2 = animatedline('Color',[0 .5 .5]);
T = 0.01;

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
    view(40,30)
    pause(T);
end