function SE_constructor(app, fExp, fDebug, PInterval)
app.fExp = fExp;
app.fDebug = fDebug;
app.PInterval = PInterval;
if app.fExp
  app.RunmodeListBox.Value = "Experiment";
  app.ModeDropDown.Items = evalin('base','ExpBaseMode');
else
  app.RunmodeListBox.Value = "Simulation";
  app.ModeDropDown.Items = evalin('base','SimBaseMode');
end
app.stop
if ~isempty(app.ModeDropDown.Items{1})
  % automatically load the first mode
  app.mode = app.ModeDropDown.Items{1};
  app.SE_set_mode_method;
end
% appearance
app.LampLabel.HorizontalAlignment = 'left';
app.UIFigure.WindowState = 'maximized';
end