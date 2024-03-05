classdef (StrictDefaults) drone_model < matlab.System
  % untitled6 Add summary here
  %
  % NOTE: When renaming the class name untitled6, the file name
  % and constructor name must be updated to use the class name.
  %
  % This template includes most, but not all, possible properties, attributes,
  % and methods that you can implement for a System object in Simulink.

  % Public, tunable properties
  properties (Access=private)
    P
    A
    B
    parameter
    controller
    dt
  end

  % Public, non-tunable properties
  properties (Access=public,Constant)
    %P = [0.5000    0.1600    0.1600    0.0800    0.0800    0.0600    0.0600    0.0600    9.8100    0.0301    0.0301    0.0301    0.0301    0.0000    0.0000    0.0000    0.0000    0.0392];
  end

  % Discrete state properties
  %properties (ContinuousState)
  properties (DiscreteState)
    state
  end

  % Pre-computed constants or internal states
  properties (Access=protected)
    initial_state
  end

  methods
    % Constructor
    function obj = drone_model(varargin)
      % Support name-value pair arguments when constructing object
      setProperties(obj,nargin,varargin{:})
    end
  end
methods(Static)
      function p = get(obj,name)
      p = obj.(name);
      end
end
  methods (Access = protected)
    %% Common functions
    function setupImpl(obj,~)
      %      disp(a);
      setting = coder.load("plant_setting.mat");
      obj.dt = setting.dt;
      obj.P = setting.parameter.values;
      % Perform one-time calculations, such as computing constants
      obj.initial_state = setting.x0;
      obj.state = obj.initial_state;
    end

    function next_state = stepImpl(obj,u)
      % Implement algorithm. Calculate y as a function of input u and
      % internal or discrete states.
      %obj.state = obj.A*obj.state(1:2,1) + obj.B*u(1);
      %next_state = obj.state(1:2,1);
      % %A = eye(2);
      arguments
        obj
        u (4,1) {mustBeNumeric}
      end
      [~,X] = ode15s(@(t,x)euler_parameter_thrust_torque_physical_parameter_model(x,u,obj.P),[0,obj.dt],obj.state);
      obj.state = X(end,:)';
      next_state = obj.state;
    end

    function resetImpl(obj)
      % Initialize / reset internal or discrete properties
      obj.state = obj.initial_state;
      % obj.A = [1.0000    0.0100;         0    1.0000];
      % obj.B = [   0.0001;    0.0100];
      % obj.A = [0 1;0 0];
      % obj.B = [0;1];
    end



    function icon = getIconImpl(obj)
      % Define icon for System block
      icon = mfilename("class"); % Use class name
      % icon = "My System"; % Example: text icon
      % icon = ["My","System"]; % Example: multi-line text icon
      % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
    end

    function out1 = getOutputDataTypeImpl(obj)
      % Return data type for each output port
      out1 = "double";
      %out2 = "double";
      % Example: inherit data type from first input port
      % out1 = propagatedInputDataType(obj,1);
      % out2 = propagatedInputDataType(obj,2);
    end

    function out1 = isOutputComplexImpl(obj)
      % Return true for each output port with complex data
      out1 = false;
      %out2 = false;
      % Example: inherit complexity from first input port
      % out1 = propagatedInputComplexity(obj,1);
      % out2 = propagatedInputComplexity(obj,2);
    end

    %function [out1,out2] = isOutputFixedSizeImpl(obj)
    function out1 = isOutputFixedSizeImpl(obj)
      % Return true for each output port with fixed size
      out1 = true;
      %out2 = true;

      % Example: inherit fixed-size status from first input port
      %out1 = propagatedInputFixedSize(obj,1);
      %out2 = propagatedInputFixedSize(obj,2);
    end
    function num = getNumInputsImpl(~)
      num = 1;
    end
    function [sz,dt,cp] = getDiscreteStateSpecificationImpl(~,~)
      sz = [13 1];
      dt = "double";
      cp = false;
    end
  end
  methods (Static, Access = protected)
    %% Simulink customization functions
    function header = getHeaderImpl
      % Define header panel for System block dialog
      header = matlab.system.display.Header(mfilename("class"));
    end
    function sz_1 = getOutputSizeImpl(obj)
      sz_1 = [13 1];
    end
  end
end
