function plot_figure(data,Xo,Te,n,m)
x = 1;
y = n/2+1;
xr = n+m+1;
yr = 3*n/2 + m + 1;
vx = x+1;
vy = y+1;
%% PLOT
figNum = 0;
% X-Y平面
figNum = figNum + 1;
figure(figNum)
figName = 'Time_change_of_position';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,x),data.state(:,y),'-','LineWidth',1.75);
plot(Xo(1), Xo(2), '.', 'MarkerSize', 50);
grid on; axis equal; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$Y$$ [m]', 'Interpreter', 'latex')
xlabel('$$X$$ [m]', 'Interpreter', 'latex')
lgd = legend("trajectory");
lgd.NumColumns = 2;
xlim([min(data.t), max(data.t)]);
%% 時間に対する状態変化
figNum = figNum + 1;
figure(figNum)
figName = 'Trajectoryt&Reference';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.t,data.state(:,x),'-','LineWidth',1.75);
plot(data.t,data.state(:,y),'-','LineWidth',1.75);
plot(data.t,data.state(:,xr),'--','LineWidth',1.75);
plot(data.t,data.state(:,yr),'--','LineWidth',1.75);
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
plot(data.t,data.state(:,vx),'-','LineWidth',1.75);
plot(data.t,data.state(:,vy),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$U_1, U_2$$ [m/s]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
lgd = legend('$$v_x$$','$$v_y$$', 'Interpreter', 'latex','Location','southoutside');
lgd.NumColumns = 2;
% %save_n_move(figNum,figName,folderName)

% 時間に対する評価値変化
figNum = figNum + 1;
figure(figNum)
figName = 'Evaluation_value';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.t,data.state(:,end),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$J$$ [-]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
legend('Evaluation value','Location','southoutside')
%save_n_move(figNum,figName,folderName)

end