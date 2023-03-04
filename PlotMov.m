
%アニメーション作成中にグラフ触ると動画生成止まるから注意
% maxbestcost = max(data.bestcost)
% now = datetime('now');
% datename = datestr(now, 'yyyymmdd_HHMMSS_FFF');
    
    %%
%     Color_map(1:data.param.particle_num/2, :) = jet(data.param.particle_num/2);
	writerObj=VideoWriter(strcat(Outputdir,'/video/v1'));
	open(writerObj);
    tt = 0:0.1:15;
    
    
    countMax = size(data.pathJ,2);
	for count = 1:countMax
        Color_map = (169/255)*ones(data.variable_particle_num(count),3);  % 灰色のカラーマップの作成
        % 寒色：良い評価、暖色：悪い評価
	    Color_map(1:data.variable_particle_num(count),:) = jet(data.variable_particle_num(count));            % 評価値の上から10個をカラーマップの色付け.
        
%         count = 50;
        clf(figure(999))
		fig = figure(999);
		ax = gca;
%         patch([1 5 5 1],[-0.5 -0.5 1 1],'black','Facealpha',0.2);
        hold on
%         plot(data.state(:,10),data.state(:,11),'-','Color',[0,0,0]/255,'LineWidth',4);
            
        hold on;
		% 予測経路のplot(ホライズン)
%         path_count = size(data.pathJ{count},2);
		for j = 1:size(data.pathJ{count},1)
			plot(data.path{count}(3,:,j),data.path{count}(7,:,j),'Color',Color_map(ceil(pathJN{count}(j, 1)),:), 'LineWidth',1);
			hold on;
        end
        plot(data.state(count, 2), data.state(count, 3), '.', 'MarkerSize', 20, 'Color', 'red');
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
%         plot(cos(tt/2), sin(tt/2), 'LineWidth', 1, 'color', 'green');
%         pgon = polyshape([-1.2 -1.2 -0.5 -0.5],[1.2 -1.2 -1.2 1.2]); plot(pgon);

		str = ['$$t$$= ',num2str(data.state(count,1),'%.3f'),' s'];
		text(-0.1,12,str,'FontSize',20,'Interpreter', 'Latex','BackgroundColor',[1 1 1],'EdgeColor',[0 0 0])
		grid on
% 		ax.YLim = [-0.5 2];
% 		ax.XLim = [-0.5 2];
        ax.YLim = [-0.2 2];
		ax.XLim = [-0.2 12];
		fig.Units = 'normalized';
		set(gca,'FontSize',20,'FontName','Times');
		xlabel('$$X$$[m]','Interpreter', 'Latex','FontSize',20);
		ylabel('$$Y$$[m]','Interpreter', 'Latex','FontSize',20);
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