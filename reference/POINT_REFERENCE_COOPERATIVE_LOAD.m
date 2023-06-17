classdef POINT_REFERENCE_COOPERATIVE_LOAD < handle
    properties
        param
        self
        result
    end
    
    methods
        function obj = POINT_REFERENCE_COOPERATIVE_LOAD(self,varargin)
            % 参照
            obj.self = self;
            obj.result.state = STATE_CLASS(struct('state_list',["p","v","Q","O"],'num_list',[3,3,4,3]));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
%             obj.result.state.p = varargin{end};
            obj.result.state.p = [1;0;1];
            obj.result.state.v = [0;0;0];
            obj.result.state.Q = [0;0;0];
            obj.result.state.O = [0;0;0];
            %一旦ペイロードのみのreferenceを作成
            result=obj.result;
        end
        function show(obj,param)
            
        end
    end
end
