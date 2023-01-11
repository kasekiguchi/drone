a = length(logger.Data.agent.estimator.result);
x = [];
y = [];
for i=1:a
    x(i,1)=logger.Data.agent.estimator.result{1,i}.state.p(1);
    y(i,1)=logger.Data.agent.estimator.result{1,i}.state.p(2);
end
hold on
grid on
plot(x,y)
% xticks(0:0.3:6)
% yticks(0:0.3:6)
xlim([0 7]);
ylim([-1 2]);
xlabel("x [m]");
ylabel("y [m]");
hold off