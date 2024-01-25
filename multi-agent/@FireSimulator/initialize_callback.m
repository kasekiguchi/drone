function initialize_callback(app,event)
app.InitializefirstLampLabel.Text = "Initializing";
app.InitializefirstLamp.Color = [1 0 0];

app.step_end = app.SimstepEditField.Value; % Description
app.unum = app.FirefightersEditField.Value;
if isempty(app.map.W)
  app.map.set_target();
end
wind_data = app.wind_data;
app.map.setup_wind(wind_data);
app.map.set_gridcell_model();
app.map.plot_E(app.Flying_ax,app.map.WF{1});
app.map.plot_E(app.Spread_ax,app.map.WS{1});
app.step_end = app.SimstepEditField.Value;
app.TimeSlider.Limits = [0,app.SimstepEditField.Value];
app.InitializefirstLampLabel.Text = "Ready";
app.InitializefirstLamp.Color = [0 1 0];

app.plot_wind_north_dir();
% fire outbreak points
if isfield(app.map.shape_opts,"outbreak")
  app.outbreak = app.map.shape_opts.outbreak;
else
  app.outbreak = [floor(1.01*app.map.nx/2)+kron([-1;0;1],[1;1;1]),1 + repmat([1;2;3],3,1)];
end
app.map.model_init(app.outbreak);
app.map.draw_state(app.map,app.Grid_ax);
end