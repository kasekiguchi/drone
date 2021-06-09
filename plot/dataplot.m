function dataplot(logger)
%% 行列生成
    t = logger.Data.t;
    x = zeros(4,numel(logger.Data.t));
    y = zeros(4,numel(logger.Data.t));
for n = 1:numel(logger.Data.t)
    x(1,n) = logger.Data.agent{n,3,1}.state.p(1,1);
    x(2,n) = logger.Data.agent{n,3,2}.state.p(1,1);
    x(3,n) = logger.Data.agent{n,3,3}.state.p(1,1);
    x(4,n) = logger.Data.agent{n,3,4}.state.p(1,1);
    y(1,n) = logger.Data.agent{n,3,1}.state.p(2,1);
    y(2,n) = logger.Data.agent{n,3,2}.state.p(2,1);
    y(3,n) = logger.Data.agent{n,3,3}.state.p(2,1);
    y(4,n) = logger.Data.agent{n,3,4}.state.p(2,1);
end
    %-------------------エージェントのx座標------------------------
    figure(1)
    figure1=figure(1);
    axes1=axes('Parent',figure1);
    hold on
    fig1 = plot(t,x(1,1:numel(logger.Data.t)),'r-');
    fig2 = plot(t,x(2,1:numel(logger.Data.t)),'g-');
    fig3 = plot(t,x(3,1:numel(logger.Data.t)),'b-');
    fig4 = plot(t,x(4,1:numel(logger.Data.t)),'c-');
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes1,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([0,logger.Data.t(end)+1]);
    ylim([min(x(:,1))-1,max(x(:,1))+1]);
    xlabel('Time {\it t} [s]');
    ylabel('Position {\it x} [m]');
    axis square;
        legend('Agent1','Agent2','Agent3','Agent4');
        
        
%%        
%-------------------エージェントのy座標------------------------
    figure(2)
    figure2=figure(2);
    axes2=axes('Parent',figure2);
    hold on
    fig1 = plot(t,y(1,1:numel(logger.Data.t)),'r-');
    fig2 = plot(t,y(2,1:numel(logger.Data.t)),'g-');
    fig3 = plot(t,y(3,1:numel(logger.Data.t)),'b-');
    fig4 = plot(t,y(4,1:numel(logger.Data.t)),'c-');
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes2,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([0,logger.Data.t(end)+1]);
    ylim([min(y(:,1))-1,max(y(:,1))+1]);
    xlabel('Time {\it t} [s]');
    ylabel('Position {\it y} [m]');
    axis square;
    legend('Agent1','Agent2','Agent3','Agent4');
    
%%  
    %-------------------エージェント初期位置------------------------
    figure(3)
    figure3=figure(3);
    axes3=axes('Parent',figure3);
    hold on
    fig1 = plot(x(1,1),y(1,1),'r.','MarkerSize',20);
    fig2 = plot(x(2,1),y(2,1),'g.','MarkerSize',20);
    fig3 = plot(x(3,1),y(3,1),'b.','MarkerSize',20);
    fig4 = plot(x(4,1),y(4,1),'c.','MarkerSize',20);
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes3,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([min(x(:,1))-1,max(x(:,1))+1]);
    ylim([min(y(:,1))-1,max(y(:,1))+1]);
    xlabel('Position {\it x} [m]');
    ylabel('Position {\it y} [m]');
    axis square;
        legend('Agent1','Agent2','Agent3','Agent4');
end 




