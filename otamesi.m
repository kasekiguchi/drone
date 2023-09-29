classdef SimExp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        LeftPanel                     matlab.ui.container.Panel
        Label                         matlab.ui.control.Label
        ControllerLabel               matlab.ui.control.Label
        EstimatorLabel                matlab.ui.control.Label
        ReferenceLabel                matlab.ui.control.Label
        SensorLabel                   matlab.ui.control.Label
        PlantLabel                    matlab.ui.control.Label
        NumLabel                      matlab.ui.control.Label
        ReloadButton                  matlab.ui.control.Button
        ModeDropDown                  matlab.ui.control.DropDown
        ModeDropDownLabel             matlab.ui.control.Label
        RunmodeListBox                matlab.ui.control.ListBox
        RunmodeListBoxLabel           matlab.ui.control.Label
        CenterPanel                   matlab.ui.container.Panel
        FilenameoptionEditField       matlab.ui.control.EditField
        FilenameoptionEditFieldLabel  matlab.ui.control.Label
        SavedataButton                matlab.ui.control.Button
        Label_2                       matlab.ui.control.Label
        TimeSlider                    matlab.ui.control.Slider
        TimeSliderLabel               matlab.ui.control.Label
        DrawgraphButton               matlab.ui.control.Button
        LampLabel                     matlab.ui.control.Label
        Lamp                          matlab.ui.control.Lamp
        StartButton                   matlab.ui.control.Button
        UIAxes                        matlab.ui.control.UIAxes
        RightPanel                    matlab.ui.container.Panel
        UIAxes4                       matlab.ui.control.UIAxes
        UIAxes3                       matlab.ui.control.UIAxes
        UIAxes2                       matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end


  properties (Access = private)
    fStart = 0;
    fInit  = 0;
    post = @(app) [];
    in_prog = @(app) [];
    dummy_class = @(class) struct("do",@(varargin)[],"result",class.result);
  end
  properties (Access = public)
    data_file_name = [];
    takeoff_ref = [];
    landing_ref = [];
    flight_sensor = [];
    flight_reference = [];
    flight_estimator = [];
    flight_controller = [];
    flight_input_transform = [];
    fDebug
    PInterval
    fExp = 0;
    mode = [];
    logger
    env = [];
    time
    cha = "";
    cha0 = "";
    agent
    motive = [];
    update_timer;
    N = 1;
    t0 = 0;
  end
  methods (Access = private)
    function mytimer_fun(app, obj, event)
      % Timer で指定するコールバック関数
      if app.t0 == app.time.t && app.time.t > 0
        app.Label_2.Text = ["","","===========  Emergency stop!  ========="];
        app.StopProp;
        app.fStart = 0;
      end
      app.t0 = app.time.t;
    end
    function reset_app(app)
      app.data_file_name = [];
      app.takeoff_ref = [];
      app.landing_ref = [];
      app.logger = [];
      app.env = [];
      app.time = [];
      app.cha = "";
      app.cha0 = "";
      app.agent = [];
      app.motive = [];
      app.update_timer = [];
      app.N = 1;
    end
    function Arming(app)
      app.agent.plant.arming;
    end
    function Takeoff(app)
      %app.agent(1).sensor = app.flight_sensor;
      app.agent.estimator = app.flight_estimator;
      app.agent.controller = app.flight_controller;
      app.agent.input_transform = app.flight_input_transform;
      app.agent.reference = app.takeoff_ref;
    end
    function Flight(app)
      app.agent.reference = app.flight_reference;
    end
    function Landing(app)
      app.agent.reference.result.state.xd = [];
      app.landing_ref.result.state = app.agent.reference.result.state;
      app.agent.reference = app.landing_ref;
    end
    function StopProp(app)
      app.agent.plant.stop;
    end
    function Quit(app)
      app.agent.plant.stop;
    end
    function do_calculation(app)
      for i = 1:app.N
        app.agent(i).sensor.do(app.time,app.cha,app.logger,app.env,app.agent,i);
        app.agent(i).estimator.do(app.time,app.cha,app.logger,app.env,app.agent,i);
        app.agent(i).reference.do(app.time,app.cha,app.logger,app.env,app.agent,i);
        app.agent(i).controller.do(app.time,app.cha,app.logger,app.env,app.agent,i);
        app.agent(i).input_transform.do(app.time,app.cha,app.logger,app.env,app.agent,i);
        app.agent(i).plant.do(app.time,app.cha,app.logger,app.env,app.agent,i);
      end
      app.logger.logging(app.time, app.cha, app.agent,[]);
      app.time.k = app.logger.k;
    end

    function loop(app)
      pause(0.1);
      if app.fExp % experiment
        app.Label.Text = ["== EXPERIMENT ==","Start! Press key code" + app.cha,"s : stop", "a : arming", "t : take-off", "f : fligh", "l : landing"];
        app.TimeSliderLabel.Text = ["..."];
        uiwait(app.UIFigure)
        start(app.update_timer);
        % Caution : N agents are not allowed.
        while app.fStart
          tStart = tic;
          drawnow
          if app.cha0 ~= app.cha % exec once per another key press
            switch app.cha
              case {'q',' '}
                app.Quit;
                app.LampLabel.Text = "Quit the trial";
                app.Lamp.Color = [0 0 0];
                break;
              case 's'
                app.StopProp;
                app.LampLabel.Text = "Stop propellas";
                app.Lamp.Color = [0 1 0];
              case 'f'
                if strcmp(app.cha0,'t') % "flight" is allowed after "take-off"
                  app.LampLabel.Text = "Flight";
                  app.Flight;
                end
              case 'l'
                app.LampLabel.Text = "Landing";
                app.Landing;
              case 't'
                if strcmp(app.cha0,'a') % "take-off" is allowed after "arming"
                  app.LampLabel.Text = "Take-off";
                  app.Takeoff;
                end
              case 'a'
                app.LampLabel.Text = "Arming";
                app.Arming;
                app.Lamp.Color = [1 0 0];
            end
            app.cha0 = app.cha;
          end
          if ~isempty(app.motive);              app.motive.getData(app.agent);            end
          %app.TimeSlider.Value = app.time.t;          
          app.do_calculation();
          app.time.dt = toc(tStart);
          app.time.t = app.time.t + app.time.dt;
        end
      else % simulation
        app.Label.Text = "Press any key to start. (except for 'q', 'space', 'enter')";
        uiwait(app.UIFigure)
        %start(app.update_timer);
        while app.fStart && (app.time.t < app.time.te)
          drawnow;
          if app.cha0 ~= app.cha
            switch app.cha
              case {'q',' '}
                app.LampLabel.Text = "Quit the trial";
                app.Lamp.Color = [1 0 0];
                break;
              otherwise
            end
            app.cha0 = app.cha;
          end
          if ~isempty(app.motive)
            app.motive.getData(app.agent);
          end
          app.do_calculation();
          app.TimeSlider.Value = app.time.t;
          app.TimeSliderLabel.Text = string(app.time.t);
          app.time.t = app.time.t + app.time.dt;
          if app.fDebug && app.time.t > app.time.dt % not active at the initial step
            app.in_prog(app);
          end
        end
      end
      app.stop;
    end

    function keyPressFunc(app,src,event)
      app.cha = event.Character;
      uiresume(src);
    end
    function stop(app)
      app.fStart = 0;
      app.StartButton.Text = "Start";
      app.Lamp.Color = [0 0 0];
      app.Label.Text = "Program Stop";
      app.cha = "";
      app.cha0 = "";
      if ~isempty(app.update_timer)
        stop(app.update_timer);
        delete(app.update_timer);
        app.update_timer = [];
      end
    end
    %%
    function set_mode(app)
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

    function clear_axes(app)
      cla(app.UIAxes); if ~isempty(app.UIAxes.Colorbar) app.UIAxes.Colorbar.Visible = 'off';end
      cla(app.UIAxes2);
      cla(app.UIAxes3);
      cla(app.UIAxes4);
    end
  end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, fExp, fDebug, PInterval)
      % start up function : set modes list and load the first mode
      %app.UIFigure.WindowState = 'maximized';
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
        app.set_mode;
      end
      % appearance
      app.LampLabel.HorizontalAlignment = 'left';
      app.UIFigure.WindowState = 'maximized';
        end

        % Button pushed function: StartButton
        function start(app, event)
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

        % Value changed function: RunmodeListBox
        function switch_run_mode(app, event)
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

        % Value changed function: ModeDropDown
        function change_mode(app, event)
      app.mode = app.ModeDropDown.Value;
      app.set_mode;
        end

        % Value changing function: TimeSlider
        function set_current_time(app, event)
      app.time.k = find(app.logger.Data.t>=event.Value,1);
      if isempty(app.time.k)
        app.time.k = app.logger.k;
      end
      app.time.t = app.logger.Data.t(app.time.k);
      app.draw_data;
        end

        % Button pushed function: DrawgraphButton
        function draw_data(app, event)
      app.clear_axes;
      if isempty(app.post)
        app.logger.plot({1:app.N, "p", "er"},"FH",app.UIAxes,"xrange",[app.time.ts,app.time.t]);
        app.logger.plot({1:app.N, "q", "er"},"FH",app.UIAxes2,"xrange",[app.time.ts,app.time.t]);
        app.logger.plot({1:app.N, "input", ""},"FH",app.UIAxes3,"xrange",[app.time.ts,app.time.t]);
      else
        app.post(app);
      end
        end

        % Button pushed function: ReloadButton
        function reload_mode(app, event)
      app.set_mode;
        end

        % Value changed function: FilenameoptionEditField
        function set_file_name(app, event)
      app.data_file_name = app.FilenameoptionEditField.Value;
        end

        % Button pushed function: SavedataButton
        function save_data(app, event)
      app.logger.save(app.data_file_name);
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {904, 904, 904};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {904, 904};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {204, '1x', 565};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1620 904];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {204, '1x', 565};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create RunmodeListBoxLabel
            app.RunmodeListBoxLabel = uilabel(app.LeftPanel);
            app.RunmodeListBoxLabel.HorizontalAlignment = 'right';
            app.RunmodeListBoxLabel.Position = [7 859 60 22];
            app.RunmodeListBoxLabel.Text = 'Run mode';

            % Create RunmodeListBox
            app.RunmodeListBox = uilistbox(app.LeftPanel);
            app.RunmodeListBox.Items = {'Experiment', 'Simulation'};
            app.RunmodeListBox.ValueChangedFcn = createCallbackFcn(app, @switch_run_mode, true);
            app.RunmodeListBox.Position = [82 845 100 38];
            app.RunmodeListBox.Value = 'Simulation';

            % Create ModeDropDownLabel
            app.ModeDropDownLabel = uilabel(app.LeftPanel);
            app.ModeDropDownLabel.HorizontalAlignment = 'right';
            app.ModeDropDownLabel.Position = [7 816 35 22];
            app.ModeDropDownLabel.Text = 'Mode';

            % Create ModeDropDown
            app.ModeDropDown = uidropdown(app.LeftPanel);
            app.ModeDropDown.Items = {'Default'};
            app.ModeDropDown.ValueChangedFcn = createCallbackFcn(app, @change_mode, true);
            app.ModeDropDown.Position = [57 810 100 33];
            app.ModeDropDown.Value = 'Default';

            % Create ReloadButton
            app.ReloadButton = uibutton(app.LeftPanel, 'push');
            app.ReloadButton.ButtonPushedFcn = createCallbackFcn(app, @reload_mode, true);
            app.ReloadButton.Position = [57 782 100 23];
            app.ReloadButton.Text = 'Reload';

            % Create NumLabel
            app.NumLabel = uilabel(app.LeftPanel);
            app.NumLabel.Position = [20 750 104 22];
            app.NumLabel.Text = 'Num : ';

            % Create PlantLabel
            app.PlantLabel = uilabel(app.LeftPanel);
            app.PlantLabel.Position = [7 649 175 45];
            app.PlantLabel.Text = 'Plant';

            % Create SensorLabel
            app.SensorLabel = uilabel(app.LeftPanel);
            app.SensorLabel.Position = [7 555 175 47];
            app.SensorLabel.Text = 'Sensor';

            % Create ReferenceLabel
            app.ReferenceLabel = uilabel(app.LeftPanel);
            app.ReferenceLabel.Position = [7 461 175 47];
            app.ReferenceLabel.Text = 'Reference';

            % Create EstimatorLabel
            app.EstimatorLabel = uilabel(app.LeftPanel);
            app.EstimatorLabel.Position = [7 367 175 47];
            app.EstimatorLabel.Text = 'Estimator';

            % Create ControllerLabel
            app.ControllerLabel = uilabel(app.LeftPanel);
            app.ControllerLabel.Position = [7 274 175 47];
            app.ControllerLabel.Text = 'Controller';

            % Create Label
            app.Label = uilabel(app.LeftPanel);
            app.Label.Position = [20 14 162 202];
            app.Label.Text = '';

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.CenterPanel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [29 191 794 560];

            % Create StartButton
            app.StartButton = uibutton(app.CenterPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @start, true);
            app.StartButton.Position = [41 851 100 23];
            app.StartButton.Text = 'Start';

            % Create Lamp
            app.Lamp = uilamp(app.CenterPanel);
            app.Lamp.Position = [172 848 28 28];

            % Create LampLabel
            app.LampLabel = uilabel(app.CenterPanel);
            app.LampLabel.HorizontalAlignment = 'right';
            app.LampLabel.Position = [202 842 104 40];
            app.LampLabel.Text = 'Lamp';

            % Create DrawgraphButton
            app.DrawgraphButton = uibutton(app.CenterPanel, 'push');
            app.DrawgraphButton.ButtonPushedFcn = createCallbackFcn(app, @draw_data, true);
            app.DrawgraphButton.Position = [341 845 100 23];
            app.DrawgraphButton.Text = 'Draw graph';

            % Create TimeSliderLabel
            app.TimeSliderLabel = uilabel(app.CenterPanel);
            app.TimeSliderLabel.HorizontalAlignment = 'right';
            app.TimeSliderLabel.Position = [452 856 31 22];
            app.TimeSliderLabel.Text = 'Time';

            % Create TimeSlider
            app.TimeSlider = uislider(app.CenterPanel);
            app.TimeSlider.ValueChangingFcn = createCallbackFcn(app, @set_current_time, true);
            app.TimeSlider.Position = [504 866 284 3];

            % Create Label_2
            app.Label_2 = uilabel(app.CenterPanel);
            app.Label_2.Position = [51 782 432 43];
            app.Label_2.Text = '';

            % Create SavedataButton
            app.SavedataButton = uibutton(app.CenterPanel, 'push');
            app.SavedataButton.ButtonPushedFcn = createCallbackFcn(app, @save_data, true);
            app.SavedataButton.Position = [52 25 71 23];
            app.SavedataButton.Text = 'Save data';

            % Create FilenameoptionEditFieldLabel
            app.FilenameoptionEditFieldLabel = uilabel(app.CenterPanel);
            app.FilenameoptionEditFieldLabel.HorizontalAlignment = 'right';
            app.FilenameoptionEditFieldLabel.Position = [153 25 102 22];
            app.FilenameoptionEditFieldLabel.Text = 'File name (option)';

            % Create FilenameoptionEditField
            app.FilenameoptionEditField = uieditfield(app.CenterPanel, 'text');
            app.FilenameoptionEditField.ValueChangedFcn = createCallbackFcn(app, @set_file_name, true);
            app.FilenameoptionEditField.Position = [270 25 183 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.RightPanel);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [7 607 549 274];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.RightPanel);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [7 316 549 241];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.RightPanel);
            title(app.UIAxes4, 'Title')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [7 25 549 241];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SimExp(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end