opengl software
close all hidden;

% data.x = log.Data.agent.estimator.result{1}.state.p(1,1);
% data.a = data.x{1}.state.p;

% data.b = size(log.Data.agent.estimator.result,2);

for i = 1:1:find(log.Data.t,1,'last')
    data.t(1,i) = log.Data.t(i,1);
    data.x(1,i) = log.Data.agent.estimator.result{i}.state.p(1,1);
    data.y(1,i) = log.Data.agent.estimator.result{i}.state.p(2,1);
    data.z(1,i) = log.Data.agent.estimator.result{i}.state.p(3,1);
    data.qx(1,i) = log.Data.agent.estimator.result{i}.state.q(1,1);
    data.qy(1,i) = log.Data.agent.estimator.result{i}.state.q(2,1);
    data.qz(1,i) = log.Data.agent.estimator.result{i}.state.q(3,1);
    data.vx(1,i) = log.Data.agent.estimator.result{i}.state.v(1,1);
    data.vy(1,i) = log.Data.agent.estimator.result{i}.state.v(2,1);
    data.vz(1,i) = log.Data.agent.estimator.result{i}.state.v(3,1);
    data.wx(1,i) = log.Data.agent.estimator.result{i}.state.w(1,1);
    data.wy(1,i) = log.Data.agent.estimator.result{i}.state.w(2,1);
    data.wz(1,i) = log.Data.agent.estimator.result{i}.state.w(3,1);
end
%% plot
close all
clc
plot(data.t,data.x,'LineWidth',2);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
plot(data.t,data.y,'LineWidth',2);
plot(data.t,data.z,'LineWidth',2);
hold off


