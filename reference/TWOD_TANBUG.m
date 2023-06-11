classdef TWOD_TANBUG < handle
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        param
        self
        result
    end

    methods
        function obj = TWOD_TANBUG(self, varargin)
            obj.self=self;
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3, 3]));            
        end
        function result = do(obj, Param)  
           obj.result.state.p = obj.self.estimator.result.state.p;
           obj.result.state.v = obj.self.estimator.result.state.v;
           result = obj.result;     
        end
        function show(obj,~)
        end
    end
end
