classdef CONTROLLER_SYSTEM < matlab.System
  % untitled Add summary here
  %
  % This template includes the minimum set of functions required
  % to define a System object.

  % Public, tunable properties
  properties (DiscreteState)
    input
  end

  properties (Access = public)
     type
  end
  % Pre-computed constants or internal states
  properties (Access = private)
    param
    dt
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    result
  end
methods
  function obj = CONTROLLER_SYSTEM(varargin)
      % Perform one-time calculations, such as computing constants
      setProperties(obj,nargin,varargin{:})
  end
end
  methods (Access = protected)

    function setupImpl(obj,dt,cparam)
      obj.param = cparam;
      obj.dt = dt;
      obj.type = cparam.type;
      obj.result.input = zeros(4,1);
    end
    function result = stepImpl(obj,x,xd)
      result = obj.stepImpl_entity(x,xd);
    end
    function resetImpl(obj)
        obj.input = [0;0;0;0];
      % Initialize / reset internal properties
    end
  function num = getNumInputsImpl(~)
      num = 2;
  end    
  end
end
