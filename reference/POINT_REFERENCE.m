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
            % obj.result.state = STATE_CLASS(struct('state_list',["p","v"],'num_list',[3,3]));
            obj.result.state = STATE_CLASS(struct('state_list',["p","q","v"],'num_list',[3,3]));
            obj.param = varargin;
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            obj.result.state.p = obj.param{1};
            obj.result.state.q = obj.param{2};
            obj.result.state.v = obj.param{3};

            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end
