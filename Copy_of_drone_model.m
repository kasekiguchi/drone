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
    B
  end

  % Public, non-tunable properties

  % Discrete state properties
  properties (DiscreteState)
    state
    A
  end

  % Pre-computed constants or internal states

  methods
    % Constructor
    function obj = drone_model(varargin)
      % Support name-value pair arguments when constructing object
      setProperties(obj,nargin,varargin{:})
    end
  end

  methods (Access = protected)
    %% Common functions
    function setupImpl(obj,x0,A,B)
      arguments
        obj
        x0=[1;0];
        A = [1.0000,0.0100;0,1.0000];
        B = [0.0001;0.0100];
      end
      % Perform one-time calculations, such as computing constants
      obj.state = x0;
      obj.A = A;
      obj.B = B;
      % obj.A = [1.0000,0.0100;0,1.0000];
      % obj.B = [0.0001;0.0100];
    end

    function [state,A] = stepImpl(obj,u)
      % Implement algorithm. Calculate y as a function of input u and
      % internal or discrete states.
      state = obj.A*obj.state + obj.B*u(1);
      obj.state = state(1:2,:);
      A = eye(2);
    end

    function resetImpl(obj)
      % Initialize / reset internal or discrete properties
      obj.state = [1;0];
      obj.A = [1.0000    0.0100;         0    1.0000];
      obj.B = [   0.0001;    0.0100];
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
    function ds = getDiscreteStateImpl(obj)
      % Return structure of properties with DiscreteState attribute
      %ds = struct('state',obj.state);
      ds.state = obj.state;
      ds.A = obj.A;
    end


    function [out,out1] = getOutputSizeImpl(obj)
      % Return size for each output port
      out = [2 1];
      out1 = [2,2];

      % Example: inherit size from first input port
      % out = propagatedInputSize(obj,1);
    end

    function [out,out1] = getOutputDataTypeImpl(obj)
      % Return data type for each output port
      out = "double";
      out1 = "double";
      % Example: inherit data type from first input port
      % out = propagatedInputDataType(obj,1);
    end

    function [out,out1] = isOutputComplexImpl(obj)
      % Return true for each output port with complex data
      out = false;
      out1 = false;

      % Example: inherit complexity from first input port
      % out = propagatedInputComplexity(obj,1);
    end

    function [out,out1] = isOutputFixedSizeImpl(obj)
      % Return true for each output port with fixed size
      out = true;
      out1 = true;

      % Example: inherit fixed-size status from first input port
    %  out = propagatedInputFixedSize(obj,1);
    end

    function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
      % Return size, data type, and complexity of discrete-state
      % specified in name
      switch name
        case "state"
          sz = [2 1];
          dt = "double";
          cp = false;
        case "A"
          sz = [2 2];
          dt = "double";
          cp = false;
      end
    end

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
