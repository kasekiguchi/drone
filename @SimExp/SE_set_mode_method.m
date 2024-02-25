function SE_set_mode_method(app)
app.reset_app;
run(app.mode);
if exist("do_calculation","var")
  app.do_calculation = @(A) do_calculation(A);
else
  app.agent = agent;
  app.N = length(agent); app.NumLabel.Text = "Num : " + string(app.N);
  app.PlantLabel.Text = ["Plant : "+  class(agent(1).plant)];
  app.EstimatorLabel.Text = ["Estimator : "+class(agent(1).estimator), "Param : "+class(agent(1).parameter)];
  app.SensorLabel.Text = ["Sensor : "+  class(agent(1).sensor)];
  app.ReferenceLabel.Text = ["Reference : "+ class(agent(1).reference)];
  app.ControllerLabel.Text = ["Controller : "+ class(agent(1).controller)];
  app.logger = logger;
  if app.fExp
    app.flight_reference = agent.reference;
    app.flight_estimator = agent.estimator;
    app.flight_controller = agent.controller;
    app.flight_input_transform = agent.input_transform;
    app.agent.estimator = app.dummy_class(agent.estimator);
    app.agent.reference = app.dummy_class(agent.reference);
    app.agent.controller = app.dummy_class(agent.controller);
  end
  if exist("env","var") app.env = env; end
  if exist("in_prog_func","var") app.in_prog = in_prog_func;      end
  if exist("post_func","var") app.post = post_func;      end
  if exist("takeoff_ref","var") app.takeoff_ref = takeoff_ref;            end
  if exist("landing_ref","var") app.landing_ref = landing_ref;            end
end
app.time = time;
app.TimeSlider.Value = 0;
app.TimeSlider.Limits = [time.ts time.te];
app.TimeSlider.MajorTicks = time.ts:(time.te-time.ts)/5:time.te;
if exist("motive","var"); app.motive = motive; end
app.clear_axes;
app.TimeSliderLabel.Text = ["time : " + app.time.t];
end