function set_map_callback(app,event)
app.map.shape_opts.start_point = app.ps(1,:)-app.shape_min;
app.map.shape_opts.map_size = vecnorm([(app.ps(2,:)-app.ps(1,:))',(app.ps(4,:)-app.ps(1,:))']);
app.TabGroup.SelectedTab = app.SimulationTab;
app.map.set_target();
app.nxEditField.Value = app.map.nx;
app.nyEditField.Value = app.map.ny;
app.map.plot_W(app.Grid_ax);
app.SettingTab.HandleVisibility = 'off';
end