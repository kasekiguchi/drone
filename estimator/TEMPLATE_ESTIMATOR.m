classdef TEMPLATE_ESTIMATOR < handle
    
    properties
        result
        self
        model
    end
    
    methods
        function obj = TEMPLATE_ESTIMATOR(self,param)
            % template class for estimator
            obj.self = self; % agent that 
            obj.model = param.model;
            obj.result.state=state_copy(model.state);
        end
        
        function result=do(obj,varargin)
            result=obj.result;
        end
    end
end

