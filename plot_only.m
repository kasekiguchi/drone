%% plot用
figure(6)
hold on
for plot_i = 1:logger.k%変数を格納
    if obs_pos(2).p(2)>logger.Data.agent.estimator.result{1, plot_i}.state.p(2)&&logger.Data.agent.estimator.result{1, plot_i}.state.p(2)<obs_pos(3).p(2)
        distance_wall(plot_i,1) = norm(obs_x-logger.Data.agent.estimator.result{1, plot_i}.state.p(1));%壁との垂直の距離
    else
        distance_a(1) = norm(obs_pos(2).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点aとの距離
        distance_a(2) = norm(obs_pos(3).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点bとの距離
        distance_wall(plot_i,1) = min(distance_a);%a or b　近いほうを選出
    end
    distance_sensor(plot_i,1) = logger.Data.agent.sensor.result{1, plot_i}.distance.teraranger;%テラレンジャーの距離
end

plot(T,distance_wall,'LineWidth',1)
plot(T,distance_sensor,'LineWidth',1)

xlabel('time [s]')
ylabel('distance [m]')
name_class = ["distance wall";"teraranger"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off