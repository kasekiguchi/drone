classdef (StrictDefaults)slexBusesMATLABSystemMathOpSysObj < matlab.System
%slexBusesMATLABSystemMathOpSysObj Performs math operations on bus input.

%#codegen
% Copyright 2015 The MathWorks, Inc.
  properties(Access=protected)
     OutputBusName = 'myOutBus';%'bus_name'; 
  end

  methods
    function obj = slexBusesMATLABSystemMathOpSysObj(varargin)
      % Support name-value pair arguments
      setProperties(obj,nargin,varargin{:});
    end    
  end
 
  methods (Access=protected)
      
    function icon = getIconImpl(~)
              icon = sprintf('Math\nOperations');
    end
    
     % Error handling for input values
    function validateInputsImpl(~,in)
       if  ~isstruct(in)
              error(message('simdemos:MLSysBlockMsg:BusInput'));
       end
       
       if (~(isfield(in,'a') && isfield(in,'b')))
            error(message('simdemos:MLSysBlockMsg:InputBusElements'));
       end
    end
        
    function out = stepImpl(~, in)
      out.sum  = in.a + in.b;
      out.prod = in.a * in.b;
      out.diff = in.a - in.b;
    end

    function out = getOutputSizeImpl(obj)
      out = propagatedInputSize(obj, 1);
    end
    
    function out = isOutputComplexImpl(obj)
      out = propagatedInputComplexity(obj, 1);
    end
    
    function out = getOutputDataTypeImpl(obj)
      out = obj.OutputBusName;
    end
    
    function out = isOutputFixedSizeImpl(obj)
      out = propagatedInputFixedSize(obj, 1);
    end
  end
end
