function SE_switch_run_mode_callback(app,event)
value = app.RunmodeListBox.Value;
app.Lamp.Color = [0 0 0];
if strcmp(value,"Experiment")
  app.fExp = 1;
  app.ModeDropDown.Items = evalin('base','ExpBaseMode');
else
  app.fExp = 0;
  app.ModeDropDown.Items = evalin('base','SimBaseMode');
end
app.stop
end