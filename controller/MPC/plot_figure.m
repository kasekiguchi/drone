function plot_figure(data,Xo,Te)
%% PLOT
figNum = 0;
% X-Y平面
figNum = figNum + 1;
figure(figNum)
figName = 'Time_change_of_position';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
% plot(data.state(:,2),data.state(:,3),'-','LineWidth',1.75);
% plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,2),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,3),'-','LineWidth',1.75);
% plot(data.state(:,1),data.state(:,6),'-','LineWidth',1.75);
% plot(data.state(:,1),data.state(:,7),'-','LineWidth',1.75);
grid on; axis equal; hold off; box on;
set(gca,'FontSize',16);
% ylabel('$$Y$$ [m]', 'Interpreter', 'latex')
% xlabel('$$X$$ [m]', 'Interpreter', 'latex')
ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
lgd = legend("X", "Y");
lgd.NumColumns = 2;
xlim([min(data.state(:,1)), max(data.state(:,1))]);
%save_n_move(figNum,figName,folderName)
%% 時間に対する状態変化
figNum = figNum + 1;
figure(figNum)
figName = 'Trajectoryt&Reference';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,2),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,3),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,6),'--','LineWidth',1.75);
plot(data.state(:,1),data.state(:,7),'--','LineWidth',1.75);
plot(Xo(1), Xo(2), '.', 'MarkerSize', 50);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
lgd = legend('$$x$$','$$y$$','$$x_{ref}$$','$$y_{ref}$$', 'Interpreter', 'latex','Location','southoutside');
lgd.NumColumns = 4;% 時間に対する入力変化
%save_n_move(figNum,figName,folderName)

figNum = figNum + 1;
figure(figNum)
figName = 'Velocity';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,4),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,5),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$U_1, U_2$$ [m/s]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
lgd = legend('$$v_x$$','$$v_y$$', 'Interpreter', 'latex','Location','southoutside');
lgd.NumColumns = 2;
%save_n_move(figNum,figName,folderName)

% 時間に対する評価値変化
figNum = figNum + 1;
figure(figNum)
figName = 'Evaluation_value';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,10),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$J$$ [-]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
legend('Evaluation value','Location','southoutside')
%save_n_move(figNum,figName,folderName)

end