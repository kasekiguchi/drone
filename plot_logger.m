% Figureを作成して保存する
clear T
T = gui.logger.Data.t(1:gui.logger.k);
% mkdir('test')
% for i = 1:10
%     % Figureを作成
%     x = linspace(0, 2*pi, 100);
%     y = sin(x);
%     figure;
%     plot(x, y);
%     title(['fight_data', num2str(i)]);
%     xlabel('X軸');
%     ylabel('Y軸');
% end
%% 位置状態
figure(1)
hold on
for plot_i = 1:gui.logger.k
    flight_path(plot_i,1) = gui.logger.Data.agent.sensor.result{1,plot_i}.state.p(1);
    flight_path(plot_i,2) = gui.logger.Data.agent.sensor.result{1,plot_i}.state.p(2);
    flight_path(plot_i,3) = gui.logger.Data.agent.sensor.result{1,plot_i}.state.p(3);
    flight_reference(plot_i,1) = gui.logger.Data.agent.reference.result{1,plot_i}.state.p(1);
    flight_reference(plot_i,2) = gui.logger.Data.agent.reference.result{1,plot_i}.state.p(2);
    flight_reference(plot_i,3) = gui.logger.Data.agent.reference.result{1,plot_i}.state.p(3);
end
plot(T,flight_path,'LineWidth',1)
plot(T,flight_reference,'LineWidth',1)
xlabel('Time [s]','FontSize',16)
ylabel('Position [m]','FontSize',16)
name_class = ["fp.x";"fp.y";"fp.z";"fr.x";"fr.y";"fr.z"];
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off
%% 軌跡
figure(2)
hold on
for plot_i = 1:gui.logger.k
    fp(plot_i,1) = gui.logger.Data.agent.sensor.result{1,plot_i}.state.p(1);
    fp(plot_i,2) = gui.logger.Data.agent.sensor.result{1,plot_i}.state.p(2);
    fr(plot_i,1) = gui.logger.Data.agent.reference.result{1,plot_i}.state.p(1);
    fr(plot_i,2) = gui.logger.Data.agent.reference.result{1,plot_i}.state.p(2);
end
plot(fp(:,1),fp(:,2))
plot(fr(:,1),fr(:,2))
xlabel('X [m]','FontSize',16)
ylabel('Y [m]','FontSize',16)
name_class = ["estimater";"reference"];
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off
%% 入力
figure(3)
hold on
for plot_i = 1:gui.logger.k
    flight_input = cell2mat(gui.logger.Data.agent.input);
end
plot(T,flight_input)
xlabel('Time [s]','FontSize',16)
ylabel('input [N]','FontSize',16)
name_class = ["moter1";"moter2";"moter3";"moter4"];
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off
%% 入力2
figure(4)
hold on
for plot_i = 1:gui.logger.k
    inner_input(plot_i,1) = cell2mat(gui.logger.Data.agent.inner_input{1,plot_i});
    flight_inner_input = cell2mat(gui.logger.Data.agent.inner_input);
end
plot(T,flight_inner_input)
xlabel('Time [s]','FontSize',16)
ylabel('inner_input [N]','FontSize',16)
name_class = ["moter1";"moter2";"moter3";"moter4"];
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off
%% 誤差
figure(5)
hold on
for plot_i = 1:gui.logger.k
    flight_error(plot_i,1) = flight_reference(plot_i,1)- flight_path(plot_i,1);
    flight_error(plot_i,2) = flight_reference(plot_i,2)- flight_path(plot_i,2);
    flight_error(plot_i,3) = flight_reference(plot_i,3)- flight_path(plot_i,3);
end
plot(T,flight_error,'LineWidth',1)
xlabel('Time [s]','FontSize',16)
ylabel('Error [m]','FontSize',16)
name_class = ["error.x";"error.y";"error.z"];
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off
%% 

% すべてのFigureを指定のフォルダに一括保存
% savepath = 'test'; % 保存するディレクトリを指定
% for i = 1:10
%     % FigureをPNGフォーマットで保存
%     saveas(i, fullfile(savepath, ['sample_plot_', num2str(i), '.png']));
% end

% すべてのFigureを閉じる
% close all;