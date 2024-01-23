function plot_wind_north_dir(app,wi)
arguments
  app
  wi = 1;
end
if isempty(app.NorthWindDir.Children) % initialize
  th = -pi:0.05:pi;
  plot(app.NorthWindDir,20*cos(th),20*sin(th),'LineWidth',0.1,'Color','k');
  hold(app.NorthWindDir,'on');
  dirs = (2*pi/32:2*pi/32:2*pi);% + app.map.shape_opts.north_dir;
  line(app.NorthWindDir,20*[zeros(size(dirs));cos(dirs)],20*[zeros(size(dirs));sin(dirs)],'LineWidth',0.1,'Color','k');
  p = polyshape([5,0,-5,5],[0,20,0,0]);
  plot(app.NorthWindDir,p,'FaceColor','r','FaceAlpha',1);

  %wdir_base= ["南微西","南南西","南西微南","南西","南西微西","西南西","西微南","西","西微北","西北西","北西微西","北西","北西微北","北北西","北微西","北","北微東","北北東","北東微北","北東","北東微東","東北東","東微北","東","東微南","東南東","南東微東","南東","南東微南","南南東","南微東","南"];
  wdir_base = ["北","西","南","東"];
  text(app.NorthWindDir,24*cos(dirs(8:8:end)),24*sin(dirs(8:8:end)),wdir_base,'HorizontalAlignment','center','VerticalAlignment','middle');

  % wind
  th = -app.map.wind(wi,1);
  ap = app.map.wind(wi,2)*[cos(th),-sin(th);sin(th),cos(th)]*[[0,0,0.2,0,-0.2,0];[0,1,0.7,1,0.7,1]];
  line(app.NorthWindDir,ap(1,:),ap(2,:),'LineWidth',3,'Color','g');
  
  daspect(app.NorthWindDir,[1,1,1]);
  view(app.NorthWindDir,-app.map.shape_opts.north_dir*180/pi,90);
  app.NorthWindDir.XAxis.Visible = 'off';
  app.NorthWindDir.YAxis.Visible = 'off';
  app.NorthWindDir.Color = 0.95*[1 1 1];
else % simulation
  th = app.map.wind(wi,1);
  ap = app.map.wind(wi,2)*[cos(th),-sin(th);sin(th),cos(th)]*[[0,0,0.2,0,-0.2,0];[0,1,0.7,1,0.7,1]];
  %line(app.NorthWindDir,ap(1,:),ap(2,:),'LineWidth',3,'Color','g');
  app.NorthWindDir.Children(1).XData = ap(1,:);
  app.NorthWindDir.Children(1).YData = ap(2,:);
end
%  hold(app.NorthWindDir,'off');
end