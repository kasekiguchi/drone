function constructor(app, flag, shape_data, shape_opts, W, unum, step_end, wind_data)
% north_dir = 0; % rad
% start_point = [0,0]; % マップ左下から見た位置 [m,m]
% map_size = [1,1000]; % north_dir で回転した後の start_pointからの領域 [m m]
app.NorthdirectionGauge.Visible = 'off';
app.map = FIELD_MAP(flag,shape_data,shape_opts,W);
app.ShapefileLabel.Text = string(app.ShapefileLabel.Text) + app.map.shape_data;
app.mapsizeLabel.Text = string(app.mapsizeLabel.Text) + join(string(shape_opts.map_size)," x ");
app.map.unum = unum;
app.step_end = step_end;
app.wind_data = wind_data;

app.WinddataEditField.Value = wind_data;
app.ShapefileLabel.Text = app.map.shape_data;
app.SimstepEditField.Value = step_end;
app.FirefightersEditField.Value = unum;
if isempty(app.map.W) % set region from shape file
  mapshow(app.original_data_ax,app.map.S);
  daspect(app.original_data_ax,[1,1,1]);
  xm = min([app.map.S.X]);
  ym = min([app.map.S.Y]);
  xM = max([app.map.S.X]);
  yM = max([app.map.S.Y]);
  app.shape_min = [xm,ym];
  tmp = app.original_data_ax.PlotBoxAspectRatio;
  app.shape_ratio = tmp(2)/tmp(1);
  %        patch(app.original_data_ax,'Faces',[1,2,3,4],'Vertices',[xm,ym;xM,ym;xM,yM;xm,yM],...
  %          'EdgeColor','green','FaceColor','none','LineWidth',2);
  app.original_data_ax.XLim = [xm-0.01*(xM-xm),xM+0.01*(xM-xm)];
  app.original_data_ax.YLim = [ym-0.01*(yM-ym),yM+0.01*(yM-ym)];
  app.original_data_ax.Title.String = app.map.shape_data;
  %view(app.original_data_ax,atan(tan(shape_opts.north_dir)*app.shape_ratio)*180/pi,90);
  % viewがaspectを変更する前のaxesでの回転を表すため変換が必要
  app.TabGroup.SelectedTab = app.SettingTab;
  if isfield(shape_opts,"start_point")
    xm = xm + shape_opts.start_point(1);
    ym = ym + shape_opts.start_point(2);
    if isfield(shape_opts,"map_size")
      th = -shape_opts.north_dir;
      tmp = [xm,ym] + shape_opts.map_size*[cos(th),sin(th);-sin(th),cos(th)];
      xM = tmp(1);
      yM = tmp(2);
    end
  end
  app.roibl = drawpoint(app.original_data_ax,'Color','g','Position',[xm,ym]);
  app.roitr = drawpoint(app.original_data_ax,'Color','b','Position',[xM,yM]);
  app.roifire = drawpoint(app.original_data_ax,'Color','r','Position',[(xm+xM)/2,(ym+yM)/2]);
  app.BottomleftgreenEditField.Value = join(string([xm,", ",ym]));
  app.ToprightblueEditField.Value = join(string([xM,", ",yM]));
  addlistener(app.roibl,'ROIMoved',@(src,evt) set_region_callback(src,evt,app.BottomleftgreenEditField,@app.MaprotationCCWEditFieldValueChanged));
  addlistener(app.roitr,'ROIMoved',@(src,evt) set_region_callback(src,evt,app.ToprightblueEditField,@app.MaprotationCCWEditFieldValueChanged));
  addlistener(app.roifire,'ROIMoved',@(src,evt) set_region_callback(src,evt,app.ToprightblueEditField,@app.MaprotationCCWEditFieldValueChanged));
  app.MaprotationCCWEditField.Value = string(shape_opts.north_dir*180/pi);
  %app.MaprotationCCWEditFieldValueChanged(0);
  map_rotation_CCW(app,0);
  app.NorthdirectionGauge.Value = -shape_opts.north_dir; % rad
  app.original_data_ax.HandleVisibility = 'off';
else
  if isstring(W) | ischar(W)
    sp0 = split(erase(W,".mat"),"_");
    sp1 = double(string(split(sp0{end},"-")));
    app.map.shape_opts.start_point = sp1(1:2)';
    app.map.shape_opts.map_size = sp1(3:4)';
    tmp = sp1(5:end);
    if isnan(tmp(1))
      app.NorthdirectionGauge.Value = -tmp(2);
    else
      app.NorthdirectionGauge.Value = tmp;
    end
    load(W);
    app.map.W = W;
  else
    app.map.W = W;
  end
  app.TabGroup.SelectedTab = app.SimulationTab;
  app.map.nx = size(app.map.W,2);
  app.map.ny = size(app.map.W,1);
  app.map.map_scale = app.map.shape_opts.map_size(1)/app.map.nx;
  app.nxEditField.Value = app.map.nx;
  app.nyEditField.Value = app.map.ny;
  app.map.plot_W(app.UIAxes);
end
end