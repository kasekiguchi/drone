function plot_wind_north_dir(app,wi)
arguments
  app
  wi = 1;
end
if isempty(app.NorthWindDir.Children) % initialize
  p = polyshape([5,0,-5,5],[0,20,0,0]);
  plot(app.NorthWindDir,p,'FaceColor','r');
  hold(app.NorthWindDir,'on');
  th = -pi:0.05:pi;
  plot(app.NorthWindDir,20*cos(th),20*sin(th));
  quiver(app.NorthWindDir,0,0,app.map.wind(wi,2)*sin(app.map.wind(wi,1)),app.map.wind(wi,2)*cos(app.map.wind(wi,1)),'LineWidth',5,'Color','k','MaxHeadSize',10);
  daspect(app.NorthWindDir,[1,1,1]);
  view(app.NorthWindDir,-app.map.shape_opts.north_dir*180/pi,90);
  app.NorthWindDir.XAxis.Visible = 'off';
  app.NorthWindDir.YAxis.Visible = 'off';
  app.NorthWindDir.Color = 0.95*[1 1 1];
else % simulation
  app.NorthWindDir.Children(1).UData = app.map.wind(wi,2)*sin(app.map.wind(wi,1));
  app.NorthWindDir.Children(1).VData = app.map.wind(wi,2)*cos(app.map.wind(wi,1)); 
end
%  hold(app.NorthWindDir,'off');
end