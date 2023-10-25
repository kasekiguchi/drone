classdef TEMPLATE_REFERENCE < handle
  properties
    self
    result
  end

  methods
    function obj = TEMPLATE_REFERENCE(self,varargin)
      obj.self = self;
      obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
    end
    function  result= do(obj,varargin)
      result = obj.result;
    end

  end
end
