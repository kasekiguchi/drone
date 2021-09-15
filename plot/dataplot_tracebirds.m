function dataplot_tracebirds(logger,N,Nb,fp)
%害鳥追跡用のプロット関数
%引数はログ，ドローンと害鳥の総数，害鳥の総数，畑のエリア
%返し値はなく画像を表示，subversionのファイルに.eps形式で画像出力
%% 行列生成
    t = logger.Data.t;
for n = 1:numel(logger.Data.t)
    for i=1:N
        x(i,n) = logger.Data.agent{n,3,i}.state.p(1,1);
        y(i,n) = logger.Data.agent{n,3,i}.state.p(2,1);
        z(i,n) = logger.Data.agent{n,3,i}.state.p(3,1);
    end
    for i=1:N-1
        distance(i,n) = sqrt((x(1,n)-(x(1+i,n)))^2+(y(1,n)-(y(1+i,n)))^2+(z(1,n)-(z(1+i,n)))^2);
    end
end
    
    %-------------------エージェントのx座標------------------------
    figure(1)
    figure1=figure(1);
    axes1=axes('Parent',figure1);
    for i=1:Nb
        text_number{i} = append('bird',num2str(i));
    end
    for i=Nb+1:N
        text_number{i} = append('drone',num2str(i-Nb));
    end
    hold on
    for i=1:N
        figi = plot(t,x(i,1:numel(logger.Data.t)),'displayname',text_number{i});
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
        figi = plot(t,y(i,1:numel(logger.Data.t)),'displayname',text_number{i});
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
    %-------------------エージェントのz座標------------------------
    figure(3)
    figure3=figure(3);
    axes3=axes('Parent',figure3);
    for i=1:Nb
        text_number{i} = append('bird',num2str(i));
    end
    for i=Nb+1:N
        text_number{i} = append('drone',num2str(i-Nb));
    end
    hold on
    for i=1:N
        figi = plot(t,z(i,1:numel(logger.Data.t)),'displayname',text_number{i});
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
    set(axes3,'FontName','Times New Roman','FontSize',14);
    grid on;
    xlim([0,logger.Data.t(end)+1]);
    xlabel('Time {\it t} [s]');
    ylabel('Position {\it z} [m]');
    axis square;
    legend;
 
    %%  
    %-------------------エージェント初期位置------------------------
    figure(4)
    figure4=figure(4);
    axes4=axes('Parent',figure4);

    hold on
            farea = 5;
            n=numel(fp);
            for i=1:n
                farmxi = fp{i}(1);
                farmyi = fp{i}(2);
                xfi = [farmxi+farea farmxi+farea farmxi-farea farmxi-farea];
                yfi = [farmyi-farea farmyi+farea farmyi+farea farmyi-farea];
                fill(xfi,yfi,'r','FaceAlpha',.2,'EdgeAlpha',.2,'displayname','farm');
            end
                        
%             farmx2 = fp{2}(1);
%             farmy2 = fp{2}(2);
%             xf2 = [farmx2+farea farmx2+farea farmx2-farea farmx2-farea];
%             yf2 = [farmy2-farea farmy2+farea farmy2+farea farmy2-farea];
%             fill(xf2,yf2,'r','FaceAlpha',.2,'EdgeAlpha',.2,'displayname','farm');
    for i=1:Nb
        figi = plot3(x(i,1),y(i,1),z(i,1),'o','MarkerSize',5,'displayname',text_number{i});
    end
    for i=Nb+1:N
        figi = plot3(x(i,1),y(i,1),z(i,1),'x','MarkerSize',5,'displayname',text_number{i});
    end
    hold off
    
    %-------------グラフィックスオブジェクトのプロパティ--------------
    for i=1:N
    set(figi,'LineWidth',1);
    end
    set(axes4,'FontName','Times New Roman','FontSize',12);
    grid on;

    xlim([-10,130]);
    ylim([-10,130]);
    zlim([0,15]);
    xlabel('Position {\it x} [m]');
    ylabel('Position {\it y} [m]');
    zlabel('Position {\it z} [m]');
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
    for i=1:n
        P(i) = polyshape([1 5*(i-1)+1;10 5*(i-1)+1;10 5*(i-1)+5;1 5*(i-1)+5]);
    end
    MaxHp =10;
    for i=1:n
        CurrentHp(i) = MaxHp;
    end
    dt = 0.01;
    for i=1:N
        xsum = xsum + x(i,1);
        ysum = ysum + y(i,1);
    end
    v = VideoWriter('tracebirds','MPEG-4');
    open(v);
    while t <= numel(logger.Data.t)
        clf(figure(9)); 
        
            farea = 5;
            for i=1:n
                farmxi = fp{i}(1);
                farmyi = fp{i}(2);
                xf{i} = [farmxi+farea farmxi+farea farmxi-farea farmxi-farea];
                yf{i} = [farmyi-farea farmyi+farea farmyi+farea farmyi-farea];
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2,'displayname','farm');
            end
            
            
            hold on
            for i=1:n
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2);
                text(fp{i}(1),fp{i}(2),num2str(i));
            end

            for i=1:n
                plot(P(i),'facecolor','none');
                text(-3,5*(i-1)+2.5,num2str(i));
            end

            hold off
        xlim([-10,130]);
        ylim([-10,130]);
        zlim([0,15]);
        set(gca,'FontSize',20);
        xlabel('\sl x \rm [m]','FontSize',25);
        ylabel('\sl y \rm [m]','FontSize',25);
        axis square;
%         view(-40,-30);%シミュレーション用
        view(0,0);%高度確認用
        hold on

        grid on; 
        pbaspect([1 1 1]);
        ax = gca;
        ax.Box = 'on';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.4;
        
        for i=1:Nb
            figi = plot3(x(i,t),y(i,t),z(i,t),'o','MarkerSize',5);
            if t>=2
                quiver3(x(i,t),y(i,t),z(i,t),5*(x(i,t)-x(i,t-1)),5*(y(i,t)-y(i,t-1)),5*(z(i,t)-z(i,t-1)));
            end
            for j=1:n
            HpBar(j) = polyshape([1 5*(j-1)+1;CurrentHp(j) 5*(j-1)+1;CurrentHp(j) 5*(j-1)+5;1 5*(j-1)+5]);
                if x(i,t)>xf{j}(3) && x(i,t)<xf{j}(1) && y(i,t)>yf{j}(1) && y(i,t)<yf{j}(2)
                    CurrentHp(j) = CurrentHp(j)-dt;
                    HpBar(j) = polyshape([1 5*(j-1)+1;CurrentHp(j) 5*(j-1)+1;CurrentHp(j) 5*(j-1)+5;1 5*(j-1)+5]);

                    xlim([-10,130])
                    ylim([-10,130])
                    zlim([0,15])
                    if CurrentHp(j) <=1
                        break;
                    end
                end
                if CurrentHp(j)<3
                    plot(HpBar(j),'facecolor','r')
                else
                    plot(HpBar(j),'facecolor','g')
                end
            end
                

                xlim([-10,130])
                ylim([-10,130])
                zlim([0,15])
        end
        for i=Nb+1:N
            figi = plot3(x(i,t),y(i,t),z(i,t),'x','MarkerSize',5);
        end
        
        hold off 
        pause(16 * 1e-3) ; 
        t = t+1;
        if t==51
            figure(5)
            title('t=5s');
            
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:n
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2);
                plot(P(i),'facecolor','none');
                text(fp{i}(1),fp{i}(2),num2str(i));
                text(-3,5*(i-1)+2.5,num2str(i));
            end
            for j=1:n
                if CurrentHp(j)<3
                    plot(HpBar(j),'facecolor','r')
                else
                    plot(HpBar(j),'facecolor','g')
                end
            end
            
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
                if t>=2
                    quiver(x(i,t),y(i,t),5*(x(i,t)-x(i,t-1)),5*(y(i,t)-y(i,t-1)));
                end
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=5s).eps');
        end
        if t==101
            figure(6)
            title('t=10s');
            
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:n
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2);
                plot(P(i),'facecolor','none');
                text(fp{i}(1),fp{i}(2),num2str(i));
                text(-3,5*(i-1)+2.5,num2str(i));
            end
            for j=1:n
                if CurrentHp(j)<3
                    plot(HpBar(j),'facecolor','r')
                else
                    plot(HpBar(j),'facecolor','g')
                end
            end
            
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
                if t>=2
                    quiver(x(i,t),y(i,t),5*(x(i,t)-x(i,t-1)),5*(y(i,t)-y(i,t-1)));
                end
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=10s).eps');
        end
        if t==151
            figure(7)
            title('t=15s');
            
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:n
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2);
                plot(P(i),'facecolor','none');
                text(fp{i}(1),fp{i}(2),num2str(i));
                text(-3,5*(i-1)+2.5,num2str(i));
            end
            for j=1:n
                if CurrentHp(j)<3
                    plot(HpBar(j),'facecolor','r')
                else
                    plot(HpBar(j),'facecolor','g')
                end
            end
            
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
                if t>=2
                    quiver(x(i,t),y(i,t),5*(x(i,t)-x(i,t-1)),5*(y(i,t)-y(i,t-1)));
                end
            end
            for i=Nb+1:N
                figi = plot(x(i,t),y(i,t),'x','MarkerSize',5);
            end
            hold off
            
            exportgraphics(gcf,'Position trace(t=15s).eps');
        end
        if t==201
            figure(8)
            title('t=20s');
            
            grid on;
            xlim([-10 130]);
            ylim([-10 130]);
            set(gca,'FontSize',20);
            xlabel('\sl x \rm [m]','FontSize',25);
            ylabel('\sl y \rm [m]','FontSize',25);
            axis square;
            hold on
            for i=1:n
                fill(xf{i},yf{i},'r','FaceAlpha',.2,'EdgeAlpha',.2);
                plot(P(i),'facecolor','none');
                text(fp{i}(1),fp{i}(2),num2str(i));
                text(-3,5*(i-1)+2.5,num2str(i));
            end
            for j=1:n
                if CurrentHp(j)<3
                    plot(HpBar(j),'facecolor','r')
                else
                    plot(HpBar(j),'facecolor','g')
                end
            end
            
            for i=1:Nb
                figi = plot(x(i,t),y(i,t),'o','MarkerSize',5);
                if t>=2
                    quiver(x(i,t),y(i,t),5*(x(i,t)-x(i,t-1)),5*(y(i,t)-y(i,t-1)));
                end
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




