function set_map_callback(app,event)
app.map.shape_opts.start_point = app.ps(1,:)-app.shape_min;
app.map.shape_opts.north_dir = -app.NorthdirectionGauge.Value;
app.map.shape_opts.map_size = vecnorm([(app.ps(2,:)-app.ps(1,:))',(app.ps(4,:)-app.ps(1,:))']);
app.NorthdirectionGauge.Visible = 'on';
app.TabGroup.SelectedTab = app.SimulationTab;
%app.NorthdirectionGaugeLabel.Text = "North direction";
app.map.set_target();
app.nxEditField.Value = app.map.nx;
app.nyEditField.Value = app.map.ny;
app.map.plot_W(app.UIAxes);
app.SettingTab.HandleVisibility = 'off';
end