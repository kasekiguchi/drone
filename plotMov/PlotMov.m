
%アニメーション作成中にグラフ触ると動画生成止まるから注意
now = datetime('now');
datename = datestr(now, 'yyyymmdd_HHMMSS_FFF');

% 	writerObj=VideoWriter(strcat(Outputdir,'/video/sice23_',datename), 'MPEG-4');
    writerObj=VideoWriter(strcat(Outputdir,'/video/sice23_',datename));
    open(writerObj);
    tt = 0:0.1:15;
    
    
    countMax = size(data.pathJ,2);
    % Jorder : 評価値、もとのインデックス (小さい順)
%     countMax = 40;
	for count = 1:countMax -1 
        
        Color_map = (169/255)*ones(data.variable_particle_num(count),3);  % 灰色のカラーマップの作成
        % 寒色：良い評価、暖色：悪い評価
	    Color_map(1:data.variable_particle_num(count),:) = jet(data.variable_particle_num(count));            % 評価値の上からN個をカラーマップの色付け.
        
%         count = 50;
        clf(figure(999))
		fig = figure(999);
		ax = gca;
%         patch([1 5 5 1],[-0.5 -0.5 1 1],'black','Facealpha',0.2);
        hold on
%         plot(data.state(:,10),data.state(:,11),'-','Color',[0,0,0]/255,'LineWidth',4);
            
        hold on;
		% 予測経路のplot(ホライズン)
        % pathJN : 評価値
        
        path_count = size(pathJN{count}, 2); % N
        Color_array = zeros(path_count,3);
        Color_ceil = zeros(path_count,1);
		for j = 1:path_count % サンプルごとにホライズンはまとめて描画
            %% もとのやつ　create by kotaka and komatsu
			% plot(data.path{count}(3,:,j),data.path{count}(7,:,j),'Color',Color_map(ceil(pathJN{count}(j, 1)),:), 'LineWidth',1); % HL
%             plot(data.path{count}(1,:,j),data.path{count}(2,:,j),'Color',Color_map(ceil(pathJN{count}(1, j)),:), 'LineWidth',1); % MC
%             Color_array(j,:) = Color_map(ceil(pathJN{count}(1, j)),:);
%             Color_ceil(j,1) = round(ceil{count}(1, j));
% 			hold on;

            %% 評価の良いサンプルから描画
            % Jorder = [J, I];
            Jindex = Jorder{count}(j,2); % 評価値の良いほうから評価値と元のインデックスの抜き取り
            plot(data.path{count}(1,:,Jindex), data.path{count}(2,:,Jindex), 'Color',Color_map(Jindex,:),'LineWidth',1.5);
            hold on;
        end
        plot(data.state(count, 2), data.state(count,3), '.', 'MarkerSize', 20, 'Color', 'red');    % 現在位置
%         plot(Rdata(1,count), Rdata(2,count), 'h', 'MarkerSize', 15, 'Color', 'blue');   % 目標位置 Rdata = xr
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
        plot(cos(tt/2), sin(tt/2), 'LineWidth', 1, 'color', 'green'); % 目標起動
        pgon = polyshape([-1.5 -1.5 -0.5 -0.5],[1.5 -1.5 -1.5 1.5]); plot(pgon, 'FaceColor', "red", "EdgeColor", "red");
        hold off;

		str = ['$$t$$= ',num2str(logt(count,1),'%.3f'),' s'];
		text(-0.5,1.65,str,'FontSize',20,'Interpreter', 'Latex','BackgroundColor',[1 1 1],'EdgeColor',[0 0 0])
		grid on
		ax.YLim = [-1.5 1.5];
		ax.XLim = [-1.5 1.5];
        % ax.YLim = [-0.2 2];
		% ax.XLim = [-0.2 12];
		fig.Units = 'normalized';
		set(gca,'FontSize',20,'FontName','Times');
		xlabel('$$X$$[m]','Interpreter', 'Latex','FontSize',20);
		ylabel('$$Y$$[m]','Interpreter', 'Latex','FontSize',20);
	%     legend({'Reference'},'FontSize',18,'Location','northeast');
		filename = ['Animation_',num2str(count)];
		Xleng = ax.XLim(1,2) - ax.XLim(1,1);
		Yleng = ax.YLim(1,2) - ax.YLim(1,1);
		pbaspect([Xleng,Yleng,1]);
		ax.OuterPosition = [0.0,0.0,1.15,1.];
		ax.Position = [0.08,0.14,0.89,0.778];
	% %     fig.OuterPosition = [-0.056155913978495,0.039753088660446,1.137096774193548,0.995295763873069];
		fig.Position = [0.17143,0.2074,0.5,0.5102];
% 	    saveas(gcf,strcat(Outputdir,'/eps/Animation1/',filename),'epsc');
% 	    savefig(gcf,strcat(Outputdir,'/fig/Animation1/',filename),'compact');
%      
% 		saveas(gcf,strcat(Outputdir,'/png/Animation1/',filename),'png'); コメントアウトするとちょっと早くなる
        I=getframe(gcf);
        imwrite(I.cdata,strcat(Outputdir_mov,filename,'.png'))
        
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
    % 
    close(writerObj);
    close;