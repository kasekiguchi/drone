function [] = Graphplot(app)
    opengl software
    
    %フライトフェーズ-------------
    % 115 : stop
    %  97 : arming
    % 116 : take off
    % 102 : flight
    % 108 : landing
    %-----------------------------

    %------------------------------------------------------------------------------
     choice = 0; % 0:x-yグラフ，1:x-y-zグラフ, 2:計算コスト(シミュレーションのみ)
     error = 0; %1:目標値との誤差のグラフを表示
    %------------------------------------------------------------------------------
    %% データのインポート
    
    for i = 1:find(app.logger.Data.t,1,'last')
        data.t(1,i) = app.logger.Data.t(i,1);                                      %時間t_estimator
        data.phase(1,i) = app.logger.Data.phase(i,1);                              %フェーズ
        data.p(:,i) = app.logger.Data.agent.estimator.result{i}.state.p(:,1);      %位置p_estimator
        data.pr(:,i) = app.logger.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
        data.q(:,i) = app.logger.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角_estimator
        data.v(:,i) = app.logger.Data.agent.estimator.result{i}.state.v(:,1);      %速度_estimator
        data.vr(:,i) = app.logger.Data.agent.reference.result{i}.state.v(:,1);     %速度_reference
        data.w(:,i) = app.logger.Data.agent.estimator.result{i}.state.w(:,1);      %角速度_estimat
        data.u(:,i) = app.logger.Data.agent.input{i}(:,1);                         %入力
        data.error(:,i) = data.pr(:,i) - data.p(:,i);                              %error
        % data.te(:,i) = app.agent.controller.result.t(1,i);  %計算時間、シミュレーションのみ

        % data.pp(:,i) = app.logger.Data.agent.plant.result{i}.state.p(:,1);         %位置p_plant
        % data.qp(:,i) = app.logger.Data.agent.plant.result{i}.state.q(:,1);         %姿勢角_plant
        % data.vp(:,i) = app.logger.Data.agent.plant.result{i}.state.v(:,1);         %速度_plant
        % data.wp(:,i) = app.logger.Data.agent.plant.result{i}.state.w(:,1);         %角速度_plant
    end
  
    % for i = 1:size(data.u,2) %GUIの入力を各プロペラの推力に分解
    %     data.u(:,i) = T2T(data.u(1,i),data.u(2,i),data.u(3,i),data.u(4,i));
    % end
    
    %% いっぺんに出力
    
    newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880]; %色の設定
    
    columnomber = 3; %凡例の並べ方調整
    Fsize.lgd = 12; %凡例の大きさ調整
    size = figure;
    size.WindowState = 'maximized'; %表示するグラフを最大化
    num = 3;
    colororder(newcolors)
    
    subplot(2, num, 1);
    % colororder(newcolors)
    plot(data.t, data.p(:,:),'LineWidth',1.2);
    xlabel('Time [s]');
    ylabel('p');
    hold on
    grid on
    plot(data.t,data.pr(:,:),'LineWidth',1.2,'LineStyle','--');
    % plot(data.t,data.pp(:,:),'LineWidth',1.2,'LineStyle','-.');
    if ismember(116, data.phase)
        Square_coloring2(data.t([find(data.phase == 116,1,'first'),find(data.phase == 116,1,'last')]),[1.0 1.0 0.9]);
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]);
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    elseif ismember(102, data.phase)
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]); 
    elseif ismember(108, data.phase)
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    end
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax = gca;
    hold off
    title('Position p of agent1');
    
    % 姿勢角
    subplot(2, num, 2);
    plot(data.t, data.q(:,:),'LineWidth',1.2);
    % plot(data.t, data.qp(:,:),'LineWidth',1.2,'LineStyle','-.');
    xlabel('Time [s]');
    ylabel('q');
    hold on
    grid on
    if ismember(116, data.phase)
        Square_coloring2(data.t([find(data.phase == 116,1,'first'),find(data.phase == 116,1,'last')]),[1.0 1.0 0.9]);
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]);
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    elseif ismember(102, data.phase)
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]); 
    elseif ismember(108, data.phase)
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    end
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$\phi_e$','$\theta_e$','$\psi_e$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(2) = gca;
    hold off
    title('Attitude q of agent1');
    
    % 速度
    subplot(2, num, 3);
    plot(data.t, data.v(:,:),'LineWidth',1.2);
    hold on
    plot(data.t, data.vr(:,:),'LineWidth',1.2,'LineStyle','-.');
    xlabel('Time [s]');
    ylabel('v');
    grid on
    if ismember(116, data.phase)
        Square_coloring2(data.t([find(data.phase == 116,1,'first'),find(data.phase == 116,1,'last')]),[1.0 1.0 0.9]);
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]);
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    elseif ismember(102, data.phase)
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]); 
    elseif ismember(108, data.phase)
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    end
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$v_{xe}$','$v_{ye}$','$v_{ze}$','$v_{xr}$','$v_{yr}$','$v_{zr}$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(3) = gca;
    hold off
    title('Velocity v of agent1');
    
    % 角速度
    subplot(2, num, 4);
    plot(data.t, data.w(:,:),'LineWidth',1.2);
    hold on
    % plot(data.t, data.wp(:,:),'LineWidth',1.2,'LineStyle','-.');
    xlabel('Time [s]');
    ylabel('w');
    grid on
    if ismember(116, data.phase)
        Square_coloring2(data.t([find(data.phase == 116,1,'first'),find(data.phase == 116,1,'last')]),[1.0 1.0 0.9]);
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]);
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    elseif ismember(102, data.phase)
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]); 
    elseif ismember(108, data.phase)
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    end
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'$\omega_{1 e}$','$\omega_{2 e}$','$\omega_{3 e}$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    ax(4) = gca;
    hold off
    title('Angular velocity w of agent1');
    
    % 入力(4入力)
    subplot(2,num,5);
    plot(data.t,data.u(:,:),'LineWidth',1.2);
    xlabel('Time [s]');
    ylabel('u');
    grid on
    if ismember(116, data.phase)
        Square_coloring2(data.t([find(data.phase == 116,1,'first'),find(data.phase == 116,1,'last')]),[1.0 1.0 0.9]);
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]);
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    elseif ismember(102, data.phase)
        Square_coloring2(data.t([find(data.phase == 102,1,'first'),find(data.phase == 102,1,'last')]),[0.9 1.0 1.0]); 
    elseif ismember(108, data.phase)
        Square_coloring2(data.t([find(data.phase == 108,1,'first'),find(data.phase == 108,1,'last')]),[1.0 0.9 1.0]);
    end
    lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = columnomber;
    xlim([data.t(1) data.t(end)])
    ax(5) = gca;
    title('Input u of agent1');

    %入力(総推力)
    % subplot(2,num,6);
    % plot(data.t,data.u2(:,:),'LineWidth',1.2);
    % xlabel('Time [s]');
    % ylabel('u');
    % grid on
    % lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
    % lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    % lgd.NumColumns = columnomber;
    % xlim([data.t(1) data.t(end)])
    % ax(5) = gca;
    % title('Thrust torque u of agent1');
    
    % 軌道(2次元，3次元)
    subplot(2,num,6);

    if choice == 0
        plot(data.p(1,:),data.p(2,:),'LineWidth',1.2);
        daspect([1,1,1])
        grid on
        xlabel('Position x [m]');
        ylabel('Position y [m]');
        hold on
        ax(6) = gca;
    %     plot(data.pr(1,:),data.pr(2,:));
    %     plot(0,1,'o','MarkerFaceColor','red','Color','red');
    %     plot(1,1,'o','MarkerFaceColor','red','Color','red');
    %     plot(1,-1,'o','MarkerFaceColor','red','Color','red');
    %     legend('Estimated trajectory','Target position')
    %     xlim([-0.5 0.5])
    %     ylim([-0.5 0.5])
        hold off
    elseif choice == 1
        plot3(data.p(1,:),data.p(2,:),data.p(3,:),'LineWidth',1.2);
        hold on
        grid on
        plot3(data.pr(1,:),data.pr(2,:),data.pr(3,:),'LineWidth',1.2, 'LineStyle','--')
        xlabel('x');
        ylabel('y');
        zlabel('z');
        ax(6) = gca;
        hold off
    else
        %シミュレーションのみ-------------------
        plot(data.t,data.te,'LineWidth',1.2)
        xlabel('Time [s]');
        ylabel('CalT time [s]');
        hold on
        grid on
        yline(0.025,'Color','red','LineWidth',1.2)
        xlim([data.t(1) data.t(end)])
        legend('計算時間', '制御周期')
        ax(6) = gca;
        hold off
        title('CalT time')
        %---------------------------------------
    end

    %error
    if error == 1
        figure(7)
        plot(data.t,data.error(:,:),'LineWidth',1.2)
        xlabel('Time [s]');
        ylabel('Error');
        grid on
        lgdtmp = {'error.x','error.y','error.z'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        xlim([data.t(1) data.t(end)])
        ax(7) = gca;
        title('Error of agent1','FontSize',12);
    end
    
    fontSize = 14; %軸の文字の大きさの設定
    set(ax,'FontSize',fontSize);
end

