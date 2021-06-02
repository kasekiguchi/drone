function dataplot(TC,XC,UC)
%結果のプロット 
    t = situation.t1/10;
%%
    %-------------------エージェントのx座標------------------------
    figure(1)
    figure1=figure(1);
    axes1=axes('Parent',figure1);
    hold on
    fig1 = plot(TC(1,:),XC(1,:),'r-');
    fig2 = plot(TC(1,:),XC(5,:),'g-');
    fig3 = plot(TC(1,:),XC(9,:),'b-');
    fig4 = plot(TC(1,:),XC(13,:),'c-');
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes1,'FontName','Times New Roman','FontSize',24);
    grid on;
    xlim([0 situation.t1]);
    ylim([0 20]);
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
    fig1 = plot(TC(1,:),XC(3,:),'r-');
    fig2 = plot(TC(1,:),XC(7,:),'g-');
    fig3 = plot(TC(1,:),XC(11,:),'b-');
    fig4 = plot(TC(1,:),XC(15,:),'c-');
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes2,'FontName','Times New Roman','FontSize',24);
    grid on;
    xlim([0 situation.t1]);
    ylim([0 30]);
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
    fig1 = plot(XC(1,1),XC(3,1),'r.','MarkerSize',20);
    fig2 = plot(XC(5,1),XC(7,1),'g.','MarkerSize',20);
    fig3 = plot(XC(9,1),XC(11,1),'b.','MarkerSize',20);
    fig4 = plot(XC(13,1),XC(15,1),'c.','MarkerSize',20);
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    set(fig1,'LineWidth',1);
    set(fig2,'LineWidth',1);
    set(fig3,'LineWidth',1);
    set(fig4,'LineWidth',1);
    set(axes3,'FontName','Times New Roman','FontSize',24);
    grid on;
    xlim([0 20]);
    ylim([0 20]);
    xlabel('Position {\it x} [m]');
    ylabel('Position {\it y} [m]');
    axis square;
        legend('Agent1','Agent2','Agent3','Agent4');

    %% 動画作成スレッド

    figure(9)

    % Animation Loop
    t = 1;
    v = VideoWriter('goui_gun.avi');
    open(v);
    while t <= numel(TC)
        clf(figure(9)); 

        xlim([0 20.0]);
        ylim([0 20.0]);
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

        fig1 = plot(XC(1,t),XC(3,t),'r.','MarkerSize',20);
        fig2 = plot(XC(5,t),XC(7,t),'g.','MarkerSize',20);
        fig3 = plot(XC(9,t),XC(11,t),'b.','MarkerSize',20);
        fig4 = plot(XC(13,t),XC(15,t),'c.','MarkerSize',20);
        
        hold off 
        pause(16 * 1e-3) ; 
        t = t+10;   
        frame = getframe(figure(9));
        writeVideo(v,frame);      
    end
    close(v);
    disp('simulation ended')



end 




