function SE_start_callback(app,event)
event
app.Label.VerticalAlignment = 'top';
app.UIFigure.WindowKeyPressFcn = @app.keyPressFunc;
app.Label_2.Text = ""; % clear emergency text
if ~isempty(app.mode)
  if app.fStart % to stop
    app.stop;
  else % to start
    app.fStart = 1;
    app.StartButton.Text = "Stop";
    app.Lamp.Color = [0 1 0];
    app.update_timer = timer('Period', app.PInterval,... % poling interval
      'ExecutionMode', 'fixedSpacing', ... % execution mode
      'TasksToExecute', Inf, ... % trial number
      'TimerFcn', @app.mytimer_fun); % callback function

    app.loop();
  end
else
  app.Label.Text = "Set mode first";
  app.stop;
end
end