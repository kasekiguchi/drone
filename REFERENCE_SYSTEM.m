classdef REFERENCE_SYSTEM < matlab.System
  % untitled Add summary here
  %
  % This template includes the minimum set of functions required
  % to define a System object.

  % Public, tunable properties
  properties (DiscreteState)
  end

  % Pre-computed constants or internal states
  properties (Access = private)
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    t0 
    %func
    result = struct("state",struct("xd",zeros(20,1),"p",zeros(3,1),"v",zeros(3,1),"q",zeros(3,1)));
  end
methods
  function obj = REFERENCE_SYSTEM(varargin)
      % obj.self = self;
      % obj.param = param;
      % Perform one-time calculations, such as computing constants
      setProperties(obj,nargin,varargin{:})
      %obj.result.input = zeros(4,1);
    end
end
  methods (Access = protected)

    function setupImpl(obj)
        % tmp=coder.load("rparam.mat");
        % obj.param = tmp.param;
        %obj.func = tmp.func;
        %obj.result = tmp.result;
        obj.t0 = 0;
    end
    function result = stepImpl(obj,time)
      % Implement algorithm. Calculate y as a function of input u and
      % internal states.
           %obj.cha = varargin{2};
           % if obj.cha=='f'&& ~isempty(obj.t0)    %flightからreferenceの時間を開始
           %      t = time-obj.t0; % 目標重心位置（絶対座標）
           % else
           %      obj.t0=time;
           %      t = obj.t0;
           % end
           t = time-obj.t0; 
           obj.result.state.xd = test_func(t); % 目標重心位置（絶対座標）
           obj.result.state.p = obj.result.state.xd(1:3);
           if length(obj.result.state.xd)>4
            obj.result.state.v = obj.result.state.xd(5:7);
           else
            obj.result.state.v = [0;0;0];
           end
           obj.result.state.q(3,1) = atan2(obj.result.state.v(2),obj.result.state.v(1));
           result = obj.result;
        end

    function resetImpl(obj)
        obj.input = [0;0;0;0];
      % Initialize / reset internal properties
    end
  end
end
