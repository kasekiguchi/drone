%% plot用
clear T
name_class = ["obstacle";"reference";"estimator";"target orbit"];%名前
T = logger.Data.t(1:logger.k);%時間
x_wide = 0.1;%壁の厚さ


figure(6)
hold on

for plot_i = 1:logger.k%変数を格納
    distance_sensor = logger.Data.agent.sensor.result{1,plot_i}.state.p(3) - logger.Data.agent.sensor.result{1,plot_i}.posion(3);
    sensor_T265(plot_i,1) = logger.Data.agent.sensor.result{1,plot_i}.posion(1);
    sensor_T265(plot_i,2) = logger.Data.agent.sensor.result{1,plot_i}.posion(2);
%     sensor_T265(plot_i,3) = logger.Data.agent.sensor.result{1,plot_i}.posion(3) + distance_sensor; %T265とprimeの差を印加
    sensor_T265(plot_i,3) = logger.Data.agent.sensor.result{1,plot_i}.posion(3) + 0.2; %T265とマーカーの位置ずれ13cm
    prime_sensor(plot_i,1:3) = logger.Data.agent.sensor.result{1,plot_i}.state.p;
%     if obs_pos(2).p(2)>logger.Data.agent.estimator.result{1, plot_i}.state.p(2)&&logger.Data.agent.estimator.result{1, plot_i}.state.p(2)<obs_pos(3).p(2)
%         distance_wall(plot_i,1) = norm(obs_x-logger.Data.agent.estimator.result{1, plot_i}.state.p(1));%壁との垂直の距離
%     else
%         distance_a(1) = norm(obs_pos(2).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点aとの距離
%         distance_a(2) = norm(obs_pos(3).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点bとの距離
%         distance_wall(plot_i,1) = min(distance_a);%a or b　近いほうを選出
%     end
%     distance_sensor(plot_i,1) = logger.Data.agent.sensor.result{1, plot_i}.distance.teraranger;%テラレンジャーの距離
end

plot(T,sensor_T265,'LineWidth',1)
plot(T,prime_sensor,'LineWidth',1)

txt = {''};

if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(logger.Data.phase == 97, 1), find(logger.Data.phase == 116, 1, 'last')])); % take off phase
    %                        txt = {txt{:},'{\color{yellow}■} :Take off phase'};
    txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
end

if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0]); % flight phase
    txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
end

if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0 0.9 1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
end

xlabel('Time [s]','FontSize',16);
ylabel('Position [m]','FontSize',16);
name_class = ["t265.x";"t265.y";"t265.z";"prime.x";"prime.y";"prime.z"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off