
%アニメーション作成中にグラフ触ると動画生成止まるから注意
    Color_map = (169/255)*ones(1000000,3);
	Color_map(1:data.param.particle_num/2,:) = jet(data.param.particle_num/2);
%     Color_map(1:1000000, :) = jet(1:1000000);
	writerObj=VideoWriter(strcat(Outputdir,'/video/animation_v2'));
	open(writerObj);

	for count = 1:size(data.pathJ,2)/3
%         count = 50;
        clf(figure(999))    % figureの削除
		fig = figure(999);
		ax = gca;
%         patch([1 5 5 1],[-0.5 -0.5 1 1],'black','Facealpha',0.2);
        hold on
        
        T = 0:0.1:100;
        X = cos(T/2);
        Y = sin(T/2);
        plot(X, Y, 'LineStyle', '--', 'LineWidth', 0.2);
       
        %%-- 評価値上位 L 個に色付け
%         minI = mink(data.pathJ{count}(1,:), data.param.particle_num/2);
%         for L = 1:data.param.particle_num/2
%             minIL = find(data.pathJ{count}(1, :) == minI(L)); 
%             data.pathJ{count}(1, minIL) = L; 
%         end

%         plot(data.state(:,10),data.state(:,11),'-','Color',[0,0,0]/255,'LineWidth',4);
        hold on;
		% 予測経路のplot
        path_count = size(data.pathJ{count},2);
		for j = 1:path_count
            
			plot(data.path{count}(1,:,j),data.path{count}(2,:,j),'Color',Color_map(ceil(data.pathJ{count}(1,j)+0.0001),:));
%             plot(data.path{count}(1,:,j),data.path{count}(2,:,j),'Color',Color_map(ceil(data.pathJ{count}(1, j)),:));
			hold on;
		end
% 		x = DATA.X(count);
%         y = DATA.Y(count);
%         u = 0.7*cos(DATA.yaw(count));
%         v = 0.7*sin(DATA.yaw(count)); 
%         q = quiver(x,y,u,v,'LineWidth',1.75);
%         q.Color = [255,94,25]/255;
%         q.Marker = 'o';
%         q.MaxHeadSize = 2.;
%         Wheel_posi = [x y];
%         viscircles(Wheel_posi,obj.r_wheel,'LineWidth',0.1,'Color',[255,94,25]/255);
%         obs = USER.obstra{count};
%         for num = 1:obj.ObsNum
%             plot(obs{num,1}(1,1),obs{num,1}(1,2),'ko','MarkerSize',3,'LineWidth',3);hold on;
%             Obs_posi = [obs{num,1}(1,1),obs{num,1}(1,2)];
%             viscircles(Obs_posi,obj.r_obs,'LineWidth',0.1,'Color','black');hold on
% 		end
		plot(data.bestx(count,:),data.besty(count,:),'--','Color',[255,94,25]/255,'LineWidth',2);
		str = ['$$t$$= ',num2str(data.state(count,1),'%.3f'),' s'];
        % circle : -0.27,1.3
		text(-0.5,1.7,str,'FontSize',20,'Interpreter', 'Latex','BackgroundColor',[1 1 1],'EdgeColor',[0 0 0])    %5.2, 2.5
		grid on
        % liner
%         ax.YLim = [-1.5 1.5];
%         ax.XLim = [-0.5 3];
        % circle
        ax.YLim = [-1.5 1.5];
		ax.XLim = [-1.5 1.5];
        % heart
%         ax.YLim = [-3 1];
%         ax.XLim = [-1 3];
		fig.Units = 'normalized';
		set(gca,'FontSize',20,'FontName','Times');
		xlabel('$$X$$[m]','Interpreter', 'Latex','FontSize',20);
		ylabel('$$YZ$$[m]','Interpreter', 'Latex','FontSize',20);
	%     legend({'Reference'},'FontSize',18,'Location','northeast');
		filename = ['Animation_2_2_',num2str(count),];
		Xleng = ax.XLim(1,2) - ax.XLim(1,1);
		Yleng = ax.YLim(1,2) - ax.YLim(1,1);
		pbaspect([Xleng,Yleng,1]);
		ax.OuterPosition = [0.0,0.0,1.15,1.];
		ax.Position = [0.08,0.14,0.89,0.778];
	% %     fig.OuterPosition = [-0.056155913978495,0.039753088660446,1.137096774193548,0.995295763873069];
		fig.Position = [0.17143,0.2074,0.5,0.5102];
	%     saveas(gcf,strcat(Outputdir,'/eps/Animation1/',filename),'epsc');
	%     savefig(gcf,strcat(Outputdir,'/fig/Animation1/',filename),'compact');
		saveas(gcf,strcat(Outputdir,'/png/Animation1/',filename),'png');
        %%
		refreshdata(gcf);
		%-- get frames as images --%
		frame = getframe(gcf);
        im{count} = frame2im(frame);
		%- Add frame to video object -%
		writeVideo(writerObj, frame);
		drawnow limitrate;
        hold off
    end
    
    close(writerObj);
    close;