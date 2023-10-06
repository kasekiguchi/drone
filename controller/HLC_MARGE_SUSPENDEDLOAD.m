classdef HLC_MARGE_SUSPENDEDLOAD < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
  end

  methods
    function obj = HLC_MARGE_SUSPENDEDLOAD(self)
      obj.self = self;
      
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
        %obj.self ->drone,load
        result = merge_result(obj.self.marge.drone.result.input,obj.self.marge.load.result.input);
%         controller = varargin{5}.sensor;
%         result = controller.drone(varargin);
%         result = merge_result(result,controller.load.do(varargin));
%         varargin{5}.sensor.result = result;
        obj.reslt =result;

%       obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
%       result = obj.result;
    end
  end
end
