function dataplot(logger,N)
%% 行列生成
    t = logger.Data.t;
    x = zeros(4,numel(logger.Data.t));
    y = zeros(4,numel(logger.Data.t));
for n = 1:numel(logger.Data.t)
    for i=1:N
    x(i,n) = logger.Data.agent{n,3,i}.state.p(1,1);
    y(i,n) = logger.Data.agent{n,3,i}.state.p(2,1);
    end
end
    %-------------------エージェントのx座標------------------------
    figure(1)
    figure1=figure(1);
    axes1=axes('Parent',figure1);
    hold on
    for i=1:N
%         figi = plot(t,x(i,1:numel(logger.Data.t)));
    if i==1 figi = plot(t,x(i,1:numel(logger.Data.t)),'r-');end
    if i==2 figi = plot(t,x(i,1:numel(logger.Data.t)),'g-');end
    if i==3 figi = plot(t,x(i,1:numel(logger.Data.t)),'b-');end
    if i==4 figi = plot(t,x(i,1:numel(logger.Data.t)),'c-');end
    end
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    for i=1:N
    set(figi,'LineWidth',1);
    end
    set(axes1,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([0,logger.Data.t(end)+1]);
    xlabel('Time {\it t} [s]');
    ylabel('Position {\it x} [m]');
    axis square;
    if N==3
        legend('Agent1','Agent2','Agent3');
    end
    if N==4
        legend('Agent1','Agent2','Agent3','Agent4');
    end        
        
%%        
%-------------------エージェントのy座標------------------------
    figure(2)
    figure2=figure(2);
    axes2=axes('Parent',figure2);
    hold on
    for i=1:N
%         figi = plot(t,y(i,1:numel(logger.Data.t)));
    if i==1 figi = plot(t,y(i,1:numel(logger.Data.t)),'r-');end
    if i==2 figi = plot(t,y(i,1:numel(logger.Data.t)),'g-');end
    if i==3 figi = plot(t,y(i,1:numel(logger.Data.t)),'b-');end
    if i==4 figi = plot(t,y(i,1:numel(logger.Data.t)),'c-');end
    end
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    for i=1:N
    set(figi,'LineWidth',1);
    end
    set(axes2,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([0,logger.Data.t(end)+1]);
    xlabel('Time {\it t} [s]');
    ylabel('Position {\it y} [m]');
    axis square;
    if N==3
        legend('Agent1','Agent2','Agent3');
    end
    if N==4
        legend('Agent1','Agent2','Agent3','Agent4');
    end
    
%%  
    %-------------------エージェント初期位置------------------------
    figure(3)
    figure3=figure(3);
    axes3=axes('Parent',figure3);
    hold on
    for i=1:N
    if i==1 figi = plot(x(1,1),y(1,1),'r.','MarkerSize',20);end
    if i==2 figi = plot(x(2,1),y(2,1),'g.','MarkerSize',20);end
    if i==3 figi = plot(x(3,1),y(3,1),'b.','MarkerSize',20);end
    if i==4 figi = plot(x(4,1),y(4,1),'c.','MarkerSize',20);end
    end
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    for i=1:N
    set(figi,'LineWidth',1);
    end
    set(axes3,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([min(x(:,1))-1,max(x(:,1))+1]);
    ylim([min(y(:,1))-1,max(y(:,1))+1]);
    xlabel('Position {\it x} [m]');
    ylabel('Position {\it y} [m]');
    axis square;
    if N==3
        legend('Agent1','Agent2','Agent3');
    end
    if N==4
        legend('Agent1','Agent2','Agent3','Agent4');
    end
        
    %% 動画作成スレッド

    figure(9)

    % Animation Loop
    t = 1;
    xave = (x(1,1)+x(2,1)+x(3,1)+x(4,1))/N;
    yave = (y(1,1)+y(2,1)+y(3,1)+y(4,1))/N;
    v = VideoWriter('goui_gun.avi');
    open(v);
    while t <= numel(logger.Data.t)
        clf(figure(9)); 

        xlim([xave-10.0 xave+10.0]);
        ylim([yave-10.0 yave+10.0]);
        set(gca,'FontSize',20);
        xlabel('\sl x \rm [m]','FontSize',25);
        ylabel('\sl y \rm [m]','FontSize',25);
        hold on
        grid on; 
        pbaspect([1 1 1]);
        ax = gca;
        ax.Box = 'on';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.4;

        for i=1:N
        if i==1 figi = plot(x(1,t),y(1,t),'r.','MarkerSize',20);end
        if i==2 figi = plot(x(2,t),y(2,t),'g.','MarkerSize',20);end
        if i==3 figi = plot(x(3,t),y(3,t),'b.','MarkerSize',20);end
        if i==4 figi = plot(x(4,t),y(4,t),'c.','MarkerSize',20);end
        end
        
        hold off 
        pause(16 * 1e-3) ; 
        t = t+10;   
        frame = getframe(figure(9));
        writeVideo(v,frame);      
    end
    close(v);
    disp('simulation ended')

end 




