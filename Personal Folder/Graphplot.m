function [] = Graphplot(app)
    opengl software
    
    %フライトフェーズ-------------
    % 115 : stop
    %  97 : arming
    % 116 : take off
    % 102 : flight
    % 108 : landing
    %-----------------------------

    %% データのインポート

    for i = find(app.logger.Data.phase == 102,1,'first'):find(app.logger.Data.phase == 102,1,'last')
        data.t(1,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.t(i,1);                                      %時間t
        data.phase(1,i) = app.logger.Data.phase(i,1);                                                                             %フェーズ
        data.p(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
        data.pr(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
        data.q(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
        data.v(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.estimator.result{i}.state.v(:,1);      %速度
        data.vr(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.reference.result{i}.state.v(:,1);     %速度_reference
        data.w(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
        data.u(:,i-find(app.logger.Data.phase == 102,1,'first')+1) = app.logger.Data.agent.input{i}(:,1);                         %入力
    end
    
    %% いっぺんに出力
    
    newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880]; %色の設定
    
    columnomber = 3; %凡例の並べ方調整
    Fsize.lgd = 12; %凡例の大きさ調整
    size = figure;
    size.WindowState = 'maximized'; %表示するグラフを最大化
    row = 3;
    line = 3;
    colororder(newcolors)
    
    % 位置
    subplot(row, line, 1);
    colororder(newcolors)
    plot(data.t, data.p(:,:),'LineWidth',1.2);
    xlabel('Time [s]');
    ylabel('p');
    hold on
    grid on
    plot(data.t,data.pr(:,:),'LineWidth',1.2,'LineStyle','--');
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax = gca;
    hold off
    title('Position p of agent1');
    
    % 姿勢角
    subplot(row, line, 2);
    plot(data.t, data.q(:,:),'LineWidth',1.2);
    xlabel('Time [s]');
    ylabel('q');
    hold on
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$\phi_e$','$\theta_e$','$\psi_e$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(2) = gca;
    hold off
    title('Attitude q of agent1');
    
    % 速度
    subplot(row, line, 3);
    plot(data.t, data.v(:,:),'LineWidth',1.2);
    hold on
    plot(data.t, data.vr(:,:),'LineWidth',1.2,'LineStyle','-.');
    xlabel('Time [s]');
    ylabel('v');
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$v_{xe}$','$v_{ye}$','$v_{ze}$','$v_{xr}$','$v_{yr}$','$v_{zr}$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(3) = gca;
    hold off
    title('Velocity v of agent1');
    
    % 角速度
    subplot(row, line, 4);
    plot(data.t, data.w(:,:),'LineWidth',1.2);
    hold on
    xlabel('Time [s]');
    ylabel('w');
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$\omega_{1 e}$','$\omega_{2 e}$','$\omega_{3 e}$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(4) = gca;
    hold off
    title('Angular velocity w of agent1');

    % 総入力
    subplot(row,line,5);
    plot(data.t,data.u(1,:),'LineWidth',1)
    xlabel('Time [s]');
    ylabel('Input_{thrust}');
    hold on
    grid on
    yline(0.5884*9.81,'Color','red','LineWidth',1.2)
    lgdtmp = {'$thrust$','$thrust_theory$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(5) = gca;
    title('Input u of agent1','FontSize',12);

    % 各トルク
    subplot(row,line,6);
    plot(data.t,data.u(2:4,:),'LineWidth',1)
    xlabel('Time [s]');
    ylabel('Input_{torque}');
    hold on
    grid on
    lgdtmp = {'$torque_{roll}$','$torque_{pitch}$','$torque_{yaw}$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(6) = gca;
    title('Input torque of agent1','FontSize',12);

    % % x-y
    % subplot(row,line,7);
    % plot(data.p(1,:),data.p(2,:),'LineWidth',1); hold on; plot(data.pr(1,:), data.pr(2,:), '--'); hold off;
    % xlabel('x');
    % ylabel('y');
    % hold on
    % grid on
    % lgdtmp = {'$Estimator$','$Reference$'};
    % lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    % lgd.NumColumns = columnomber;
    % ax(6) = gca;
    % title('x-y of agent1','FontSize',12);
    % 
    % % x-y-z
    % subplot(row,line,8);
    % plot3(data.p(1,:), data.p(2,:), data.p(3,:),'LineWidth',1); hold on; plot3(data.pr(1,:), data.pr(2,:), data.pr(3,:), '--'); hold off;
    % xlabel('x');
    % ylabel('y');
    % zlabel('z');
    % hold on
    % grid on
    % lgdtmp = {'$Estimator$','$Reference$'};
    % lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    % lgd.NumColumns = columnomber;
    % ax(6) = gca;
    % title('x-y-z of agent1','FontSize',12);
    
    fontSize = 14; %軸の文字の大きさの設定
    set(ax,'FontSize',fontSize);

end

