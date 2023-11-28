classdef POINT_REFERENCE < handle
    properties
        param
        func
        self
        result
    end
    
    methods
        function obj = POINT_REFERENCE(self,args)
            % 参照
            obj.self = self;
            gen_func_name = str2func(args{1});
            param_for_gen_func = args{2};
            obj.func = gen_func_name(param_for_gen_func{:});
%             obj.result.state = STATE_CLASS(struct('state_list', ["xd", "p", "q", "v"], 'num_list', [length(obj.func(0)), 3, 3, 3]));
%             obj.result.state.set_state("xd",obj.func(0));
%             obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
%             obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
%             obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
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
