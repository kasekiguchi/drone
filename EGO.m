classdef (StrictDefaults) EGO < matlab.System
  % untitled3 Add summary here
  %
  % NOTE: When renaming the class name untitled3, the file name
  % and constructor name must be updated to use the class name.
  %
  % This template includes most, but not all, possible properties, attributes,
  % and methods that you can implement for a System object in Simulink.

  % Public, tunable properties
  properties (Access='private')
    controller
    estimator
    reference
    % sensor
    %parameter
  end

  % Public, non-tunable properties
  properties (Nontunable)

  end

  % Discrete state properties
  properties (DiscreteState)
    control_signal
    publish_message
  end
  properties (Constant)
    initial_control_signal = [0;0;0;0];
  end

  % Pre-computed constants or internal states
  properties (Access = private)
    sresult
    eresult
    rresult
    cresult
  end

  methods
    % Constructor
    function obj = EGO(varargin)
      % Support name-value pair arguments when constructing object
      setProperties(obj,nargin,varargin{:})
    end
  end

  methods (Access = protected)
    %% Common functions
    function setupImpl(obj)
      %setting = coder.load("setting.mat");
      %params = setting.agent;
      obj.control_signal = obj.initial_control_signal;
      obj.publish_message = 0;
      %obj.parameter = PARAMETER_SYSTEM;%("self",obj,"param",params.parameter);
      %%obj.parameter.setupImpl(params.parameter);
      %obj.sensor = SENSOR_SYSTEM("self",obj,"param",params.sensor);
      obj.estimator = ESTIMATOR_SYSTEM();
      obj.controller = CONTROLLER_SYSTEM();
      obj.reference = REFERENCE_SYSTEM();
      setup(obj.estimator);
      setup(obj.controller);
      setup(obj.reference);
    end

    function [u,pub] = stepImpl(obj,state,t)
      % Implement algorithm. Calculate y as a function of input u and
      % internal or discrete states.
      disp(t)
      sstate.p = state(5:7,1);
      sstate.q = state(1:4,1);
      sstate.v = state(8:10,1);
      sstate.w = state(11:13,1);
      y = [sstate.p;Quat2Eul(sstate.q)];      
      obj.eresult = obj.estimator.stepImpl(t,y,obj.control_signal);
      obj.rresult = obj.reference.stepImpl(t);
      ex = obj.eresult.state;
      x = [Eul2Quat(ex(4:6,1));ex(1:3,1);ex(7:9,1);ex(10:12,1)];
      x = state;
      obj.control_signal = obj.controller.stepImpl(x,obj.rresult.state.xd);
      u = obj.control_signal;    
      pub = [sstate.p;ex(1:3)];%obj.rresult.state.xd(1:4);%obj.publish_message;
    end

    function resetImpl(obj)
      % Initialize / reset internal or discrete properties
      obj.control_signal = [0;0;0;0];
      obj.publish_message = 0;
    end

    %% Backup/restore functions
    function s = saveObjectImpl(obj)
      % Set properties in structure s to values in object obj

      % Set public properties and states
      s = saveObjectImpl@matlab.System(obj);

      % Set private and protected properties
      %s.myproperty = obj.myproperty;
    end

    function loadObjectImpl(obj,s,wasLocked)
      % Set properties in object obj to values in structure s

      % Set private and protected properties
      % obj.myproperty = s.myproperty; 

      % Set public properties and states
      loadObjectImpl@matlab.System(obj,s,wasLocked);
    end

    %% Simulink functions

    function icon = getIconImpl(obj)
      % Define icon for System block
      icon = mfilename("class"); % Use class name
      % icon = "My System"; % Example: text icon
      % icon = ["My","System"]; % Example: multi-line text icon
      % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
    end
  end

  methods (Static, Access = protected)
    %% Simulink customization functions
    function header = getHeaderImpl
      % Define header panel for System block dialog
      header = matlab.system.display.Header(mfilename("class"));
    end

    function group = getPropertyGroupsImpl
      % Define property section(s) for System block dialog
      group = matlab.system.display.Section(mfilename("class"));
    end
  end
end
