classdef POINT_REFERENCE < handle
    properties
        param
        self
        result
    end
    
    methods
        function obj = POINT_REFERENCE(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v"],'num_list',[3,3]));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            obj.result.state.p = varargin{end};
            obj.result.state.v = [0;0;0];
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end
