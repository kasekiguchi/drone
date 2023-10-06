function gen_movie(data)

%% 動画
figure(6)
timestamp= datestr(now,'yyyymmdd_HHMM_ss');
v=VideoWriter(timestamp,'MPEG-4');
v.FrameRate=20;
open(v);
fig = gcf;
fig.Color= [1., 1., 1.];
for k=1:size(data.state-1,1)
  % 目標経路
  p1=plot(data.state(3:end,6),data.state(3:end,7),'-','LineWidth',1.75);
  hold on;
  % 状態
  p2=plot(data.state(k,2),data.state(k,3),'s','LineWidth',1.75);
  % 予測点
  plot(data.Xopt(k,:),data.Yopt(k,:),'.','LineWidth',1.75);
  %位置制約
  %             plot(Xo(1), Xo(2), '.', 'MarkerSize', 20);
  %    p3=yline(0.4,'--','LineWidth',1.7);

  % set Params
  grid on; axis equal; hold off;
  set(gca,'FontSize',16);
  legend([p2 p1],{'State','Target'},'Location','best','Interpreter', 'Latex','FontSize',12);
  %             legend([p2 p1 p3],{'State','Target','Constraint'},'Location','best','Interpreter', 'Latex','FontSize',12);
  xlabel('X [m]','Interpreter', 'Latex');ylabel('Y [m]','Interpreter', 'Latex');
  xlim([0.,5]);ylim([-0.5 2]);

  drawnow
  frame=getframe(gcf);
  writeVideo(v,frame)
  pause(0.1)
end
close(v);
movefile([timestamp,'.mp4'], folderName);
end
