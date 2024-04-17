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
    sensor
    parameter = struct("raw",struct(),"values",[]);
    sresult
    eresult
    rresult
    cresult
    dt
    state
    control_signal
    publish_message
  end

  % Public, non-tunable properties
  properties (Nontunable)

  end

  % Discrete state properties
  % properties (DiscreteState)
  % end
  properties (Constant)
  end

  % Pre-computed constants or internal states
  properties (Access = protected)
         OutputBusName = 'myOutBus';%'bus_name'; 
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
    function setupImpl(obj) % 初期化
      setting = coder.load("setting.mat");
      obj.dt = setting.dt;
      obj.state = setting.x0;
      obj.control_signal = setting.u0;
      obj.parameter.values = setting.parameter.values;
      obj.publish_message = 0;

      obj.estimator = ESTIMATOR_SYSTEM();
      obj.controller = CONTROLLER_SYSTEM();
      obj.reference = REFERENCE_SYSTEM();
      initial_state_eul = [obj.state(5:7);Quat2Eul(obj.state(1:4));obj.state(8:13)];
      setup(obj.estimator,obj.dt,initial_state_eul,obj.parameter.values,setting.eparam);
      setup(obj.reference,obj.dt,setting.rparam);
      setup(obj.controller,obj.dt,setting.cparam);
    end

    function [u,pub] = stepImpl(obj,state,t) % 各時刻実行
      % Implement algorithm. Calculate y as a function of input u and
      % internal or discrete states.
      disp(t)
      if t>100
        t
      end
      %obj.state = state;
      sstate.p = obj.state(5:7,1);
      sstate.q = obj.state(1:4,1);
      sstate.v = obj.state(8:10,1);
      sstate.w = obj.state(11:13,1);
      y = [sstate.p;Quat2Eul(sstate.q)];      
      obj.eresult = obj.estimator.stepImpl(t,y,obj.control_signal);
      %ex = obj.eresult.state;
      x = translate_state(obj.eresult.state,obj.estimator.type,obj.controller.type);
      obj.rresult = obj.reference.stepImpl(t,x);
      %obj.rresult.state.xd = zeros(20,1);
      obj.cresult = obj.controller.stepImpl(x,obj.rresult.state.xd);
      obj.state = state;
      obj.control_signal = obj.cresult.input;
      u = obj.control_signal;    
      pub.rresult = obj.rresult;
      pub.eresult.state = obj.eresult.state;
      pub.eresult.P = obj.eresult.P;
    %  pub.eresult.G = obj.eresult.G;
      pub.cresult = obj.cresult;
    %  pub = [y(1:3);ex(1:3);obj.rresult.state.xd(1:3)];%;ex(1:3)];%obj.rresult.state.xd(1:4);%obj.publish_message;
    
    end

    function resetImpl(obj) % リセット
      % Initialize / reset internal or discrete properties
      setting = coder.load("setting.mat");
      obj.parameter.values = setting.parameter.values;
      obj.state = setting.x0;
      obj.control_signal = setting.u0;

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

    function [out,out1] = getOutputSizeImpl(obj)
      out = [4 1];
      out1 = [1 1];%propagatedInputSize(obj, 1);
    end
    
    function [out,out1] = isOutputComplexImpl(obj)
      out = propagatedInputComplexity(obj, 1);
      out1 = propagatedInputComplexity(obj, 1);
    end
    
    function [out,out1] = getOutputDataTypeImpl(obj)
      out = "double";
      out1 = obj.OutputBusName;
    end
    
    function [out,out1] = isOutputFixedSizeImpl(obj)
      out = propagatedInputFixedSize(obj, 1);
      out1 = propagatedInputFixedSize(obj, 1);
    end

  end
end
