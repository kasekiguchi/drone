function initialize_callback(app,event)
app.InitializefirstLampLabel.Text = "Initializing";
app.InitializefirstLamp.Color = [1 0 0];

app.step_end = app.SimstepEditField.Value; % Description
app.unum = app.FirefightersEditField.Value;
if isempty(app.map.W)
  app.map.set_target();
end
wind_data = app.WinddataEditField.Value;
app.map.setup_wind(wind_data);
app.map.set_gridcell_model();
app.map.plot_E(app.UIAxes2,app.map.WF{1});
app.map.plot_E(app.UIAxes3,app.map.WS{1});
app.step_end = app.SimstepEditField.Value;
app.TimeSlider.Limits = [0,app.SimstepEditField.Value];
app.InitializefirstLampLabel.Text = "Ready";
app.InitializefirstLamp.Color = [0 1 0];

% wind and north directions
vx = [app.map.wind(1,2)*cos(app.map.wind(1,1));10*cos(app.map.shape_opts.north_dir)];
vy = [app.map.wind(1,2)*sin(app.map.wind(1,1));10*sin(app.map.shape_opts.north_dir)];
c = compass(app.NorthWindDir,vx,vy);
c(2).LineWidth = 2;
c(2).Color = 'r';
c(1).LineWidth = 2;
c(1).Color = 'b';
view(app.NorthWindDir,-90,90);

% fire outbreak points
if isfield(app.map.shape_opts,"outbreak")
  app.outbreak = app.map.shape_opts.outbreak;
else
  app.outbreak = [floor(1.01*app.map.nx/2)+kron([-1;0;1],[1;1;1]),1 + repmat([1;2;3],3,1)];
end
app.map.model_init(app.outbreak);
app.map.draw_state(app.map,app.UIAxes);
end