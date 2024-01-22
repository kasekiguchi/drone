function plot_wind_north_dir(app)
p = polyshape([1,0,-1,1],[0,3,0,0]);
plot(app.NorthWindDir,p,"");
hold(app.NorthWindDir,'on');
th = -pi:0.05:pi;
plot(app.NorthWindDir,3*cos(th),3*sin(th));
daspect(app.NorthWindDir,[1,1,1]);
view(app.NorthWindDir,-app.map.shape_opts.north_dir*180/pi,90);
set(app.NorthWindDir,'color','w')
app.NorthWindDir.XAxis.Visible = 'off';
app.NorthWindDir.YAxis.Visible = 'off';
hold(app.NorthWindDir,'off');
end