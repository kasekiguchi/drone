classdef PARAMETER_SYSTEM < matlab.System
  % untitled4 Add summary here
  %
  % This template includes the minimum set of functions required
  % to define a System object.

  % Public, tunable properties
  properties
        parameter % 制御モデル用パラメータ : 値ベクトル
        parameter_name % 物理パラメータの名前
        parameter_raw
        type
        additional
  end

  % Pre-computed constants or internal states
  properties (Access = private)

  end

  methods (Access = protected)
    function setupImpl(obj,param)
      % Perform one-time calculations, such as computing constants
      obj.parameter = param.parameter;
      obj.parameter_name = param.parameter_name;
      obj.parameter_raw = param.parameter_raw;
      obj.type = param.type;
      if isfield(param,'additional')
      obj.additional = param.additional;
      end
    end

    function y = stepImpl(obj,u)
      % Implement algorithm. Calculate y as a function of input u and
      % internal states.
      y = u;
    end

    function resetImpl(obj)
      % Initialize / reset internal properties
    end
  end
end
