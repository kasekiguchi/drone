function dataplot_tracebirds(logger,N,Nb,fp)
%% 行列生成
    t = logger.Data.t;
for n = 1:numel(logger.Data.t)
    for i=1:N
        x(i,n) = logger.Data.agent{n,3,i}.state.p(1,1);
        y(i,n) = logger.Data.agent{n,3,i}.state.p(2,1);
    end
    for i=1:N-1
        distance(i,n) = sqrt((x(1,n)-(x(1+i,n)))^2+(y(1,n)-(y(1+i,n)))^2);
    end
end
    
    %-------------------エージェントのx座標------------------------
    figure(1)
    figure1=figure(1);
    axes1=axes('Parent',figure1);
    for i=1:Nb
        text{i} = append('bird',num2str(i));
    end
    for i=Nb+1:N
        text{i} = append('drone',num2str(i-Nb));
    end
    hold on
    for i=1:N
        figi = plot(t,x(i,1:numel(logger.Data.t)),'displayname',text{i});
%     if i==1 figi = plot(t,x(i,1:numel(logger.Data.t)),'r-');end
%     if i==2 figi = plot(t,x(i,1:numel(logger.Data.t)),'g-');end
%     if i==3 figi = plot(t,x(i,1:numel(logger.Data.t)),'b-');end
%     if i==4 figi = plot(t,x(i,1:numel(logger.Data.t)),'c-');end
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
    legend;
      
        
%%        
%-------------------エージェントのy座標------------------------
    figure(2)
    figure2=figure(2);
    axes2=axes('Parent',figure2);
    hold on
    for i=1:N
        figi = plot(t,y(i,1:numel(logger.Data.t)),'displayname',text{i});
%     if i==1 figi = plot(t,y(i,1:numel(logger.Data.t)),'r-');end
%     if i==2 figi = plot(t,y(i,1:numel(logger.Data.t)),'g-');end
%     if i==3 figi = plot(t,y(i,1:numel(logger.Data.t)),'b-');end
%     if i==4 figi = plot(t,y(i,1:numel(logger.Data.t)),'c-');end
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
    legend;
    
%%  
    %-------------------エージェント初期位置------------------------
    figure(3)
    figure3=figure(3);
    axes3=axes('Parent',figure3);

    hold on
            farea = 5;
            farmx = fp(1);
            farmy = fp(2);
            xf = [farmx+farea farmx+farea farmx-farea farmx-farea];
            yf = [farmy-farea farmy+farea farmy+farea farmy-farea];
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2,'displayname','farm')
    for i=1:Nb
        figi = plot(x(i,1),y(i,1),'o','MarkerSize',5,'displayname',text{i});
    end
    for i=Nb+1:N
        figi = plot(x(i,1),y(i,1),'x','MarkerSize',5,'displayname',text{i});
    end
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    for i=1:N
    set(figi,'LineWidth',1);
    end
    set(axes3,'FontName','Times New Roman','FontSize',12);
    grid on;

    xlim([-10,130]);
    ylim([-10,130]);
    xlabel('Position {\it x} [m]');
    ylabel('Position {\it y} [m]');
    axis square;
    legend('Location','eastoutside');
    cd 'C:\Users\kasai\Desktop\work\work_svn\bachelor\thesis\fig'
    exportgraphics(gcf,'initial position trace birds.eps');
%     %% エージェント間の距離
%     figure(8)
%     figure8=figure(8);
%     axes8=axes('Parent',figure8);
%     for i=1:N-1
%         text2{i} = append('agent1-',num2str(i+1));
%     end
%     hold on
%     for i=1:N-1
%         figi = plot(t,distance(i,1:numel(logger.Data.t)),'displayname',text2{i});
%     end
%     hold off
%     
%     %-------------グラフィックスオブジェクトのプロパティ--------------
%     for i=1:N
%     set(figi,'LineWidth',1);
%     end
%     set(axes8,'FontName','Times New Roman','FontSize',14);
%     grid on;
%     xlim([0,logger.Data.t(end)+1]);
% %     ylim([0,7]);
%     xlabel('Time {\it t} [s]');
%     ylabel('Distance {\it d} [m]');
%     axis square;
%     legend;
    %% 動画作成スレッド

    figure(9)

    % Animation Loop

    t = 1;
    xsum = 0;
    ysum = 0;
    for i=1:N
        xsum = xsum + x(i,1);
        ysum = ysum + y(i,1);
    end
    v = VideoWriter('tracebirds','MPEG-4');
    open(v);
    while t <= numel(logger.Data.t)
        clf(figure(9)); 
            farea = 5;
            farmx = fp(1);
            farmy = fp(2);
            xf = [farmx+farea farmx+farea farmx-farea farmx-farea];
            yf = [farmy-farea farmy+farea farmy+farea farmy-farea];
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2);
        xlim([-10,130]);
        ylim([-10,130]);
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

        for i=1:Nb
            figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
        end
        for i=Nb+1:N
            figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
        end
        
        hold off 
        pause(16 * 1e-3) ; 
        t = t+1;
        if t==51
            figure(4)
            title('t=5s');
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2);
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=5s).eps');
        end
        if t==101
            figure(5)
            title('t=10s');
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2);
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=10s).eps');
        end
        if t==151
            figure(6)
            title('t=15s');
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2);
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=15s).eps');
        end
        if t==201
            figure(7)
            title('t=20s');
            fill(xf,yf,'r','FaceAlpha',.2,'EdgeAlpha',.2);
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=20s).eps');
        end
        frame = getframe(figure(9));
        writeVideo(v,frame);      

    end
            
    close(v);
    exportgraphics(gcf,'final position trace birds.eps');
    disp('simulation ended')

end 




