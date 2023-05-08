% clf('reset')
figNum = 0;
figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.state(:, 2), '-', 'LineWidth', 1.75);
    hold on
    plot(data.state(:, 1), data.state(:, 3), '-', 'LineWidth', 1.75);
    grid on; axis equal; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
%     xlim([0, 7]);
    FigName = 'State';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off

figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.state(:, 7), '-', 'LineWidth', 1.75);
    hold on
    plot(data.state(:, 1), data.state(:, 8), '-', 'LineWidth', 1.75);
    grid on; axis equal; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$X_{\rm ref}, Y_{\rm ref}$$ [m]', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
%     xlim([0, 7]);
    FigName = 'Reference';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off
    
figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.state(:, 2), '-', 'LineWidth', 1.75);
    hold on
    plot(data.state(:, 1), data.state(:, 3), '-', 'LineWidth', 1.75);
    hold on;
    plot(data.state(:, 1), data.state(:, 7), '-', 'LineWidth', 1.75);
    hold on
    plot(data.state(:, 1), data.state(:, 8), '-', 'LineWidth', 1.75);
    grid on; axis equal; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$X, Y, X_{\rm ref},Y_{\rm ref}$$ [m]', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
%     xlim([0, 7]);
    FigName = 'State and reference';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off
   
% fig4 = figure(4);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% % hold on
% % patch([1 5 5 1],[-0.5 -0.5 1 1],'black','Facealpha',0.2)
% hold on
% plot(data.state(:,10),data.state(:,11),'-','LineWidth',4);
% hold on
% plot(data.state(:,2),data.state(:,3),'-','LineWidth',1.75);
%     % plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
% hold off;
% grid on; axis equal; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$Y$$ [m]', 'Interpreter', 'latex')
% xlabel('$$X$$ [m]', 'Interpreter', 'latex')
% xlim([0, 7]);
% legend('Shadow','Target trajectory', 'MCMPC')
% hold off

% fig111=figure(111);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% hold on;
% for i=1:Particle_num
%     plot(data.path{100}(1,:,i),data.path{100}(2,:,i),'-','LineWidth',1.75);
%     % plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
%     hold on;
% end
% grid on; axis equal; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$Y$$ [m]', 'Interpreter', 'latex')
% xlabel('$$X$$ [m]', 'Interpreter', 'latex')
% xlim([0, 7]);
% hold off


figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.state(:, 4), '-', 'LineWidth', 1.75);
    hold on
    plot(data.state(:, 1), data.state(:, 5), '-', 'LineWidth', 1.75);
    grid on; axis auto; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$Velocity$$ [m/s]', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
%     xlim([0, 20]);
%     ylim([-1, 1]);
    legend('$$V_x$$', '$$V_y$$', 'Interpreter', 'latex')
    FigName = 'Input';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off

% fig6 = figure(6);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% hold on;
% plot(data.state(:,1),data.state(:,10),'--','LineWidth',3);
% hold on
% plot(data.state(:,1),data.state(:,11),'--','LineWidth',3);
% hold on
% plot(data.state(:,1),data.state(:,2),'-','LineWidth',1.75);
% hold on
% plot(data.state(:,1),data.state(:,3),'-','LineWidth',1.75);
% hold on
% % plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
% grid on; axis equal; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
% xlabel('$$Time$$ [s]', 'Interpreter', 'latex')
% xlim([0, 20]);
% legend('$$X_{ref}$$', '$$Y_{ref}$$', '$$X$$', '$$Y$$', 'Interpreter', 'latex','Location','northwest')
% hold off

figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.bestcost(:), '-', 'LineWidth', 1.75);
    hold on
    grid on; axis equal; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$Eval$$ [-]', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
%     xlim([0, 20]);
%     ylim([-8, 8]);
    FigName = 'Bset eval';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off

% eref = repmat(75, idx, 1);
% 
% fig8 = figure(8);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% hold on;
% plot(data.state(:,1),eref,'-','LineWidth',3);
% hold on
% plot(data.state(:,1),data.state(:,6),'-','LineWidth',1.75);
% grid on; axis square; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$Charge$$ [J]', 'Interpreter', 'latex')
% xlabel('$$Time$$ [s]', 'Interpreter', 'latex')
% xlim([0, 20]);
% ylim([50, 100]);
% legend('$$E_t$$', '$$E$$','Interpreter', 'latex')
% hold off

% uNmax = repmat(umax, idx, 1);
% uSoft = repmat(4, idx, 1);
% fig9 = figure(9);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% hold on;
% plot(data.state(:,1),uNmax,'-','LineWidth',3,'Color','black');
% hold on
% % plot(data.state(:,1),uSoft,'--','LineWidth',3,'Color','red');
% % hold on
% plot(data.state(:,1),data.state(:,9),'-','LineWidth',1.75);
% hold on
% % plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
% grid on; axis equal; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$Force$$ [N]', 'Interpreter', 'latex')
% xlabel('$$Time$$ [s]', 'Interpreter', 'latex')
% xlim([0, 20]);
% ylim([0, 10]);
% legend('$$\|u\|_{max}$$', '$$\|u\|$$','Interpreter', 'latex')
% hold off


% remove_vi = repmat(1000, idx, 1);
% fig10 = figure(10);
% fig = gcf;
% fig.Color= [1., 1., 1.];
% hold on;
% plot(data.state(:,1),remove_vi,'--','LineWidth',3,'Color','black');
% hold on
% plot(data.state(:,1),data.remove_data(:),'-','LineWidth',1.75);
% hold on
% % plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
% grid on; axis auto; hold off; box on;
% set(gca,'FontSize',16);
% ylabel('$$Count$$', 'Interpreter', 'latex')
% xlabel('$$Time$$ [s]', 'Interpreter', 'latex')
% xlim([0, 20]);
% ylim([0, Particle_num+200]);
% legend('$$Sigma~Reset$$','$$Count$$','Interpreter', 'latex')
% hold off

figNum =  figNum + 1;
fig(figNum) = figure(figNum);
    h = gcf;
    h.Color = [1., 1., 1.];
    hold on;
    plot(data.state(:, 1), data.sigmax(:), '-', 'LineWidth', 4, 'Color', 'blue');
    hold on
    plot(data.state(:, 1), data.sigmay(:), '-', 'LineWidth', 1.75);
    hold on
    grid on; axis auto; hold off; box on;
    set(gca, 'FontSize', 16);
    ylabel('$$Variance$$', 'Interpreter', 'latex')
    xlabel('$$t$$ [s]', 'Interpreter', 'latex')
    xlim([0, 20]);
%     ylim([0, 2]);
    legend('$$Sigma_X$$', '$$Sigma_Y$$', 'Interpreter', 'latex')
    FigName = 'Variance';
    dispFigName(figNum, 1) = {char(strcat('Fig.', num2str(figNum), '_', FigName))};
    disp(char(dispFigName(figNum, 1)))
    hold off

%% 画像保存
cd(strcat(Outputdir, '/fig'));
arrayfun(@(x) saveas(fig(x), strcat(char(dispFigName(x, 1)), '.jpg')), 1:figNum);
% saveas(fig,'fig1.jpg');
% saveas(fig,'fig2.jpg');
% saveas(fig,'fig3.jpg');
% saveas(fig4,'fig4.jpg');
% saveas(fig5,'fig5.jpg');
% saveas(fig6,'fig6.jpg');
% saveas(fig7,'fig7.jpg');
% saveas(fig8,'fig8.jpg');
% saveas(fig9,'fig9.jpg');
% saveas(fig10,'fig10.jpg');
% saveas(fig11,'fig11.jpg');
% saveas(fig111,'fig111.jpg');
cd(fileparts(tmp.Filename))